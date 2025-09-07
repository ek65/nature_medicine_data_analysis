import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/finger_opposition_and_grasp.json"

# Create log json file
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Perform opposition (touch the pads of your thumb and index finger) between your thumb and index finger.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Try the same opposition with your thumb and middle finger.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Next, try the opposition with your thumb and ring finger.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Attempt the opposition with your thumb and pinkie finger.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Use your thumb and index finger to pick up the handle of the spoon and drop it into your pink box.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Repeat the same process with a fork, using your thumb and index finger. If the fork is a bit heavy, use your middle finger together with your thumb and index finger to form a tripod grasp.",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Drop the fork into the container.",
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
    take SpeakAction("Perform opposition (touch the pads of your thumb and index finger) between your thumb and index finger.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    take DoneAction()
    while not CheckFingerTouch(ego, "Right", "Thumb", "Index"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckFingerTouch", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 1 ----------
    take SpeakAction("Try the same opposition with your thumb and middle finger.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    take DoneAction()
    while not CheckFingerTouch(ego, "Right", "Thumb", "Middle"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckFingerTouch", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 2 ----------
    take SpeakAction("Next, try the opposition with your thumb and ring finger.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    take DoneAction()
    while not CheckFingerTouch(ego, "Right", "Thumb", "Ring"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckFingerTouch", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 3 ----------
    take SpeakAction("Attempt the opposition with your thumb and pinkie finger.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    take DoneAction()
    while not CheckFingerTouch(ego, "Right", "Thumb", "Pinky"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckFingerTouch", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 4 ----------
    take SpeakAction("Use your thumb and index finger to pick up the handle of the spoon and drop it into your pink box.")
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

    # ---------- Instruction 5 ----------
    take SpeakAction("Repeat the same process with a fork, using your thumb and index finger. If the fork is a bit heavy, use your middle finger together with your thumb and index finger to form a tripod grasp.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Pick up the fork using your thumb and index finger or with a tripod grasp. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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
    take SpeakAction("Drop the fork into the container.")
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