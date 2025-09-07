import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/finger_spreading_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Rest your right hand on the table with your palm facing down.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Spread apart your index and middle fingers as much as you can.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Bring your index and middle fingers back together.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Spread apart your middle and ring fingers.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Bring your middle and ring fingers back together.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Spread apart your ring and little fingers.",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Bring your ring and little fingers back together.",
        "Time_Taken": 0,
        "Completeness": False
    },
    7: {
        "ActionAPI": "",
        "Instruction": "Spread apart your thumb and index fingers.",
        "Time_Taken": 0,
        "Completeness": False
    },
    8: {
        "ActionAPI": "",
        "Instruction": "Bring your thumb and index fingers back together.",
        "Time_Taken": 0,
        "Completeness": False
    },
    9: {
        "ActionAPI": "",
        "Instruction": "Rest your right hand.",
        "Time_Taken": 0,
        "Completeness": False
    }
}

behavior Instruction():
    take SpeakAction("Let's start a new exercise.")
    take SpeakAction("Remove any objects you may knock off from the table.")
    take DoneAction()

    while WaitForIntroduction(ego):
        wait

    log_idx = 0
    speak_idx = 1

    # ---------- Instruction 0 ----------
    take SpeakAction("Rest your right hand on the table with your palm facing down.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Rest your right hand on the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 1 ----------
    take SpeakAction("Spread apart your index and middle fingers as much as you can.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Spread", "Index", "Middle", 10)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 2 ----------
    take SpeakAction("Bring your index and middle fingers back together.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Adducted", "Index", "Middle", 10)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 3 ----------
    take SpeakAction("Spread apart your middle and ring fingers.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Spread", "Middle", "Ring", 10)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 4 ----------
    take SpeakAction("Bring your middle and ring fingers back together.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Adducted", "Middle", "Ring", 10)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 5 ----------
    take SpeakAction("Spread apart your ring and little fingers.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Spread", "Ring", "Pinky", 10)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 6 ----------
    take SpeakAction("Bring your ring and little fingers back together.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Adducted", "Ring", "Pinky", 10)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 7 ----------
    take SpeakAction("Spread apart your thumb and index fingers.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Spread", "Thumb", "Index", 20)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 8 ----------
    take SpeakAction("Bring your thumb and index fingers back together.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    cd = CheckDuration("CheckBetweenFingerAngle", 2, ego, "Right", "Adducted", "Thumb", "Index", 20)
    while not cd.checkCompleted():
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckBetweenFingerAngle", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DoneAction()

    # ---------- Instruction 9 ----------
    take SpeakAction("Rest your right hand.")
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

    # ---------- Inform the Patient that the Exercise is Completed ----------
    take SpeakAction("Great job! You finished this exercise.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1
    take DisposeQueriesAction()

ego = new Scenicavatar at (0, 0, 0), with behavior Instruction()