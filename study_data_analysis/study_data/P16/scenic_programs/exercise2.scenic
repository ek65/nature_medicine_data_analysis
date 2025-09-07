import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/tongs_ball_transfer.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Place the tongs in your right hand with your left hand.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Position the thumb on one side of the tongs and the other four fingers on the other side.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Pick up one ball at a time with the tongs.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Transfer the ball to the towel.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Repeat the third and fourth steps for all three balls.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "After all balls are transferred to the towel, pick up one ball at a time from the towel",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Transfer the ball back to the bowl.",
        "Time_Taken": 0,
        "Completeness": False
    },
    7: {
        "ActionAPI": "",
        "Instruction": "Repeat the last two steps until all balls are back in the bowl.",
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
    take SpeakAction("Place the tongs in your right hand with your left hand.")
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
    take SpeakAction("Position the thumb on one side of the tongs and the other four fingers on the other side.")
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
    take SpeakAction("Pick up one ball at a time with the tongs.")
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

    # ---------- Instruction 3 ----------
    take SpeakAction("Transfer the ball to the towel.")
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

    # ---------- Instruction 4 (Repeat steps 2 and 3 for 3 balls) ----------
    take SpeakAction("Repeat the third and fourth steps for all three balls.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    rep_start_time = time.time()
    correctness = True

    for i in range(3):
        # Repeat Instruction 2 without logging
        take SpeakAction("Pick up one ball at a time with the tongs.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Pick up one ball at a time with the tongs. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not RequestActionResult(ego):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 3 without logging
        take SpeakAction("Transfer the ball to the towel.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Transfer the ball to the towel. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not RequestActionResult(ego):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

    rep_end_time = time.time()
    UpdateLogs(logs, log_idx, "Repeat Loop (3x)", rep_end_time - rep_start_time, correctness)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 5 ----------
    take SpeakAction("After all balls are transferred to the towel, pick up one ball at a time from the towel")
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
    take SpeakAction("Transfer the ball back to the bowl.")
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

    # ---------- Instruction 7 (Repeat steps 5 and 6 for 3 balls) ----------
    take SpeakAction("Repeat the last two steps until all balls are back in the bowl.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    rep_start_time = time.time()
    correctness = True

    for i in range(3):
        # Repeat Instruction 5 without logging
        take SpeakAction("After all balls are transferred to the towel, pick up one ball at a time from the towel")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Pick up one ball at a time from the towel. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not RequestActionResult(ego):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

        # Repeat Instruction 6 without logging
        take SpeakAction("Transfer the ball back to the bowl.")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        take SendImageAndTextRequestAction(f"Current Instruction: Transfer the ball back to the bowl. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
        take DoneAction()
        while not RequestActionResult(ego):
            if count > 175:
                break
            count += 1
            wait
        take DisposeQueriesAction()
        correctness = correctness and (count < 175)

    rep_end_time = time.time()
    UpdateLogs(logs, log_idx, "Repeat Loop (3x)", rep_end_time - rep_start_time, correctness)
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