import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/table_rehabilitation_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Bring your right arm across the table, horizontally, towards your left shoulder.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Then extend your right arm back out as far as you can towards your right side.",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Place a pink post-it anywhere on the left side of the table.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Place a yellow sticky post-it pad above the pink one in a column.",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Place a blue sticky post-it pad above the yellow one in a column.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Place a green cube as far as you can on your right side, opposite to the pink post-it note.",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Place an orange cube right above the green cube.",
        "Time_Taken": 0,
        "Completeness": False
    },
    7: {
        "ActionAPI": "",
        "Instruction": "Place a blue cube above the orange cube.",
        "Time_Taken": 0,
        "Completeness": False
    },
    8: {
        "ActionAPI": "",
        "Instruction": "Move the green cube to the pink post-it note.",
        "Time_Taken": 0,
        "Completeness": False
    },
    9: {
        "ActionAPI": "",
        "Instruction": "Move the blue cube to the blue post-it note.",
        "Time_Taken": 0,
        "Completeness": False
    },
    10: {
        "ActionAPI": "",
        "Instruction": "Move the orange cube to the yellow post-it note.",
        "Time_Taken": 0,
        "Completeness": False
    }
}

behavior Instruction():
    take SpeakAction("Let's start a new exercise.")
    take SpeakAction("If you feel pain, fatigue, or dizziness, please tell the system so that we can terminate the exercise for your safety.")
    take DoneAction()

    while WaitForIntroduction(ego):
        wait

    log_idx = 0
    speak_idx = 1

    # ---------- Instruction 0 ----------
    take SpeakAction("Bring your right arm across the table, horizontally, towards your left shoulder.")
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
    take SpeakAction("Then extend your right arm back out as far as you can towards your right side.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    ext = CheckElbowExtension()
    take SendImageAndTextRequestAction(f"Current Instruction: Extend your right arm towards your right side. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (ext.checkCompleted(ego, arm='Right') and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckElbowExtension+SendImageAndTextRequestAction", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 2 ----------
    take SpeakAction("Place a pink post-it anywhere on the left side of the table.")
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
    take SpeakAction("Place a yellow sticky post-it pad above the pink one in a column.")
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

    # ---------- Instruction 4 ----------
    take SpeakAction("Place a blue sticky post-it pad above the yellow one in a column.")
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
    take SpeakAction("Place a green cube as far as you can on your right side, opposite to the pink post-it note.")
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
    take SpeakAction("Place an orange cube right above the green cube.")
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
    take SpeakAction("Place a blue cube above the orange cube.")
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

    # ---------- Instruction 8 ----------
    take SpeakAction("Move the green cube to the pink post-it note.")
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

    # ---------- Instruction 9 ----------
    take SpeakAction("Move the blue cube to the blue post-it note.")
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
    take SpeakAction("Move the orange cube to the yellow post-it note.")
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