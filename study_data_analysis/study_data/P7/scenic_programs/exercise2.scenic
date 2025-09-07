import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/thumb_to_finger_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {
        "ActionAPI": "",
        "Instruction": "Lay your forearm flat on the table with your palm facing up to the ceiling.",
        "Time_Taken": 0,
        "Completeness": False
    },
    1: {
        "ActionAPI": "",
        "Instruction": "Try to touch your thumb to your first finger (index finger).",
        "Time_Taken": 0,
        "Completeness": False
    },
    2: {
        "ActionAPI": "",
        "Instruction": "Open your hand back up after touching your thumb to your first finger.",
        "Time_Taken": 0,
        "Completeness": False
    },
    3: {
        "ActionAPI": "",
        "Instruction": "Now, touch your thumb to your second finger (middle finger).",
        "Time_Taken": 0,
        "Completeness": False
    },
    4: {
        "ActionAPI": "",
        "Instruction": "Again, open your hand back up.",
        "Time_Taken": 0,
        "Completeness": False
    },
    5: {
        "ActionAPI": "",
        "Instruction": "Next, touch your thumb to your third finger (ring finger).",
        "Time_Taken": 0,
        "Completeness": False
    },
    6: {
        "ActionAPI": "",
        "Instruction": "Open your hand back up.",
        "Time_Taken": 0,
        "Completeness": False
    },
    7: {
        "ActionAPI": "",
        "Instruction": "Lastly, touch your thumb to your fifth finger (pinky finger).",
        "Time_Taken": 0,
        "Completeness": False
    },
    8: {
        "ActionAPI": "",
        "Instruction": "Then open your hand back up.",
        "Time_Taken": 0,
        "Completeness": False
    },
    9: {
        "ActionAPI": "",
        "Instruction": "Repeat these steps two more times: thumb to index finger, open, thumb to middle finger, open, thumb to ring finger, open, and thumb to pinky finger, open. Let me guide you through the steps.",
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
    take SpeakAction("Lay your forearm flat on the table with your palm facing up to the ceiling.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    take SendImageAndTextRequestAction(f"Current Instruction: Lay your forearm flat on the table. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 1 ----------
    take SpeakAction("Try to touch your thumb to your first finger (index finger).")
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
    take SpeakAction("Open your hand back up after touching your thumb to your first finger.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while not CheckOpenPalm(ego, "Right"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckOpenPalm", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 3 ----------
    take SpeakAction("Now, touch your thumb to your second finger (middle finger).")
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
    take SpeakAction("Again, open your hand back up.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while not CheckOpenPalm(ego, "Right"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckOpenPalm", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 5 ----------
    take SpeakAction("Next, touch your thumb to your third finger (ring finger).")
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
    take SpeakAction("Open your hand back up.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while not CheckOpenPalm(ego, "Right"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckOpenPalm", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 7 ----------
    take SpeakAction("Lastly, touch your thumb to your fifth finger (pinky finger).")
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
    take SpeakAction("Then open your hand back up.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    start_time, count = time.time(), 0
    while not CheckOpenPalm(ego, "Right"):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckOpenPalm", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 9 (Repeat Loop) ----------
    take SpeakAction("Repeat these steps two more times: thumb to index finger, open, thumb to middle finger, open, thumb to ring finger, open, and thumb to pinky finger, open. Let me guide you through the steps.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx): 
        wait
    speak_idx += 1 

    rep_start_time = time.time()
    correctness = True

    for i in range(2):  # Repeat two more times as instructed
        # Thumb to Index
        take SpeakAction("Try to touch your thumb to your first finger (index finger).")
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

        # Open hand
        take SpeakAction("Open your hand back up after touching your thumb to your first finger.")
        take DoneAction()
        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 
        count = 0
        while not CheckOpenPalm(ego, "Right"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Thumb to Middle
        take SpeakAction("Now, touch your thumb to your second finger (middle finger).")
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

        # Open hand
        take SpeakAction("Again, open your hand back up.")
        take DoneAction()
        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 
        count = 0
        while not CheckOpenPalm(ego, "Right"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Thumb to Ring
        take SpeakAction("Next, touch your thumb to your third finger (ring finger).")
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

        # Open hand
        take SpeakAction("Open your hand back up.")
        take DoneAction()
        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 
        count = 0
        while not CheckOpenPalm(ego, "Right"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

        # Thumb to Pinky
        take SpeakAction("Lastly, touch your thumb to your fifth finger (pinky finger).")
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

        # Open hand
        take SpeakAction("Then open your hand back up.")
        take DoneAction()
        while WaitForSpeakAction(ego, speak_idx): 
            wait
        speak_idx += 1 
        count = 0
        while not CheckOpenPalm(ego, "Right"):
            if count > 175:
                break
            count += 1
            wait
        correctness = correctness and (count < 175)

    rep_end_time = time.time()
    UpdateLogs(logs, log_idx, "Repeat Loop (2x)", rep_end_time - rep_start_time, correctness)
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