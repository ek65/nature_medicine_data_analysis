import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/forearm_rotation.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Prepare a scoop in front of you.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Sit comfortably with your right hand on the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Turn your palm facing down.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Slowly rotate your forearm to turn your palm facing up.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Rotate your forearm again to turn your palm facing down.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Lift your hand from the table, while stabilizing your elbow on the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Grab a scoop with your right hand.",
        "Time_Taken": 0,
        "Completeness": False
    },
    7: {
        "ActionAPI": "",
        "Instruction": "Rotate your forearm to turn your palm up, while holding the scoop.",
        "Time_Taken": 0,
        "Completeness": False
    },
    8: {
        "ActionAPI": "",
        "Instruction": "Rotate your forearm to turn your palm down, while holding the scoop.",
        "Time_Taken": 0,
        "Completeness": False
    },
    9: {
        "ActionAPI": "",
        "Instruction": "Place the scoop on the table",
        "Time_Taken": 0,
        "Completeness": False
    },
    10: {
        "ActionAPI": "",
        "Instruction": "Rest your right hand.",
        "Time_Taken": 0,
        "Completeness": False
    }
}

behavior Instruction():
    take SpeakAction("Let's start a new exercise.")
    take SpeakAction("Remove any objects you may knock off from the table")
    take DoneAction()

    while WaitForIntroduction(ego):
        wait

    log_idx = 0
    speak_idx = 1

    # ---------- Instruction 0 ----------
    take SpeakAction("Prepare a scoop in front of you.")
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
    take SpeakAction("Sit comfortably with your right hand on the table.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Place your right hand on the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckSeated(ego) and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction+CheckSeated", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 2 ----------
    take SpeakAction("Turn your palm facing down.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while not CheckWristPronation(ego, "Right"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckWristPronation", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 3 ----------
    take SpeakAction("Slowly rotate your forearm to turn your palm facing up.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while not CheckWristSupination(ego, "Right"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckWristSupination", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 4 ----------
    take SpeakAction("Rotate your forearm again to turn your palm facing down.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while not CheckWristPronation(ego, "Right"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckWristPronation", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 5 ----------
    take SpeakAction("Lift your hand from the table, while stabilizing your elbow on the table.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Lift your hand from the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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
    take SpeakAction("Grab a scoop with your right hand.")
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

    # ---------- Instruction 7 ----------
    take SpeakAction("Rotate your forearm to turn your palm up, while holding the scoop.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Holding the scoop with palm up. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckWristSupination(ego, "Right") and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckWristSupination+SendImageAndTextRequestAction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 8 ----------
    take SpeakAction("Rotate your forearm to turn your palm down, while holding the scoop.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Holding the scoop with palm down. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckWristPronation(ego, "Right") and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckWristPronation+SendImageAndTextRequestAction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 9 ----------
    take SpeakAction("Place the scoop on the table")
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

    # ---------- Instruction 10 ----------
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