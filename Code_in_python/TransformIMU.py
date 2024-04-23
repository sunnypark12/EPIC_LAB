import os
import pandas as pd
import numpy as np
import re

def TransformIMUs(segments, positions, **kwargs):
    """
    Transform IMUs
    
    This function creates a new set of IMUs at locations specified by the user
    
    Parameters:
    segments (list): a list of the body segments where new IMUs are to be calculated
    positions (ndarray): a three dimensional (x,y,z) position of the new IMU for each of the segments
    
    Optional Parameters:
    inputDir (str): sets the directory to read data from (default get via gui)
    outputExt (str): sets the output suffix for the file (default: _imu_new)
    subjects (list): sets the subjects to transform (default all subjects)
    trialNames (list): sets the trials to transform (default all trials)
    overwrite (bool): flag for overwriting previous files (default: False)
    
    Returns:
    None
    """
    inputDir = kwargs.get('inputDir', '')
    outputExt = kwargs.get('outputExt', '_imu_new')
    subjects = kwargs.get('subjects', [])
    trialNames = kwargs.get('trialNames', [])
    overwrite = kwargs.get('overwrite', False)
    
    if not isinstance(segments, list) or not isinstance(positions, np.ndarray):
        raise TypeError("segments must be a list and positions must be a numpy ndarray")
    
    if len(segments) != positions.shape[0]:
        raise ValueError("Number of segments and positions must match")
    
    if positions.shape[1] != 3:
        raise ValueError("Positions must be 3 dimensional row vectors")
    
    if not isinstance(inputDir, str):
        raise TypeError("inputDir must be a string")
    
    if not isinstance(outputExt, str):
        raise TypeError("outputExt must be a string")
    
    if not isinstance(subjects, list):
        raise TypeError("subjects must be a list")
    
    if not isinstance(trialNames, list):
        raise TypeError("trialNames must be a list")
    
    if not isinstance(overwrite, bool):
        raise TypeError("overwrite must be a boolean")
    
    if not os.path.isdir(inputDir) or not os.listdir(inputDir):
        raise ValueError("Invalid input directory")
    
    sensorStruct = {}
    
    for segment, position in zip(segments, positions):
        if 'Pelvis' in segment:
            sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'Pelvis_V', segment + '_X')
            sensorStruct[segment]['P_O'] = np.array([-185, 25, 0]) / 1000
            sensorStruct[segment]['P_N'] = position / 1000
        elif 'Thigh' in segment:
            sensorStruct = UpdateSensorStruct(sensorStruct, segment, segment + '_V', segment + '_X')
            sensorStruct[segment]['P_O'] = np.array([130, -250, 0]) / 1000
            sensorStruct[segment]['P_N'] = position / 1000
        elif 'Shank' in segment:
            sensorStruct = UpdateSensorStruct(sensorStruct, segment, segment + '_V', segment + '_X')
            sensorStruct[segment]['P_O'] = np.array([50, -250, 0]) / 1000
            sensorStruct[segment]['P_N'] = position / 1000
        elif 'Foot' in segment:
            sensorStruct = UpdateSensorStruct(sensorStruct, segment, segment + '_V', segment + '_X')
            sensorStruct[segment]['P_O'] = np.array([177, 25, 0]) / 1000
            sensorStruct[segment]['P_N'] = position / 1000
    
    sensorNames = list(sensorStruct.keys())
    
    for subject in subjects:
        subjectDir = os.path.join(inputDir, subject)
        
        if not os.path.isdir(subjectDir):
            raise ValueError(f"Subject {subject} does not exist in directory {inputDir}")
        
        trials = [trial for trial in os.listdir(subjectDir) if os.path.isdir(os.path.join(subjectDir, trial))]
        
        if trialNames:
            matches = [trial for trial in trials if any(re.match(trialName, trial) for trialName in trialNames)]
            trials = list(set(trials).intersection(matches))
            
            if not trials:
                print(f"WARNING: Subject {subject} missing trials: {', '.join(trialNames)}")
        
        for trial in trials:
            trialDir = os.path.join(subjectDir, trial)
            imuNewFilePath = os.path.join(trialDir, f"{subject}_{trial}{outputExt}.csv")
            
            if os.path.isfile(imuNewFilePath) and not overwrite:
                print(f"{subject}_{trial} already calculated!")
                continue
            
            imuSimFilePath = os.path.join(trialDir, f"{subject}_{trial}_imu_sim.csv")
            imuSim = pd.read_csv(imuSimFilePath)
            
            print(f"Calculating {imuNewFilePath}")
            
            imuNewTable = imuSim[['time']]
            
            for sensorName in sensorNames:
                sensorNameOrig = sensorStruct[sensorName]['names']['old']
                sensorNameNew = sensorStruct[sensorName]['names']['new']
                accelNamesOrig = [sensorNameOrig + '_ACC' + axis for axis in ['X', 'Y', 'Z']]
                accelNamesNew = [sensorNameNew + '_ACC' + axis for axis in ['X', 'Y', 'Z']]
                gyroNamesOrig = [sensorNameOrig + '_GYRO' + axis for axis in ['X', 'Y', 'Z']]
                gyroNamesNew = [sensorNameNew + '_GYRO' + axis for axis in ['X', 'Y', 'Z']]
                
                accelOrig = imuSim[accelNamesOrig]
                gyroOrig = imuSim[gyroNamesOrig]
                gyroOrig = gyroOrig * (np.pi / 180)
                
                P_O = sensorStruct[sensorName]['P_O']
                P_N = sensorStruct[sensorName]['P_N']
                
                P = P_N - P_O
                
                gyroNew = gyroOrig.to_numpy()
                accelNew = accelOrig.to_numpy()
                angAccel = np.gradient(gyroNew, 0.005, axis=0)
                accelNew = TranslateAccelerometer(accelNew, gyroNew, angAccel, P)
                
                gyroNew = gyroNew * (180 / np.pi)
                
                accelNew = pd.DataFrame(accelNew, columns=accelNamesNew)
                gyroNew = pd.DataFrame(gyroNew, columns=gyroNamesNew)
                
                imuNewTable = pd.concat([imuNewTable, accelNew, gyroNew], axis=1)
            
            print(f"Writing {imuNewFilePath}")
            imuNewTable.to_csv(imuNewFilePath, index=False)

def UpdateSensorStruct(sensorStruct, name, oldName, newName):
    """
    Helper function to update sensorStruct
    
    Parameters:
    sensorStruct (dict): the sensor structure to update
    name (str): the name of the sensor
    oldName (str): the old name of the sensor
    newName (str): the new name of the sensor
    
    Returns:
    dict: the updated sensor structure
    """
    sensorStruct[name] = {
        'names': {
            'old': oldName,
            'new': newName
        }
    }
    return sensorStruct

def TranslateAccelerometer(oAcc, angVel, angAcc, translation):
    """
    Helper function to translate accelerometer data
    
    Parameters:
    oAcc (ndarray): the original accelerometer data
    angVel (ndarray): the angular velocity data
    angAcc (ndarray): the angular acceleration data
    translation (ndarray): the translation vector
    
    Returns:
    ndarray: the translated accelerometer data
    """
    a_r = np.cross(angAcc, translation)
    w_w_r = np.cross(angVel, np.cross(angVel, translation))
    nAcc = oAcc + a_r + w_w_r
    return nAcc