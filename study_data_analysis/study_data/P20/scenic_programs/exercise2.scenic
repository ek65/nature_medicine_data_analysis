import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/scoop_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Put the scoop in your right hand.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Rest your right forearm on the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Keep your right forearm in contact with the table and turn your right arm so your palm is facing up and the scoop is towards the right.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Turn your right arm so your palm is facing down towards the table and the scoop is towards the left.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Hold each position for 3 seconds.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Repeat these steps one more time.",
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
    take SpeakAction("Put the scoop in your right hand.")
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
    take SpeakAction("Rest your right forearm on the table.")
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
    take SpeakAction("Keep your right forearm in contact with the table and turn your right arm so your palm is facing up and the scoop is towards the right.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Keep your right forearm in contact with the table and the scoop is towards the right. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 3 ----------
    take SpeakAction("Turn your right arm so your palm is facing down towards the table and the scoop is towards the left.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Keep your right forearm in contact with the table and the scoop is towards the left. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 4 ----------
    take SpeakAction("Hold each position for 3 seconds.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    cd_sup = CheckDuration("CheckWristSupination", 3, ego, "Right")
    cd_pro = CheckDuration("CheckWristPronation", 3, ego, "Right")
    while not (cd_sup.checkCompleted() and cd_pro.checkCompleted() and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckDuration+SendImageAndTextRequestAction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 5 ----------
    take SpeakAction("Repeat these steps one more time.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    rep_start_time = time.time()
    correctness = True

    for i in range(1):
        # Repeat Instruction 2 without logging
        take SpeakAction("Keep your right forearm in contact with the table and turn your right arm so your palm is facing up and the scoop is towards the right.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Keep your right forearm in contact with the table and the scoop is towards the right. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckWristSupination(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 3 without logging
        take SpeakAction("Turn your right arm so your palm is facing down towards the table and the scoop is towards the left.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Keep your right forearm in contact with the table and the scoop is towards the left. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not (CheckWristPronation(ego, "Right") and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 4 without logging
        take SpeakAction("Hold each position for 3 seconds.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: {logs[log_idx]['Instruction']}. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        cd_sup = CheckDuration("CheckWristSupination", 3, ego, "Right")
        cd_pro = CheckDuration("CheckWristPronation", 3, ego, "Right")
        while not (cd_sup.checkCompleted() and cd_pro.checkCompleted() and RequestActionResult(ego)):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

    rep_end_time = time.time()
    UpdateLogs(logs, log_idx, "Repeat Loop (1x)", rep_end_time - rep_start_time, correctness)
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