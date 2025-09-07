import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *
model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/finger_spread_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Sit upright, ensuring that you're not leaning onto the mat or the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Place your right hand flat on the table with your palm facing down.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Bring all your fingers together so that there's no space in between your fingers.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Spread your fingers out all the way.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Repeat the action of bringing your fingers together and then spreading them out all the way.",
        "Time_Taken": 0,
        "Completeness": False
    }
}

behavior Instruction():
    take SpeakAction("Let's start a new exercise.")
    take SpeakAction("Clear your surroundings to make sure you do not knock over any items.")
    take DoneAction()

    while WaitForIntroduction(ego):
        wait

    log_idx = 0
    speak_idx = 1

    # ---------- Instruction 0 ----------
    take SpeakAction("Sit upright, ensuring that you're not leaning onto the mat or the table.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Sit in front of a table or mat. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (SitUpStraight(ego) and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction+SitUpStraight", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 1 ----------
    take SpeakAction("Place your right hand flat on the table with your palm facing down.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 2 ----------
    take SpeakAction("Bring all your fingers together so that there's no space in between your fingers.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckFingerAdduction(ego, "Right") and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction+CheckFingerAdduction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 3 ----------
    take SpeakAction("Spread your fingers out all the way.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckFingerSpread(ego, "Right") and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction+CheckFingerSpread", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 4 ----------
    take SpeakAction("Repeat the action of bringing your fingers together and then spreading them out all the way.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    rep_start_time = time.time()
    correctness = True

    # Repeat loop for steps 2 and 3 (bringing fingers together and spreading them out)
    for i in range(5):  # Assuming 5 repetitions as a default since not specified
        # Repeat Instruction 2 without logging
        take SpeakAction("Bring all your fingers together so that there's no space in between your fingers.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Bring all your fingers together so that there's no space in between your fingers. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckFingerAdduction(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 3 without logging
        take SpeakAction("Spread your fingers out all the way.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Spread your fingers out all the way. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckFingerSpread(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

    rep_end_time = time.time()
    UpdateLogs(logs, log_idx, "Repeat Loop (5x)", rep_end_time - rep_start_time, correctness)
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