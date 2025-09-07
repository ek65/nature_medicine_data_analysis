import time
from scenic.core.simulators import Action
from scenic.core.vectors import Vector
from scenic.core.object_types import OrientedPoint, Point
from scenic.simulators.unity.client import *
import json
import os
import uuid
import numpy as np
import math
from typing import Any
success_count = 0
elbow_extended = False
elbow_flexed = False

################# APIs for Instructing Patients #################
class SpeakAction(Action):
    """
    Represents an action where an object speaks a given sentence.
    This action is used to instruct an exercise step. 

    Attributes:
        actionName (str): The name of the action, set to "Speak".
        sentence (str): The sentence that the object will speak.

    Methods:
        applyTo(obj, sim): Applies the speak action to the specified object within the simulation.
    """

    def __init__(self, sentence):
        self.actionName = "Speak"
        self.sentence = sentence

    def applyTo(self, obj, sim):
        obj.gameObject.SpeakAction(self.sentence)


def WaitForIntroduction(ego):
    """
    Waits until the introductory speaking actions are completed.
    This is necessary to prevent the patient from speaking over itself

    Input Arguments:
        ego (Unity object): The Unity object representing the patient.

    Output Arguments:
        bool: True if fewer than 4 speaking actions have been completed, False otherwise.
    """
    if not ego.gameObject.avatar_status:
        return False
    return ego.gameObject.avatar_status.speakActionCount < 2


def WaitForSpeakAction(ego, speak_count):
    """
    This action waits until the speak_count number of speaking actions are completed.
    The speak_count is the cumulated number of speaking actions that need to be completed for this action to terminate.

    Input Arguments:
        ego (Unity object): The Unity object representing the patient.
        speak_count (int): The cumulated number of speaking actions needs to be completed. 

    Output Arguments:
        bool: True if fewer than speak_count have been completed, False otherwise.
    """
    if not ego.gameObject.avatar_status:
        return False
    return ego.gameObject.avatar_status.speakActionCount < 2 + speak_count

class DoneAction(Action):
    """
    This action needs to be invoked before any while-loop in the Scenic program.
    This action ensures that any previous action is terminated before starting a new one.
    Otherwise, any unfinished action from before may interfere with the new action invoked in 
    subsequent while-loop.

    Attributes:
        actionName (str): The name of the action, set to "Done".

    Methods:
        applyTo(obj, sim): Applies the done action to the specified object within the simulation.
    """

    def __init__(self):
        self.actionName = "Done"

    def applyTo(self, obj, sim):
        obj.gameObject.DoneAction()


################# APIs for Logging #################

def UpdateLogs(logs, log_idx, action_api, time_taken, completeness):
    """
    Updates the logs dictionary with the current action details.

    Parameters:
        logs (dict): The dictionary to store action execution details.
        log_idx (int): The index of the log entry to update.
        action_api (str): The name or identifier of the action API invoked.
        time_taken (float): The time taken to complete the action (in seconds).
        completeness (boolean): True / False indicating whether the action was completed successfully.

    Returns:
        None
    """
    if log_idx not in logs:
        print("Unable to find log index")
        return
    logs = logs[log_idx]

    if "ActionAPI" not in logs:
        print("ActionAPI not in the log")
        return
    if "Time_Taken" not in logs:
        print("Time_Taken not in the log")
        return
    if "Completeness" not in logs:
        print("Completeness not in the log")
        return

    logs["ActionAPI"] = action_api
    logs["Time_Taken"] = time_taken
    logs["Completeness"] = completeness



################# APIs for Monitoring Patient's Interaction with any objects in the environment with Camera Data #################

class SendImageAndTextRequestAction(Action):
    """
    This action captures an image of the patient conducting an exercise from an AR headset. 
    and sends the image to a vision language model to confirm if a patient has completed the current instruction.
    
    This action is useful for checking conditions that can be evaluated with a static image, e.g. "place your hand on the table."
    In this example, the image can be used to check if the patient's hand is indeed on the table.

    However, this action must not be used for checking conditions that are dynamic.
    For example, suppose an instruction is "move your hand in a circular motion."
    This instruction cannot be checked using an image alone. 
    Thus for checking dynamic conditions, you should use RecordVideoAndEvaluateAction() action instead.
    
    Whenever you invoke this action, you must also invoke RequestActionResult(ego) action, subsequently. 
    This action is useful for checking the patient's interaction with any objects in the environment, e.g. table, cup, etc.
    *** If this action is invoked with another body pose estimation API, such as CheckSeated(), then make sure the 
    instruction input argument for this function "excludes" the condition that is being checked by the body pose estimation API.

    Attributes:
        actionName (str): The name of the action, set to "SendImageAndTextRequest".
        instruction (str): The instruction text to be monitored for completion. 

    Methods:
        applyTo(obj, sim): Applies the SendImageAndTextRequest action to the specified object within the simulation.
    """

    def __init__(self, instruction):
        self.actionName = "SendImageAndTextRequest"
        self.instruction = instruction

    def applyTo(self, obj, sim):
        global success_count
        success_count = 0
        obj.gameObject.SendImageAndTextRequestAction(self.instruction)

class RecordVideoAndEvaluateAction(Action):
    """
    This action captures an image of the patient conducting an exercise from an AR headset. 
    and sends the image to a vision language model to confirm if a patient has completed the current instruction.
    
    This action is useful for checking conditions that are static, e.g. "place your hand on the table."
    However, this action is not useful for checking conditions that are dynamic.
    For example, suppose an instruction is "move your hand in a circular motion."
    This instruction cannot be checked using an image alone.
    However, this action must not be used for checking conditions that can be checked with a static image,
    e.g. "place your hand on the table."
    
    Whenever you invoke this action, you must also invoke RequestActionResult(ego) action, subsequently. 
    This action is useful for checking the patient's interaction with any objects in the environment, e.g. table, cup, etc.
    *** If this action is invoked with another body pose estimation API, such as CheckSeated(), then make sure the 
    instruction input argument for this function "excludes" the condition that is being checked by the body pose estimation API.

    Attributes:
        actionName (str): The name of the action, set to "RecordVideoAndEvaluate".
        instruction (str): The instruction text to be monitored for completion. 

    Methods:
        applyTo(obj, sim): Applies the action to the specified object in the simulation,
                           invoking the video recording and evaluation routine on the Unity side.
    """

    def __init__(self, instruction):
        self.RecordVideoAndEvaluate = "RecordVideoAndEvaluate"
        self.instruction = instruction

    def applyTo(self, obj, sim):
        global success_count
        success_count = 0
        obj.gameObject.RecordVideoAndEvaluateAction(self.instruction)

def RequestActionResult(ego):
    """
    Once SendImageAndTextRequestAction() or RecordVideoAndEvaluateAction() is invoked, 
    this function is invoked to check if the current instruction is completed.

    Input Arguments:
        1. ego (Unity object): The Unity object representing the patient.

    Output Arguments:
        bool: True if the current instruction is completed by the patient, False otherwise.
    """
    # print(f"status: {ego.gameObject.avatar_status}")
    if not ego.gameObject.avatar_status:
        print("None")
        return False
    if ego.gameObject.avatar_status.feedback:
        print(ego.gameObject.avatar_status.feedback)
    else:
        print("No feedback received yet.")

    global success_count
    # if ego.gameObject.avatar_status.taskDone:
    if "yes" in ego.gameObject.avatar_status.feedback.lower() or "true" in ego.gameObject.avatar_status.feedback.lower():
        success_count += 1
    else:
        success_count = 0

    print(f"success_count: {success_count}")
    return success_count >= 20

class DisposeQueriesAction(Action):
    '''
    Dispose all the queries to a vison language model running in the background.
    This action needs to be invoked after the action SendImageAndTextRequestAction() or RecordVideoAndEvaluateAction() is invoked
    to terminate the queries to the vision language model.
    
    Attributes:
        actionName (str): The name of the action, set to "DisposeQueries".

    Methods:
        applyTo(obj, sim): Applies the dispsoe queries to the specified object within the simulation.
    '''
    
    def __init__(self):
        self.actionName = "DisposeQueries"
        
    def applyTo(self, obj, sim):
        obj.gameObject.DisposeQueriesAction()

################# APIs for Monitoring Patient's Movement using the AR headset's Body Pose Estimation data #################

def CheckSeated(ego):
    """
    Checks whether the patient is seated.

    Input Arguments:
        1. ego: contains the hip flexion value of the patient.

    Output Arguments:
        bool: True if the patient is seated; otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False
    return True if ego.gameObject.joint_angles.hipFlexion >= 10 else False

def CheckStanding(ego):
    """
    Checks whether the patient is standing.

    Input Arguments:
        1. ego: contains the hip flexion value of the patient.

    Output Arguments:
        bool: True if the patient is standing, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False
    return True if ego.gameObject.joint_angles.hipFlexion < 10 else False

def LeanForward(ego, threshold=20):
    """
    Checks whether the patient is leaning forward or tilting forward.

    Input Arguments:
        1. ego: contains the trunk tilt value of the patient.
        2. threshold (int, optional): The angle threshold to check against. Default is set to 30 degrees.

    Output Arguments:
        bool: True if the patient is leaning forward beyond the threshold degrees, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False
    print(ego.gameObject.joint_angles.trunkTilt)
    return True if ego.gameObject.joint_angles.trunkTilt >= threshold else False

def SitUpStraight(ego):
    """
    Checks whether the patient is trunk neutral (i.e. not leaning or tilting).

    Input Arguments:
        1. ego: contains the trunk tilt value of the patient.

    Output Arguments:
        bool: True if the patient is sitting up straight, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False
    return True if ego.gameObject.joint_angles.trunkTilt < 10 else False

    
class CheckElbowBend:
    """
    Checks whether the elbow of the specified arm(s) is flexed by a certain threshold angle  
    Input Arguments:
        1. threshold (int, optional): The angle threshold in degrees to check against. Default is set to 10 degrees.
    """
    def __init__(self, threshold=10):
        self.smooth_window = 5
        self.threshold = threshold
        self.angles = []
        global elbow_flexed
        elbow_flexed = False

    def smooth_angles(self, traj: list[tuple]) -> list[tuple]:
        """
        Write a function to smooth the angles using a moving average filter.
        The function should take a list of angles and return a list of smoothed angles.
        When smoothing, it should consider the window size of self.smooth_window.
        """
        smoothed_angles = []
        for i in range(len(traj)):
            start = max(0, i - self.smooth_window // 2)
            end = min(len(traj), i + self.smooth_window // 2 + 1)
            left_avg = np.mean([angle[0] for angle in traj[start:end]])
            right_avg = np.mean([angle[1] for angle in traj[start:end]])
            smoothed_angles.append((left_avg, right_avg))
        return smoothed_angles
    
    def alreadyFlexed(self, arm, angles_list, threshold = 95):
        """
        Checks if the elbow angle(s) of the specified arm(s) has already been flexed by a certain threshold.
        This function is used to check if the elbow has already been flexed before the current action is invoked.
        
        Input Arguments:
            1. arm (str): Which arm(s) to check. Must be one of:
                       - "Left": Check only the left elbow.
                       - "Right": Check only the right elbow.
                       - "Both": Check both elbows.
            2. angles_list (list): List of angles to check against.
            3. threshold (int): The angle threshold to check against.

        Output Arguments:
            bool: True if the specified arm(s) have already flexed their elbow angle by at least the threshold, else False.
        """
        if "both" in arm.lower():
            # Check if both arms have flexed their elbow angles
            left_flexed_angles = [angle[0] for angle in angles_list if angle[0] < threshold]
            right_flexed_angles = [angle[1] for angle in angles_list if angle[1] < threshold]
            return len(left_flexed_angles) > 10 and len(right_flexed_angles) > 10
        elif "left" in arm.lower():
            # Check if the left arm has flexed its elbow angle
            flexed_angles = [angle[0] for angle in angles_list if angle[0] < threshold]
            return len(flexed_angles) > 10
        elif "right" in arm.lower():
            # Check if the right arm has flexed its elbow angle
            flexed_angles = [angle[1] for angle in angles_list if angle[1] < threshold]
            return len(flexed_angles) > 10
        
        return False

    def checkCompleted(self,ego, arm):
        """
        Checks whether the elbow angle(s) of the specified arm(s) has decreased by a certain threshold over a period of time.
        When called, this function (i) appends a new angle to self.angles, (ii) smooths the angles using the smooth_angles() function,
        and (iii) checks if the angles have decreased by at least the threshold value, 
        i.e. smoothed_angles[0] - smoothed_angles[-1] > threshold.
        
        Input Arguments:
            1. ego (Unity object): contains the joint angle values
            2. arm (str): Which arm(s) to check. Must be one of:
                       - "Left": Check only the left elbow.
                       - "Right": Check only the right elbow.
                       - "Both": Check both elbows.

        Output Arguments:
            bool: True if the specified arm(s) have decreased their elbow angle by at least the self.threshold, else False.
        """
        global elbow_flexed
        if not ego.gameObject.joint_angles:
            return False

        left_angle = ego.gameObject.joint_angles.leftElbow
        right_angle = ego.gameObject.joint_angles.rightElbow
        self.angles.append((left_angle, right_angle))
        print(f"left/right angle: {(left_angle, right_angle)}")

        if len(self.angles) < self.smooth_window:
            print("Not enough data to smooth angles, returning False")
            # Not enough data to smooth, return False
            return False

        avg_angles = self.smooth_angles(self.angles)
        smoothed_angles = avg_angles[0 : len(avg_angles)]
        
        if arm.lower() == "both":
            # Check if both arms have decreased their elbow angles
            if (smoothed_angles[0][0] - smoothed_angles[-1][0] > self.threshold and
                smoothed_angles[0][1] - smoothed_angles[-1][1] > self.threshold) or self.alreadyFlexed(arm, smoothed_angles):
                elbow_flexed = True
            return (smoothed_angles[0][0] - smoothed_angles[-1][0] > self.threshold and
                    smoothed_angles[0][1] - smoothed_angles[-1][1] > self.threshold) or elbow_flexed
        elif arm.lower() == "left":
            # Check if the left arm has decreased its elbow angle
            if (smoothed_angles[0][0] - smoothed_angles[-1][0] > self.threshold) or self.alreadyFlexed(arm, smoothed_angles):
                elbow_flexed = True
            return (smoothed_angles[0][0] - smoothed_angles[-1][0] > self.threshold) or elbow_flexed
        elif arm.lower() == "right":
            # Check if the right arm has decreased its elbow angle
            print(f"angle change: {smoothed_angles[0][1] - smoothed_angles[-1][1]}")
            if (smoothed_angles[0][1] - smoothed_angles[-1][1] > self.threshold) or self.alreadyFlexed(arm, smoothed_angles):
                elbow_flexed = True
            return (smoothed_angles[0][1] - smoothed_angles[-1][1] > self.threshold) or elbow_flexed
        else:
            raise ValueError(f"Invalid arm option: {arm}")        

class CheckElbowExtension:
    """
    Checks whether the elbow of the specified arm(s) is extended by a certain threshold angle over a period of time.  
    Input Arguments:
        1. threshold (int, optional): The angle threshold in degrees to check against. Default is set to 10 degrees.
    """
    def __init__(self, threshold=10):
        self.smooth_window = 5
        self.threshold = threshold
        self.angles = []
        global elbow_extended
        elbow_extended = False

    def smooth_angles(self, traj: list[tuple]) -> list[tuple]:
        """
        Write a function to smooth the angles using a moving average filter.
        The function should take a list of angles and return a list of smoothed angles.
        When smoothing, it should consider the window size of self.smooth_window.
        """
        smoothed_angles = []
        for i in range(len(traj)):
            start = max(0, i - self.smooth_window // 2)
            end = min(len(traj), i + self.smooth_window // 2 + 1)
            left_avg = np.mean([angle[0] for angle in traj[start:end]])
            right_avg = np.mean([angle[1] for angle in traj[start:end]])
            smoothed_angles.append((left_avg, right_avg))
        return smoothed_angles

    def alreadyExtended(self, arm, angles_list, threshold = 130):
        """
        Checks if the elbow angle(s) of the specified arm(s) has already been extended by a certain threshold.
        This function is used to check if the elbow has already been extended before the current action is invoked.
        
        Input Arguments:
            1. arm (str): Which arm(s) to check. Must be one of:
                       - "Left": Check only the left elbow.
                       - "Right": Check only the right elbow.
                       - "Both": Check both elbows.
            2. angles_list (list): List of angles to check against.
            3. threshold (int): The angle threshold to check against.

        Output Arguments:
            bool: True if the specified arm(s) have already extended their elbow angle by at least the threshold, else False.
        """
        if "both" in arm.lower():
            # Check if both arms have extended their elbow angles
            left_extended_angles = [angle[0] for angle in angles_list if angle[0] > threshold]
            right_extended_angles = [angle[1] for angle in angles_list if angle[1] > threshold]
            return len(left_extended_angles) > 10 and len(right_extended_angles) > 10
        elif "left" in arm.lower():
            # Check if the left arm has extended its elbow angle
            extended_angles = [angle[0] for angle in angles_list if angle[0] > threshold]
            return len(extended_angles) > 10
        elif "right" in arm.lower():
            # Check if the right arm has extended its elbow angle
            extended_angles = [angle[1] for angle in angles_list if angle[1] > threshold]
            return len(extended_angles) > 10
        
        return False
    
    def checkCompleted(self, ego, arm):
        """
        Checks whether the elbow angle(s) of the specified arm(s) has increased by a certain threshold over a period of time.
        When called, this function (i) appends a new angle to self.angles, (ii) smooths the angles using the smooth_angles() function,
        and (iii) checks if the angles have increased by at least the threshold value, 
        i.e. smoothed_angles[0] - smoothed_angles[-1] > threshold.
        
        Input Arguments:
            1. ego (Unity object): contains the joint angle values
            2. arm (str): Which arm(s) to check. Must be one of:
                       - "Left": Check only the left elbow.
                       - "Right": Check only the right elbow.
                       - "Both": Check both elbows.
        Output Arguments:
            bool: True if the specified arm(s) have increased their elbow angle by at least the self.threshold, else False.
        """
        global elbow_extended
        if not ego.gameObject.joint_angles:
            return False

        left_angle = ego.gameObject.joint_angles.leftElbow
        right_angle = ego.gameObject.joint_angles.rightElbow
        self.angles.append((left_angle, right_angle))
        print(f"left/right angle: {(left_angle, right_angle)}")

        if len(self.angles) < self.smooth_window:
            print("Not enough data to smooth angles, returning False")
            # Not enough data to smooth, return False
            return False

        avg_angles = self.smooth_angles(self.angles)
        smoothed_angles = avg_angles[0: len(avg_angles)]
        if arm.lower() == "both":
            # Check if both arms have increased their elbow angles
            if (smoothed_angles[-1][0] - smoothed_angles[0][0] > self.threshold and
                smoothed_angles[-1][1] - smoothed_angles[0][1] > self.threshold) or self.alreadyExtended(arm, smoothed_angles):
                elbow_extended = True
            return (smoothed_angles[-1][0] - smoothed_angles[0][0] > self.threshold and
                    smoothed_angles[-1][1] - smoothed_angles[0][1] > self.threshold) or elbow_extended
        elif arm.lower() == "left":
            # Check if the left arm has increased its elbow angle
            if (smoothed_angles[-1][0] - smoothed_angles[0][0] > self.threshold) or self.alreadyExtended(arm, smoothed_angles):
                elbow_extended = True
            return (smoothed_angles[-1][0] - smoothed_angles[0][0] > self.threshold) or elbow_extended
        elif arm.lower() == "right":
            # Check if the right arm has increased its elbow angle
            print(f"angle change: {smoothed_angles[-1][1] - smoothed_angles[0][1]}")
            if (smoothed_angles[-1][1] - smoothed_angles[0][1] > self.threshold) or self.alreadyExtended(arm, smoothed_angles):
                elbow_extended = True
            return (smoothed_angles[-1][1] - smoothed_angles[0][1] > self.threshold) or elbow_extended
        
        return False

def CheckDistanceBetweenTwoObject(obj1, obj2, distance=0.05):
    """
    Checks if the Euclidean distance between two objects is less than a given threshold (in meter).
    THIS IS A HELPER FUNCTION WHICH SHOULD NEVER BE CALLED IN THE SCENIC PROGRAM.

    Input Arguments:
        1. obj1, obj2 (Unity object or Vector): Objects or Position Vectors we will use to check distance
        2. distance (float, optional): The threshold distance to compare against. Its default value is set to 0.15 meter

    Output Arguments:
        bool: True if the distance between obj1 and obj2 is less than the given threshold, False otherwise.
    """

    v1, v2 = None, None

    if isinstance(obj1, Vector):
        v1 = obj1
    else:
        v1 = obj1.gameObject.position

    if isinstance(obj2, Vector):
        v2 = obj2
    else:
        v2 = obj2.gameObject.position

    dis = ((v2[0] - v1[0])**2 + (v2[1] - v1[1])**2 + (v2[2] - v1[2])**2) ** 0.5
    print(dis)
    if dis < distance:
        print("object touched")
    return dis < distance

def CheckFaceTouch(ego, arm):
    """
    Checks whether the patient touches one's face with the specified arm(s).

    Input Arguments:
        1. ego (Unity object): The ego entity containing joint angle data, including the mouth's position and right hand position.
        2. arm (str, optional): arm (str): Specifies which arm(s) to check. Must be one of:
                            - "Left": Check only the left hand.
                            - "Right": Check only the right hand.

    Output Arguments:
        bool: True if the hand touches the face; otherwise, False. 
    """
    if not ego.gameObject.joint_angles:
        return False

    threshold = 0.2
    if "left" in arm.lower():
        return CheckDistanceBetweenTwoObject(ego.gameObject.joint_angles.leftPalm, ego.gameObject.joint_angles.mouthPos, threshold)
    elif "right" in arm.lower():
        return CheckDistanceBetweenTwoObject(ego.gameObject.joint_angles.rightPalm, ego.gameObject.joint_angles.mouthPos, threshold)
    else:
        raise ValueError(f"Invalid arm option: {arm}")

def CheckObjectTouch(ego, arm, obj):
    if not ego.gameObject.joint_angles:
        return False
    if "left" in arm.lower():
        return CheckDistanceBetweenTwoObject(ego.gameObject.joint_angles.leftPalm, obj)
    elif "right" in arm.lower():
        return CheckDistanceBetweenTwoObject(ego.gameObject.joint_angles.rightPalm, obj)
    else:
        raise ValueError(f"Invalid arm option: {arm}")


def CheckFingerFlexion(ego, arm, finger, threshold=110):
    """
    Checks whether the specified finger on the given arm(s) is flexed below a certain threshold degree.
    Input Arguments:
        1. ego (Unity object): The ego object containing joint angle data.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
                   - "Left": Check only the left hand.
                   - "Right": Check only the right hand.
                   - "Both": Check both hands.
        3. finger (str): Specifies which finger to check. Must be one of:
                   - "Thumb"
                   - "Index"
                   - "Middle"
                   - "Ring"
                   - "Pinky" <-- equivalent to little finger
        4. threshold (int, optional): The angle threshold to check against. Default is set to 110 degrees.

    Output Arguments:
        bool: True if the specified finger joint angle(s) are below the threshold, indicating flexion, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False

    def is_flexed(side):
        ja = ego.gameObject.joint_angles
        if finger == "Thumb":
            return getattr(ja, f"{side}ThumbIPFlexion") < threshold and getattr(ja, f"{side}ThumbCMCFlexion") < threshold
        elif finger == "Index":
            return (getattr(ja, f"{side}IndexMCPFlexion") < threshold and
                    getattr(ja, f"{side}IndexPIPFlexion") < threshold and
                    getattr(ja, f"{side}IndexDIPFlexion") < threshold)
        elif finger == "Middle":
            return (getattr(ja, f"{side}MiddleMCPFlexion") < threshold and
                    getattr(ja, f"{side}MiddlePIPFlexion") < threshold and
                    getattr(ja, f"{side}MiddleDIPFlexion") < threshold)
        elif finger == "Ring":
            return (getattr(ja, f"{side}RingMCPFlexion") < threshold and
                    getattr(ja, f"{side}RingPIPFlexion") < threshold and
                    getattr(ja, f"{side}RingDIPFlexion") < threshold)
        elif finger == "Pinky":
            return (getattr(ja, f"{side}PinkyMCPFlexion") < threshold and
                    getattr(ja, f"{side}PinkyPIPFlexion") < threshold and
                    getattr(ja, f"{side}PinkyDIPFlexion") < threshold)
        else:
            raise ValueError(f"Invalid finger option: {finger}")

    if arm == "Both":
        return is_flexed("left") or is_flexed("right")
    elif arm == "Left":
        return is_flexed("left")
    elif arm == "Right":
        return is_flexed("right")
    else:
        raise ValueError(f"Invalid arm option: {arm}")

def CheckFingerExtension(ego, arm, finger, threshold=140):
    """
    Checks whether the specified finger on the given arm(s) is extended above a certain threshold degree.
    Input Arguments:
        1. ego (Unity object): The ego object containing joint angle data.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
                   - "Left": Check only the left hand.
                   - "Right": Check only the right hand.
                   - "Both": Check both hands.
        3. finger (str): Specifies which finger to check. Must be one of:
                   - "Thumb"
                   - "Index"
                   - "Middle"
                   - "Ring"
                   - "Pinky" <-- equivalent to little finger
        4. threshold (int, optional): The angle threshold to check against. Default is set to 110 degrees.

    Output Arguments:
        bool: True if the specified finger joint angle(s) are above the threshold, indicating extension, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False

    def is_flexed(side):
        ja = ego.gameObject.joint_angles
        if finger == "Thumb":
            return getattr(ja, f"{side}ThumbIPFlexion") > threshold and getattr(ja, f"{side}ThumbCMCFlexion") > threshold
        elif finger == "Index":
            return (getattr(ja, f"{side}IndexMCPFlexion") > threshold and
                    getattr(ja, f"{side}IndexPIPFlexion") > threshold and
                    getattr(ja, f"{side}IndexDIPFlexion") > threshold)
        elif finger == "Middle":
            return (getattr(ja, f"{side}MiddleMCPFlexion") > threshold and
                    getattr(ja, f"{side}MiddlePIPFlexion") > threshold and
                    getattr(ja, f"{side}MiddleDIPFlexion") > threshold)
        elif finger == "Ring":
            return (getattr(ja, f"{side}RingMCPFlexion") > threshold and
                    getattr(ja, f"{side}RingPIPFlexion") > threshold and
                    getattr(ja, f"{side}RingDIPFlexion") > threshold)
        elif finger == "Pinky":
            return (getattr(ja, f"{side}PinkyMCPFlexion") > threshold and
                    getattr(ja, f"{side}PinkyPIPFlexion") > threshold and
                    getattr(ja, f"{side}PinkyDIPFlexion") > threshold)
        else:
            raise ValueError(f"Invalid finger option: {finger}")

    if arm == "Both":
        return is_flexed("left") or is_flexed("right")
    elif arm == "Left":
        return is_flexed("left")
    elif arm == "Right":
        return is_flexed("right")
    else:
        raise ValueError(f"Invalid arm option: {arm}")


def CheckClosedPalm(ego, arm, threshold=110):
    """
    Determines whether all the fingers of the specified arm(s) is closed, creating a fist.

    Input Arguments:
        1. ego: contains the finger joint angle values of the avatar.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
                   - "Left": Check only the left hand.
                   - "Right": Check only the right hand.
                   - "Both": Check both hands.
        3. threshold (int, optional): The angle threshold to check against. Default is set to 140 degrees.

    Output Arguments:
        bool: True if all finger joint angles are above the threshold angle, representing a complete open plam, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False

    def is_open(side):
        ja = ego.gameObject.joint_angles
        return (
            getattr(ja, f"{side}ThumbIPFlexion") < threshold and
            getattr(ja, f"{side}ThumbCMCFlexion") < threshold and
            getattr(ja, f"{side}IndexMCPFlexion") < threshold and
            getattr(ja, f"{side}IndexPIPFlexion") < threshold and
            getattr(ja, f"{side}IndexDIPFlexion") < threshold and
            getattr(ja, f"{side}MiddleMCPFlexion") < threshold and
            getattr(ja, f"{side}MiddlePIPFlexion") < threshold and
            getattr(ja, f"{side}MiddleDIPFlexion") < threshold and
            getattr(ja, f"{side}RingMCPFlexion") < threshold and
            getattr(ja, f"{side}RingPIPFlexion") < threshold and
            getattr(ja, f"{side}RingDIPFlexion") < threshold and
            getattr(ja, f"{side}PinkyMCPFlexion") < threshold and
            getattr(ja, f"{side}PinkyPIPFlexion") < threshold and
            getattr(ja, f"{side}PinkyDIPFlexion") < threshold
        )
    print(is_open("right"))
    if arm == "Both":
        return is_open("left") and is_open("right")
    elif arm == "Left":
        return is_open("left")
    elif arm == "Right":
        return is_open("right")
    else:
        raise ValueError(f"InvaOpenLid arm option: {arm}")


def CheckOpenPalm(ego, arm, threshold=140):
    """
    Determines whether the all the fingers on the specified arm(s) is opened or extended.

    Input Arguments:
        1. ego: contains the finger joint angle values of the avatar.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
                   - "Left": Check only the left hand.
                   - "Right": Check only the right hand.
                   - "Both": Check both hands.
        3. threshold (int, optional): The angle threshold to check against. Default is set to 140 degrees.

    Output Arguments:
        bool: True if all finger joint angles are above the threshold angle, representing a complete open plam, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False

    def is_open(side):
        ja = ego.gameObject.joint_angles
        return (
            getattr(ja, f"{side}ThumbIPFlexion") > threshold and
            getattr(ja, f"{side}ThumbCMCFlexion") > threshold and
            getattr(ja, f"{side}IndexMCPFlexion") > threshold and
            getattr(ja, f"{side}IndexPIPFlexion") > threshold and
            getattr(ja, f"{side}IndexDIPFlexion") > threshold and
            getattr(ja, f"{side}MiddleMCPFlexion") > threshold and
            getattr(ja, f"{side}MiddlePIPFlexion") > threshold and
            getattr(ja, f"{side}MiddleDIPFlexion") > threshold and
            getattr(ja, f"{side}RingMCPFlexion") > threshold and
            getattr(ja, f"{side}RingPIPFlexion") > threshold and
            getattr(ja, f"{side}RingDIPFlexion") > threshold and
            getattr(ja, f"{side}PinkyMCPFlexion") > threshold and
            getattr(ja, f"{side}PinkyPIPFlexion") > threshold and
            getattr(ja, f"{side}PinkyDIPFlexion") > threshold
        )
    print(is_open("right"))
    if arm == "Both":
        return is_open("left") and is_open("right")
    elif arm == "Left":
        return is_open("left")
    elif arm == "Right":
        return is_open("right")
    else:
        raise ValueError(f"InvaOpenLid arm option: {arm}")


def CheckFingerTouch(ego, arm, finger1, finger2, threshold_dist=0.02):
    """
    Checks whether the given two fingers on the same hand are touching each other.

    Input Arguments:
        1. ego (Unity object): The ego entity containing joint angle data, including fingertip positions.
        2. arm (str): Specifies which arm to check. Must be one of:
            - "Left": Check only the left hand.
            - "Right": Check only the right hand.
        3. finger1 (str): One of ["Thumb", "Index", "Middle", "Ring", "Pinky"].
        4. finger2 (str): One of ["Thumb", "Index", "Middle", "Ring", "Pinky"].
        5. threshold_dist (float, optional): Maximum distance for fingers to be considered “touching.”
                                             This value should be at least 0.02 meters but less than 0.03 meters.

    Output Arguments:
        bool: True if the two specified fingertips are within threshold_dist of each other, False otherwise.
    """
    print(f"CheckFingerTouch called")
    if not ego.gameObject.joint_angles:
        return False
    fingers = ["Thumb", "Index", "Middle", "Ring", "Pinky"]
    if finger1.title() not in fingers or finger2.title() not in fingers:
        raise ValueError(f"Invalid finger option: {finger1} or {finger2}")

    arm_lower = arm.lower()
    if "left" in arm_lower:
        prefix = "left"
    elif "right" in arm_lower:
        prefix = "right"
    else:
        raise ValueError(f"Invalid arm option: {arm}")

    if finger1 == finger2:
        return False

    ja = ego.gameObject.joint_angles

    # Construct attribute names for fingertips, e.g. "leftThumbTip"
    attr1 = f"{prefix}{finger1.title()}Tip"
    attr2 = f"{prefix}{finger2.title()}Tip"
    print(f"Checking fingertips: {attr1}, {attr2}")

    pos1 = getattr(ja, attr1, None)
    pos2 = getattr(ja, attr2, None)
    if pos1 is None or pos2 is None:
        print(f"One or both fingertips not found: {attr1} or {attr2}")
        return False

    dist = CheckDistanceBetweenTwoObject(pos1, pos2, threshold_dist)
    print(f"dist: {dist}")
    return dist

def CheckBetweenFingerAngle(ego, arm, case, finger1, finger2, threshold_degree=10):
    """
    Checks whether the angle between two adjacent fingers on the same hand is more than a threshold.

    Input Arguments:
        1. ego (Unity object): The ego entity containing joint angle data.
        2. arm (str): Specifies which arm to check. Must be one of:
            - "Left": Check only the left hand.
            - "Right": Check only the right hand.
        3. case (str): Specifies whether the fingers should be spread or adducted. Its value must be one of:
            - "Spread": Check if the fingers are spread apart.
            - "Adducted": Check if the fingers are close together.
        4. finger1 (str): One of ["Thumb", "Index", "Middle", "Ring", "Pinky"].
        4. finger2 (str): One of ["Thumb", "Index", "Middle", "Ring", "Pinky"].
        5. threshold_degree (float, optional): by default, set to 10 degrees. 
            The feasible range of threshold_degree is between 10 and 15 degrees for all adjacent fingers, except "Thumb" and "Index",
            whose threshold should be between 20 to 70 degrees.

    Output Arguments:
        bool: True if the specified adjacent fingers’ angle is above threshold_degree when case = "Spread"
              or if the specified adjacent fingers' angle is below threshold_degree when case = "Adducted";
              otherwise, False.
    """
    if not ego.gameObject.joint_angles:
        return False
    fingers = ["Thumb", "Index", "Middle", "Ring", "Pinky"]
    if finger1.title() not in fingers or finger2.title() not in fingers:
        raise ValueError(f"Invalid finger option: {finger1} or {finger2}")

    arm_lower = arm.lower()
    if "left" in arm_lower:
        prefix = "left"
    elif "right" in arm_lower:
        prefix = "right"
    else:
        raise ValueError(f"Invalid arm option: {arm}")

    adjacency = {
        ("Thumb", "Index"): "ThumbIndex",
        ("Index", "Middle"): "IndexMiddle",
        ("Middle", "Ring"): "MiddleRing",
        ("Ring", "Pinky"): "RingPinky"
    }

    pair = (finger1.title(), finger2.title())
    if pair not in adjacency:
        pair = (finger2.title(), finger1.title())
        if pair not in adjacency:
            raise ValueError(f"Fingers '{finger1}' and '{finger2}' are not adjacent")

    suffix = adjacency[pair]
    attr_name = f"{prefix}{suffix}Angle"

    ja = ego.gameObject.joint_angles
    angle_value = getattr(ja, attr_name, None)
    print(f"{attr_name}: {angle_value}")
    print(f"threshold: {threshold_degree}")
    if angle_value is None:
        return False
    
    if "spread" in case.lower():
        return angle_value > threshold_degree
    elif "adducted" in case.lower():
        return angle_value < threshold_degree

    return False

def CheckFingerSpread(ego, arm, threshold_degree=7):
    """
    Checks whether all the fingers on the specified aCheckFingerSpreadrm(s) are spread apart by more than a threshold angle.

    Input Arguments:
        1. ego (Unity object): The ego entity containing joint angle data.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
            - "Left": Check only the left hand.
            - "Right": Check only the right hand.
            - "Both": Check both hands.
        3. threshold_degree (float, optional): The angle threshold in degrees to check against. Default is set to 15 degrees.
    Output Arguments:
        bool: True if the angle between all adjacent fingers is greater than threshold_degree, False otherwise.
    """
    if not ego.gameObject.joint_angles:
        return False
    
    correctness = []

    if "left" in arm.lower():
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Thumb", "Index", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Ring", "Pinky", threshold_degree))
    elif "right" in arm.lower():
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Thumb", "Index", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Ring", "Pinky", threshold_degree))
    elif "both" in arm.lower():
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Thumb", "Index", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Spread", "Ring", "Pinky", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Thumb", "Index", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Spread", "Ring", "Pinky", threshold_degree))

    outcome = all(correctness)
    print(f"CheckFingerSpread: {outcome}")

    return all(correctness) and len(correctness) > 0

def CheckFingerAdduction(ego, arm, threshold_degree=8):
    """
    Checks whether all the fingers on the specified arm(s) are adducted, i.e. fingers are close together and not spread apart,
    by less than a threshold angle.

    Input Arguments:
        1. ego (Unity object): The ego entity containing joint angle data.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
            - "Left": Check only the left hand.
            - "Right": Check only the right hand.
            - "Both": Check both hands.
        3. threshold_degree (float, optional): The angle threshold in degrees to check against. Default is set to 15 degrees.
    Output Arguments:
        bool: True if the angle between all adjacent fingers is greater than threshold_degree, False otherwise.
    """
    if not ego.gameObject.joint_angles:
        return False

    correctness = []
    if "left" in arm.lower():
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Thumb", "Index", 20))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Ring", "Pinky", threshold_degree))
    elif "right" in arm.lower():
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Thumb", "Index", 20))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Ring", "Pinky", threshold_degree))
    elif "both" in arm.lower():
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Thumb", "Index", 20))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Left", "Adducted", "Ring", "Pinky", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Thumb", "Index", 20))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Index", "Middle", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Middle", "Ring", threshold_degree))
        correctness.append(CheckBetweenFingerAngle(ego, "Right", "Adducted", "Ring", "Pinky", threshold_degree))
    
    print(f"correctness: {correctness}")
    outcome = all(correctness)
    print(f"CheckFingerAdduction: {outcome}")

    return all(correctness) and len(correctness) > 0


def CheckWristSupination(ego, arm, threshold=60):
    """
    Determines whether the wrist on the specified arm(s) is supinated, palm facing up. 

    Input Arguments:
        1. ego: contains the wrist supination angle values of the avatar.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
                   - "Left": Check only the left wrist.
                   - "Right": Check only the right wrist.
                   - "Both": Check both wrists.
        3. threshold (int, optional): The angle threshold to check against. Default is set to 45 degrees,
        where zero degrees represents a pose where thumb is facing the ceiling.

    Output Arguments:
        bool: True if the wrist supination angle(s) exceed threshold degrees, representing supination, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False
    
    print(f"left wrist: {ego.gameObject.joint_angles.leftWristSupination}, right: {ego.gameObject.joint_angles.rightWristSupination}")
    print(f"angle > threshold: {threshold}")

    if arm == "Both":
        return ego.gameObject.joint_angles.leftWristSupination > threshold and ego.gameObject.joint_angles.rightWristSupination > threshold
    elif arm == "Left":
        return ego.gameObject.joint_angles.leftWristSupination > threshold
    elif arm == "Right":
        return ego.gameObject.joint_angles.rightWristSupination > threshold
    else:
        raise ValueError(f"Invalid arm option: {arm}")

def CheckWristPronation(ego, arm, threshold=30):
    """
    Determines whether the wrist on the specified arm(s) is pronated, i.e. palm facing down.

    Input Arguments:
        1. ego: contains the wrist supination angle values of the avatar.
        2. arm (str): Specifies which arm(s) to check. Must be one of:
                   - "Left": Check only the left wrist.
                   - "Right": Check only the right wrist.
                   - "Both": Check both wrists.
        3. threshold (int, optional): The angle threshold to check against. Default is set to -45 degrees.
           where zero degrees represents a pose where thumb is facing the ceiling.

    Output Arguments:
        bool: True if the wrist supination angle(s) are less than threshold degrees,
              representing pronation, otherwise False.
    """
    if not ego.gameObject.joint_angles:
        return False
    threshold = -1*threshold  # Convert to negative for pronation check

    print(f"left wrist: {ego.gameObject.joint_angles.leftWristSupination}, right: {ego.gameObject.joint_angles.rightWristSupination}")
    print(f"angle < threshold: {threshold}")
    if arm == "Both":
        return ego.gameObject.joint_angles.leftWristSupination < threshold and ego.gameObject.joint_angles.rightWristSupination < threshold
    elif arm == "Left":
        return ego.gameObject.joint_angles.leftWristSupination < threshold
    elif arm == "Right":
        return ego.gameObject.joint_angles.rightWristSupination < threshold
    else:
        raise ValueError(f"Invalid arm option: {arm}")

class CheckDuration:
    """
    Returns whether a specified body pose estimation (BPE) API (in the given API library) is satisfied for a period of time. 
    To use this function, pass the name of a function defined in the same file, then call `checkCompleted()` at
    regular intervals (e.g., every 0.1 seconds).

    **Sample Scenic Code**
    take SpeakAction('Right arm remained straightened for 2 seconds')
    take DoneAction()
    cd = CheckDuration("CheckFingerSpread", 2, ego, "Right", "Spread", "Index", "Middle")
    while not cd.checkCompleted():
        wait()
    """

    def __init__(self,
                 condition_name: str,
                 duration: int,
                 *args: Any,
                 **kwargs: Any):
        """
        Parameters:
            condition_name (str):
                The name of a BPE API (returning bool) in the given API library.
                It CANNOT be non-BPE APIs such as "RequestActionResult", "SendImageAndTextRequestAction", "RecordVideoAndEvaluateAction", etc.
            duration (int):
                The required time in seconds that the BPE API must remain True.
            *args: Any
                Positional arguments to pass to the BPE API.
            **kwargs: Any
                Keyword arguments to pass to the BPE API.
        """
        # Lookup the function by name in the global namespace
        elbow_condition = False
        try:
            if "CheckElbowExtension".lower() in condition_name.lower():
                ext = CheckElbowExtension()
                func = ext
                elbow_condition = True
            elif "CheckElbowBend".lower() in condition_name.lower():
                flx = CheckElbowBend()
                func = flx
                elbow_condition = True
            else:
                func = globals()[condition_name]
        except KeyError:
            raise ValueError(f"No function named '{condition_name}' found in globals()")

        if not callable(func):
            print(f"Global '{condition_name}' is not callable")
            # raise ValueError(f"Global '{condition_name}' is not callable")

        self.condition = func
        self.args = args
        self.kwargs = kwargs
        self.duration = duration * 10 # Convert seconds into 0.1-second ticks
        self.count = 0
        self.elbow_condition = elbow_condition
        print(f"CheckDuration initialized with func: {func}")

    def checkCompleted(self) -> bool:
        """
        Checks whether the specified BPE API has been continuously True for
        the required duration. 

        Returns:
            bool:
                True when the condition has been True for the full duration in ticks,
                False otherwise.
        """
        if self.elbow_condition:
            # print("elbow condition True")
            # print(f"self.condition: {self.condition}")
            # print(f"self.args: {self.args}")
            # print(f"self.kwargs: {self.kwargs}")
            # print(f"self.condition.checkCompleted(): {self.condition.checkCompleted(*self.args, *self.kwargs)}")
            if self.condition.checkCompleted(*self.args, **self.kwargs):
                self.count += 1
                print(f"CheckDuration Success count: {self.count}")
                if self.count >= self.duration:
                    print(f"CheckDuration COMPLETED")
                    return True
            else:
                print("CheckDuration Failed, resetting count")
                self.count = 0
        else:
            print("elbow condition False")
            if self.condition(*self.args, **self.kwargs):
                self.count += 1
                print(f"CheckDuration Success count: {self.count}")
                if self.count >= self.duration:
                    print(f"CheckDuration COMPLETED")
                    return True
            else:
                self.count = 0
        return False