import time
import json

from scenic.simulators.unity.actions import *
from scenic.simulators.unity.behaviors import *

model scenic.simulators.unity.model

log_file_path = "program_synthesis/logs/scoop_and_container_exercise.json"

# Create log json file 
with open(log_file_path, 'w') as f:
    json.dump({}, f, indent=4)

# Instruction logs
logs = {
    0: {"ActionAPI": "", "Instruction": "Extend your right elbow out and grasp the of the scoop handle.", "Time_Taken": 0, "Completeness": False},
    1: {"ActionAPI": "", "Instruction": "Flex your right elbow towards your body.", "Time_Taken": 0, "Completeness": False},
    2: {"ActionAPI": "", "Instruction": "Extend your right elbow to place scoop over the container.", "Time_Taken": 0, "Completeness": False},
    3: {"ActionAPI": "", "Instruction": "You may have to rotate your body towards the container.", "Time_Taken": 0, "Completeness": False},
    4: {"ActionAPI": "", "Instruction": "Or you may have to do shoulder adduction to get closer to the container.", "Time_Taken": 0, "Completeness": False},
    5: {"ActionAPI": "", "Instruction": "Release your grip.", "Time_Taken": 0, "Completeness": False},
    6: {"ActionAPI": "", "Instruction": "Extend your right elbow to grab the fork handle.", "Time_Taken": 0, "Completeness": False},
    7: {"ActionAPI": "", "Instruction": "To place the fork into the container, you can rotate your trunk towards the container.", "Time_Taken": 0, "Completeness": False},
    8: {"ActionAPI": "", "Instruction": "Or adduct your shoulder in order for the fork to go over the container.", "Time_Taken": 0, "Completeness": False},
    9: {"ActionAPI": "", "Instruction": "Release the fork with your fingers.", "Time_Taken": 0, "Completeness": False},
    10: {"ActionAPI": "", "Instruction": "With your right hand, extend your elbow, to grasp the handle tongs.", "Time_Taken": 0, "Completeness": False},
    11: {"ActionAPI": "", "Instruction": "If the tongs are to heavy to bring over, use your left arm to move the container towards the middle, closer your body.", "Time_Taken": 0, "Completeness": False},
    12: {"ActionAPI": "", "Instruction": "You can also, use your left arm to help support your right wrist if the tongs are too heavy.", "Time_Taken": 0, "Completeness": False},
    13: {"ActionAPI": "", "Instruction": "Release your grasp on the tong handle.", "Time_Taken": 0, "Completeness": False},
    14: {"ActionAPI": "", "Instruction": "Use your left arm to gently put your right arm down.", "Time_Taken": 0, "Completeness": False}
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
    take SpeakAction("Extend your right elbow out and grasp the scoop handle.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    ext = CheckElbowExtension()
    take SendImageAndTextRequestAction(f"Current Instruction: Grasp the scoop handle with your right hand. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 1 ----------
    take SpeakAction("Flex your right elbow towards your body.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    flx = CheckElbowBend()
    while not flx.checkCompleted(ego, arm='Right'):
        if count > 175:
            break
        count += 1
        wait
    end_time = time.time()
    UpdateLogs(logs, log_idx, "CheckElbowBend", end_time - start_time, count < 175)
    with open(log_file_path, "w") as file:
        json.dump(logs, file, indent=4)
    log_idx += 1

    # ---------- Instruction 2 ----------
    take SpeakAction("Extend your right elbow to place scoop over the container.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    ext = CheckElbowExtension()
    take SendImageAndTextRequestAction(f"Current Instruction: Place scoop over the container with your right hand. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 3 ----------
    take SpeakAction("You may have to rotate your body towards the container.")
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
    take SpeakAction("Or you may have to do shoulder adduction to get closer to the container.")
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
    take SpeakAction("Release your grip.")
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
    take SpeakAction("Extend your right elbow to grab the fork handle.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    ext = CheckElbowExtension()
    take SendImageAndTextRequestAction(f"Current Instruction: Grab the fork handle with your right hand. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 7 ----------
    take SpeakAction("To place the fork into the container, you can rotate your trunk towards the container.")
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
    take SpeakAction("Or adduct your shoulder in order for the fork to go over the container.")
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
    take SpeakAction("Release the fork with your fingers.")
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
    take SpeakAction("With your right hand, extend your elbow, to grasp the handle tongs.")
    take DoneAction()

    while WaitForSpeakAction(ego, speak_idx):
        wait
    speak_idx += 1

    start_time, count = time.time(), 0
    ext = CheckElbowExtension()
    take SendImageAndTextRequestAction(f"Current Instruction: Grasp the handle tongs with your right hand. Prior Instructions: {[logs[i]['Instruction'] for i in range(log_idx)]}")
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

    # ---------- Instruction 11 ----------
    take SpeakAction("If the tongs are to heavy to bring over, use your left arm to move the container towards the middle, closer your body.")
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

    # ---------- Instruction 12 ----------
    take SpeakAction("You can also, use your left arm to help support your right wrist if the tongs are too heavy.")
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

    # ---------- Instruction 13 ----------
    take SpeakAction("Release your grasp on the tong handle.")
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

    # ---------- Instruction 14 ----------
    take SpeakAction("Use your left arm to gently put your right arm down.")
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