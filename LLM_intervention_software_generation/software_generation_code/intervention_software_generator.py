import json
import time
import os
import api_key as key
import openai
from openai import OpenAI

def queryLLM(system_prompt, user_prompt, json_bool=False, max_retries=3):
    retries = 0
    while retries < max_retries:
        try:
            client = OpenAI(
            api_key= key.GROK,
            base_url="https://api.x.ai/v1",
            )
            
            chat = client.chat.completions.create(
            model="grok-3-beta",
            messages= [ 
            {
                "role": "system",
                "content": system_prompt
            },
            {
                "role": "user",
                "content": user_prompt
            }]
            )
            output = chat.choices[0].message.content

            if json_bool:
                try:
                    return json.loads(output)
                except json.JSONDecodeError as e:
                    print("scenic_writer.py")
                    print("Error decoding JSON response:", e)
                    # Print raw response for debugging
                    print("Raw output:", output)
                    return None
            return output

        except json.JSONDecodeError:
            print("PLEASE MAKE SURE YOU ADDED YOUR GROK API key to the api_key.py file. Then, restart the notebook.")
            print("Warning: JSON decoding failed, retrying...")
        except openai.OpenAIError as e:
            print("PLEASE MAKE SURE YOU ADDED YOUR GROK API key to the api_key.py file. Then, restart the notebook.")
            print(f"OpenAI API error: {e}, retrying...")
        except Exception as e:
            print("PLEASE MAKE SURE YOU ADDED YOUR GROK API key to the api_key.py file. Then, restart the notebook.")
            print(f"Unexpected error: {e}, retrying...")

        retries += 1
        time.sleep(2 ** retries)  # Exponential backoff

    raise RuntimeError("queryLLM failed after multiple retries")


def software_generator(json_file, actions_path, scenic_example_files, model_file_path):
    """
    Prompts an LLM to generate a Scenic program from annotations and therapist's instructions. 

    Inputs:
    1. transcript (str): The transcript of therapist which includes verbal instructions
    2. actions_path (str): path to the python script with the library of APIs
    3. scenic_examples_path (str): path to the scenic examples
    """

    with open(actions_path, "r") as file:
        apis = file.read()

    file_contents = []

    for file_path in scenic_example_files:
        with open(file_path, 'r') as file:
            content = file.read()
            file_contents.append(content)

    models = None
    with open(model_file_path, "r") as file:
        models = file.read()

    system_prompt = f'''
    You are a helpful coding assistant with knowledge in physical and occupational therapy. 
    Your overall task is to output a program that can (a) instruct exercise, (b) monitor patient movement, and (c) log the patient's performance. 
    You need to program using a domain-specific programming language called Scenic whose syntax and semantics are embedded in Python. 
    
    You are given:\n
    1) A json containing a transcript of instructions from a physical or occupational therapist to a patient regarding a personalized physical
    rehabilitation exercise. \n
    2) URLs to tutorials on Scenic programming language with which you need to generate the output program, \n
    3) A library of APIs which can be used to instruct, monitor, and log information about patient's exercises. \n
    4) Examples of Scenic programs whose structure you need to reference when programming,\n
    
    *** Context of the Program Use: \n
    Note that the Scenic program you output will be executed on an augmented reality (AR) headset. 
    The patient will be wearing the headset as your program instruct, monitor, and log the patient's exercises. 
    The headset has a built-in body pose estimation (BPE) model which tracks the patient's joint positions, e.g. finger, wrist, elbow positions,
    Also, the headset provides joint angle information, finger, wrist, elbow flexion/extension angles. 
    The headset also has an embedded camera which the provided two APIs, i.e. 'SendImageAndTextRequestAction' or 'RecordVideoAndEvaluateAction',
    can access to capture an image or a video and query a vision language model to monitor whether an instruction is followed. 
    Since the camera is on the headset, facing away from the patient, the camera only partially captures the patient's body, namely
    hand, wrist, and forearm, but may likely not capture elbows, shoulders, and upper torso. 

    *** Regarding APIs for Monitoring Patient's Exercise:
    The provided APIs related to monitoring utilize either the BPE or the camera data from the AR headset. 
    The APIs accessing the BPE information, or 'BPE APIs' for brevity, are much more accurate in monitoring 'static' conditions related to
    joint angles and positions than the APIs accessing the camera data, or 'visual APIs' for brevity. Note that the BPE APIs
    do not reason about a history of BPE information. Therefore, you should only use visual APIs to monitor conditions that 
    cannot be checked by the BPE APIs.

    Meanwhile, the BPE APIs cannot reason about the patient's interaction with any objects in the environment, e.g. table, cup.
    Thus, you should select the APIs with this context in mind to maximize the correctness of the program's monitoring.
    Make sure you 'separate' the conditions in each instruction step according to the strengths of each of the APIs you invoke.
    For example, suppose the instruction to monitor is 'extend your right arm to grasp a pen.' 
    Then, the most optimal way is to use SendImageAndTextRequestAction('grasp a pen with the right hand') 
    to check the condition on the patient's interaction with the pen, 
    and use 'CheckElbowExtension()' API to check right arm extension. The conjunction of these two conditions 
    should be monitored for the best monitoring outcome. *** It is important that you remove the elbow extension condition from the instruction
    to SendImageAndTextRequestAction() to only check conditions that BPE APIs cannot monitor to maximize monitoring correctness. 
    Otherwise, the conjunction of the two conditions may result in a sub-optimal monitoring outcome. \n
    
    Note that there are two types of visual APIs: 'SendImageAndTextRequestAction' or 'RecordVideoAndEvaluateAction.'
    One captures an image while the other captures a video and query a vision language model to monitor an instruction. 
    You will need to select which visual API to use based on the condition you need to monitor. 
    If the instruction cannot be checked with a single image, e.g. \n
    Example 1: 'move your hand in a circular motion' where you need to observe a sequence of images to determine the shape of the motion \n
    Example 2: 'hold your hand in the air for 5 seconds' where you should observe for a duration of time\n
    then use the 'RecordVideoAndEvaluateAction'; otherwise, by default, use 'SendImageAndTextRequestAction.' \n
    *** Try to use the 'SendImageAndTextRequestAction' API as much as possible, since it is 
    more efficient and less resource-intensive than the 'RecordVideoAndEvaluateAction' API.
    *** It is important to note that the objective of monitoring is to check whether the patient "completed" each instruction step. 
    This means, often times, you simply want to check the "end state" of an instruction to check its completion. 
    Example 1: if the instruction states 'pick up a pen,' then you just need a snapshot of an image of a hand holding a pen in the air. 
    Example 2: if the instruction states 'open your bag,' then you just need a snapshot of an image of an open bag.
    Therefore, many of the conditions can be monitored using 'SendImageAndTextRequestAction.'

    *** When you generate the Scenic program:\n
    1. You should use the exact same instructions as provided in the json. Do not change the wording or phrasing of the instructions.
       And, use the same order of instructions as in the json.\n
    2. It is very important that, whenever the therapist instructs the patient to 'repeat' certain steps, 
       you should identify the scope of 'which' steps are to be repeated and convert that instruction into a for-loop in the Scenic program. 
       And, within the for-loop, make sure you instruct each step again as shown in the example Scenic programs. \n
    
    Please reference the provided examples of Scenic programs to understand how to instruct, monitor, and log the patient's performance.
    '''
    scene_tutorial = "https://docs.scenic-lang.org/en/latest/tutorials/fundamentals.html"
    behavior_tutorial = "https://docs.scenic-lang.org/en/latest/tutorials/dynamics.html"

    user_prompt = f'''
    Please return a Scenic program after referencing the following: \n\n
    1. Here is the transcript of step-by-step instructions on a physical rehabilitation exercise: {json_file}, \n
    2. URL to a tutorial on setting up a static environment in Scenic: {scene_tutorial}. 
    It is very important to specify a property (e.g. pitch, yaw, roll) of an object using `with` syntax! \n 
    3. URL to a tutorial on constructing a behavior in Scenic: {behavior_tutorial}, \n
    4. A library of APIs: {apis}, \n
    5. Examples of Scenic programs: {file_contents}, \n

    You should return a Scenic program in string, without any additional text or comments. 
    Do not include any header like ```python. 
    Just return the Scenic program as a string such that it can be directly written to a file and be executed.
    '''

    return queryLLM(system_prompt, user_prompt)


class Synth:
    """
    The class object's functions are used:
    1) to parse the given the therapist's annotations from the WebGL
    2) synthesize a Scenic program

    Input Arguments:
    1. annotations from the WebGL
        We assume that the annotations are given as a nested dictionary of the following form:
        {
            "setup" (list) : dictionary of the form {"obj name": coordinate} ,
            "instruction" (str) : a list of descriptions of instructions 
                                    (the indices of this list represents the order of instructions)
            "monitor" (str) : a list of physical conditions to monitor for each instruction
                                (the indices of this list correspond to each description in the instruction list)
        }

    2. save_file_path (str): the path to save the synthesized Scenic program
    3. model_file_path (str): the path to model.scenic
    4. api_file_path (str): the path to python script with a library of APIs
    """

    def __init__(self, annotations, model_file_path, api_file_path, example_scenic_programs_path):
        if "ego" not in annotations["setup"]:
            annotations["setup"]["ego"] = [[0, 0, 0], [0, 0, 0]]
        self.annotations = annotations
        self.others = {}
        for key in annotations:
            if key == "setup":
                self.obj_dict = {obj: {"position": obj_data[0], "rotation": obj_data[1]}
                                 for obj, obj_data in annotations["setup"].items()}
            elif key == 'instruction':
                self.instruction_list = annotations['instruction']
            else:
                self.others[key] = annotations[key]
        # self.save_file_path = save_file_path
        self.model_file_path = model_file_path
        self.api_file_path = api_file_path
        # self.log_file_path = log_file_path
        self.obj_list = list(self.obj_dict.keys())
        self.env_object_list = ["Shelf", "Box", "ego"]
        self.scenic_files = [
            os.path.join(example_scenic_programs_path, f)
            for f in os.listdir(example_scenic_programs_path)
            if os.path.isfile(os.path.join(example_scenic_programs_path, f))
        ]

    def synthesize(self):
        # # write scenic program
        program = software_generator(
            self.annotations, self.api_file_path, self.scenic_files, self.model_file_path)
        # print(program)
        return program

def generate_intervention_software(file_name):
    current_dir = current_dir = os.getcwd()
    parent_dir = os.path.dirname(current_dir)
    json_name = f"json/{file_name}.json"
    json_file_path = os.path.join(current_dir, json_name)
    print("Generating Scenic program", json_file_path)
    
    with open(os.path.join(current_dir, json_name), 'r') as file:
        annotations = json.load(file)
        model_file_path = os.path.join(
            parent_dir, "Scenic-main", "Scenic", "src", "scenic", "simulators", "unity", "model.scenic")
        api_file_path = os.path.join(
            parent_dir, "Scenic-main", "Scenic", "src", "scenic", "simulators", "unity", "actions.py")
        save_file_path = os.path.join(current_dir, "scenic_output", f"{file_name}" + ".scenic")
        example_scenic_programs_path = os.path.join(current_dir, "example_scenic_program")
        log_file_path = os.path.join(current_dir, "logs", f"{file_name}" + ".json")
    
        synth = Synth(annotations, 
                      model_file_path, 
                      api_file_path,
                      example_scenic_programs_path)
        program = synth.synthesize()
    
        with open(save_file_path, 'w') as scenic_file:
            scenic_file.write(program)
        print("Intervention software generated in `scenic_output` folder")
        