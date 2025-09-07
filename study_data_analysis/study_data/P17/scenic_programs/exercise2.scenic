import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/finger_pinch_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Sit in a chair in front of a table, with your forearm resting on the table, palm facing the ceiling and elbow in line with your wrist and your shoulder.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Bring your right thumb to touch the tip of your index finger as much as you can",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Release the pinch between your right thumb and the index finger",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Bring your right thumb to touch your middle finger as much as you can",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Release the pinch between your right thumb and the middle finger",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Bring your right thumb to touch your ring finger as much as you can",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Release the pinch between your right thumb and the ring finger",
        "Time_Taken": 0,
        "Completeness": False
    },
    7: {
        "ActionAPI": "",
        "Instruction": "Bring your right thumb to touch your pinky as much as you can, trying to touch the tip of the thumb",
        "Time_Taken": 0,
        "Completeness": False
    },
    8: {
        "ActionAPI": "",
        "Instruction": "Release the pinch between your right thumb and the pinky",
        "Time_Taken": 0,
        "Completeness": False
    },
    9: {
        "ActionAPI": "",
        "Instruction": "Repeat this exercise once more for each digit",
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
    take SpeakAction("Sit in a chair in front of a table, with your forearm resting on the table, palm facing the ceiling and elbow in line with your wrist and your shoulder.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Sit in front of a table with your forearm resting on the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
    take DoneAction()
    while not (CheckSeated(ego) and CheckWristSupination(ego, "Right") and RequestActionResult(ego)):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "SendImageAndTextRequestAction+CheckSeated+CheckWristSupination", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1
    take DisposeQueriesAction()

    # ---------- Instruction 1 ----------
    take SpeakAction("Bring your right thumb to touch the tip of your index finger as much as you can")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
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

    # ---------- Instruction 2 ----------
    take SpeakAction("Release the pinch between your right thumb and the index finger")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while CheckFingerTouch(ego, "Right", "Thumb", "Index"):
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
    take SpeakAction("Bring your right thumb to touch your middle finger as much as you can")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
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

    # ---------- Instruction 4 ----------
    take SpeakAction("Release the pinch between your right thumb and the middle finger")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while CheckFingerTouch(ego, "Right", "Thumb", "Middle"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckFingerTouch", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 5 ----------
    take SpeakAction("Bring your right thumb to touch your ring finger as much as you can")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
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

    # ---------- Instruction 6 ----------
    take SpeakAction("Release the pinch between your right thumb and the ring finger")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while CheckFingerTouch(ego, "Right", "Thumb", "Ring"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckFingerTouch", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 7 ----------
    take SpeakAction("Bring your right thumb to touch your pinky as much as you can, trying to touch the tip of the thumb")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
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

    # ---------- Instruction 8 ----------
    take SpeakAction("Release the pinch between your right thumb and the pinky")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while CheckFingerTouch(ego, "Right", "Thumb", "Pinky"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckFingerTouch", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 9 (Repeat) ----------
    take SpeakAction("Repeat this exercise once more for each digit")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    rep_start_time = time.time()
    correctness = True

    for i in range(1):
        # Repeat Instruction 1
        take SpeakAction("Bring your right thumb to touch the tip of your index finger as much as you can")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while not CheckFingerTouch(ego, "Right", "Thumb", "Index"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Repeat Instruction 2
        take SpeakAction("Release the pinch between your right thumb and the index finger")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while CheckFingerTouch(ego, "Right", "Thumb", "Index"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Repeat Instruction 3
        take SpeakAction("Bring your right thumb to touch your middle finger as much as you can")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while not CheckFingerTouch(ego, "Right", "Thumb", "Middle"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Repeat Instruction 4
        take SpeakAction("Release the pinch between your right thumb and the middle finger")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while CheckFingerTouch(ego, "Right", "Thumb", "Middle"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Repeat Instruction 5
        take SpeakAction("Bring your right thumb to touch your ring finger as much as you can")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while not CheckFingerTouch(ego, "Right", "Thumb", "Ring"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Repeat Instruction 6
        take SpeakAction("Release the pinch between your right thumb and the ring finger")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while CheckFingerTouch(ego, "Right", "Thumb", "Ring"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Repeat Instruction 7
        take SpeakAction("Bring your right thumb to touch your pinky as much as you can, trying to touch the tip of the thumb")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while not CheckFingerTouch(ego, "Right", "Thumb", "Pinky"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Repeat Instruction 8
        take SpeakAction("Release the pinch between your right thumb and the pinky")
        take DoneAction()

        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 

        count = 0
        while CheckFingerTouch(ego, "Right", "Thumb", "Pinky"):
            if count > 175:
                break
            count += 1
            wait
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