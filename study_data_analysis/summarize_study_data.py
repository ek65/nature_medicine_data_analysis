import os
import json
import pandas as pd
import numpy as np
import pandas as pd
import statsmodels.api as sm
from statsmodels.genmod.cov_struct import Exchangeable
from statsmodels.formula.api import gee
from scipy.special import expit          # inverse-logit
from scipy.stats import norm
from statsmodels.formula.api import mixedlm
from statsmodels.genmod.generalized_estimating_equations import GEE
from statsmodels.genmod.families import Binomial


def summarize_study_data(directory_path):
    """
    This function takes a path to a directory which contains a set of sub-directories, and saves a dataframe to a csv file named 'data_for_ICC.csv' in the same directory as the script.
    Each sub-directory consists of the same file structure. 
    This function should access each sub-directory and access its sub-directory called 'results'.
    Create a panda dataframe with the following columns:
    - 'therapistID': the name of the sub-directory (e.g. 'P1', 'P2', etc.)
    - 'exerciseID': the name of the json file being read (e.g. 'exercise1' or 'exercise2'). make sure to remove '.json' from the file name.
    - 'instruction_step': (equivalent to instructionID) index of the instruction step (e.g. 0, 1, 2, ..., 10)
    - 'correct': 0 or 1 (whether the monitored data matches the therapist's pre-labeled data)
    - 'truth': 0 or 1 

    Then, read the json files in the 'results' sub-directory and process the data in the following way and record and save the processed data as a csv file:
    - Import the json as a Python dictionary
    - Access the dictionary's 'therapistReport' key whose value is another dictionary. 
    - Then, access the 'successfulInstructions' key in the 'therapistReport' dictionary whose value is a list of booleans.
    - In this list, the index of the boolean value corresponds to the instruction step (e.g. 0, 1, 2, ..., 10). Let's call this list 'therapistList'.
    - For each boolean value in the list, set the 'instruction_step' to the index of the boolean value in the list.    
    
    - From the json Python dictionary, access the dictionary's 'llmReport' key whose value is another dictionary.
    - Then, access the 'successfulInstructions' key in the 'llmReport' dictionary whose value is a list of booleans with the same length of booleans as in the list of 'successfulInstructions' key's value in the 'therapistReport' dictionary.
    - Let's call this list 'llmList'.
    - In the llmList, for each boolean value, set the 'truth' value of the panda dataframe to 1 if the boolean value is True, and 0 if the boolean value is False.
    - Then, compare the boolean values between the two boolean lists, therapistList and llmList.
    - For each index in the lists, if the corresponding boolean value in the therapistList and llmList match, set the 'correct' value of the panda dataframe to 1, otherwise set it to 0.

    - Populate the dataframe with the therapistID, exerciseID, the instruction step, the 'correct' value, and the 'truth' value.

    Each json file may contain multiple instruction steps, so the dataframe should have multiple rows for each json file, one for each instruction step.

    Finally, save the dataframe to a csv file named 'study_data_summary.csv' in the same directory as the script.
    Make sure that the sub-directories are sorted numerically based on the number after 'P' in their names (e.g. 'P1', 'P2', ..., 'P10', etc.) in the csv.
    Do not consider sub-directories that are not folders, e.g. exclude files like 'DS_Store' or other non-directory files.
    Also, make sure the exerciseID is reported in sorted order, e.g. 'exercise1', 'exercise2', etc.
    """
    data = []
    
    # Get all sub-directories in the given directory
    sub_dirs = [d for d in os.listdir(directory_path) if os.path.isdir(os.path.join(directory_path, d)) and d.startswith('P')]
    sub_dirs.sort(key=lambda x: int(x[1:]))  # Sort sub-directories numerically based on the number after 'P'

    for sub_dir in sub_dirs:
        results_path = os.path.join(directory_path, sub_dir, 'results')
        
        if not os.path.exists(results_path):
            continue
        
        json_files = [f for f in os.listdir(results_path) if f.endswith('.json')]
        json_files.sort()  # Sort json files alphabetically

        for json_file in json_files:
            file_path = os.path.join(results_path, json_file)
            with open(file_path, 'r') as f:
                data_dict = json.load(f)

            therapist_report = data_dict.get('therapistReport', {})
            llm_report = data_dict.get('llmReport', {})

            successful_instructions_therapist = therapist_report.get('successfulInstructions', [])
            successful_instructions_llm = llm_report.get('successfulInstructions', [])

            for i, (therapist_success, llm_success) in enumerate(zip(successful_instructions_therapist, successful_instructions_llm)):
                instruction_step = i
                correct = 1 if therapist_success == llm_success else 0
                truth = 1 if therapist_success else 0

                data.append({
                    'therapistID': sub_dir,
                    'exerciseID': json_file.replace('.json', ''),
                    'instruction_step': instruction_step,
                    'correct': correct,
                    'truth': truth
                })

    df = pd.DataFrame(data)
    
    # This is the dictionary that maps the exerciseID that was assigned to the two exercises that each therapist designed.
    # This mapping information is included in the Supplement (Appendix C: Assigned Exercise Goals).
    # For example, participant1 (P1) was assigned exerciseID 5 and 10. P1 first designed exercise5 and then exercise10.
    # The content of these exercise can be found in the "/Exercises/template.txt" file.
    dictionary = {
        'P1': {'exercise1': 5, 'exercise2': 10},
        'P2': {'exercise1': 1, 'exercise2': 6},
        'P3': {'exercise1': 9, 'exercise2': 3},
        'P4': {'exercise1': 4, 'exercise2': 9},
        'P5': {'exercise1': 10, 'exercise2': 1},
        'P6': {'exercise1': 2, 'exercise2': 7},
        'P7': {'exercise1': 6, 'exercise2': 4},
        'P8': {'exercise1': 7, 'exercise2': 5},
        'P9': {'exercise1': 8, 'exercise2': 2},
        'P10': {'exercise1': 3, 'exercise2': 6},
        'P11': {'exercise1': 4, 'exercise2': 7},
        'P12': {'exercise1': 1, 'exercise2': 8},
        'P13': {'exercise1': 9, 'exercise2': 5},
        'P14': {'exercise1': 6, 'exercise2': 2},
        'P15': {'exercise1': 3, 'exercise2': 9},
        'P16': {'exercise1': 2, 'exercise2': 10},
        'P17': {'exercise1': 8, 'exercise2': 4},
        'P18': {'exercise1': 7, 'exercise2': 1},
        'P19': {'exercise1': 5, 'exercise2': 8},
        'P20': {'exercise1': 10, 'exercise2': 3},
    }
    assign_exercise_id(df, dictionary)
    return df

def assign_exercise_id(df, dictionary):
    """
    write a function which loops through each line in the dataframe and updates the assigned exerciseID in the study based on the dictionary.
    """
    for index, row in df.iterrows():
        therapist_id = row['therapistID']
        exercise_id = row['exerciseID']
        df.at[index, 'exerciseID'] = dictionary[therapist_id][exercise_id]
        # print(f"Refining data for {dictionary[therapist_id][exercise_id]}")

    # Save the refined dataframe to a new csv file
    df.to_csv("./study_data_summary.csv", index=False)
    

if __name__ == "__main__":
    summarize_study_data("./study_data")
