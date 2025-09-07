import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/scoop_rotation_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Rest your elbow on the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Hold the scoop with the handle in your hand.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Turn the scoop so that your palm faces down towards the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Rotate your hand so that the back of your hand touches the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Repeat the rotation with the scoop once more, going palm down then palm up.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Take a break until you can begin again.",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Repeat the exercise one more time. I will guide you through the steps.",
        "Time_Taken": 0,
        "Completeness": False
    }
}

behavior Instruction():
    take SpeakAction("Let's start a new exercise.")
    take SpeakAction("If you feel pain, fatigue, or dizziness, please tell the system so that we can terminate the exercise for your safety. Stop if there is any pain.")
    take DoneAction()

    while WaitForIntroduction(ego):
        wait

    log_idx = 0
    speak_idx = 1

    # ---------- Instruction 0 ----------
    take SpeakAction("Rest your elbow on the table.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not RequestActionResult(ego):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 1 ----------
    take SpeakAction("Hold the scoop with the handle in your hand.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not RequestActionResult(ego):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 2 ----------
    take SpeakAction("Turn the scoop so that your palm faces down towards the table.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Turn the scoop so that your palm faces down towards the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckWristPronation(ego, "Right") and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction+CheckWristPronation", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 3 ----------
    take SpeakAction("Rotate your hand so that the back of your hand touches the table.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Rotate your hand so that the back of your hand touches the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckWristSupination(ego, "Right") and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction+CheckWristSupination", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 4 ----------
    take SpeakAction("Repeat the rotation with the scoop once more, going palm down then palm up.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time = time.time()
    correctness = True

    for i in range(1):  # Repeat once more as instructed
        # Repeat palm down
        take SpeakAction("Turn the scoop so that your palm faces down towards the table.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Turn the scoop so that your palm faces down towards the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckWristPronation(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat palm up
        take SpeakAction("Rotate your hand so that the back of your hand touches the table.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Rotate your hand so that the back of your hand touches the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckWristSupination(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

    end_time = time.time()
    UpdateLogs(logs, log_idx, "Repeat Loop (1x)", end_time - start_time, correctness)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 5 ----------
    take SpeakAction("Take a break until you can begin again.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not RequestActionResult(ego):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 6 ----------
    take SpeakAction("Repeat the exercise one more time. I will guide you through the steps.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time = time.time()
    correctness = True

    for i in range(1):  # Repeat the entire exercise one more time
        # Repeat Instruction 0
        take SpeakAction("Rest your elbow on the table.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Rest your elbow on the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not RequestActionResult(ego):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 1
        take SpeakAction("Hold the scoop with the handle in your hand.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Hold the scoop with the handle in your hand. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not RequestActionResult(ego):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 2
        take SpeakAction("Turn the scoop so that your palm faces down towards the table.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Turn the scoop so that your palm faces down towards the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckWristPronation(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 3
        take SpeakAction("Rotate your hand so that the back of your hand touches the table.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Rotate your hand so that the back of your hand touches the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckWristSupination(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

    end_time = time.time()
    UpdateLogs(logs, log_idx, "Repeat Loop (1x Full Exercise)", end_time - start_time, correctness)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Inform the Patient that the Exercise is Completed ----------
    take SpeakAction("Great job! You finished this exercise.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1
    take DisposeQueriesAction()

ego = new Scenicavatar at (0, 0, 0), with behavior Instruction()