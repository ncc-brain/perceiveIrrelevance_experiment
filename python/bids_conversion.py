from pathlib import Path
import pandas as pd
import numpy as np
from config import source_root


def beh_cleanup(subject_id):

    # Load the log file:
    log_table = pd.read_csv(Path(source_root, subject_id, 'trials.csv'))

    # Prepare clean up table:
    events_tbl = pd.DataFrame(columns=["onset", "duration", "block_type", "event_type", "target_group", "category", 
                                       "duration_str", "orientation", "task_relevance", "stim_id", "response_time", 
                                       "response"])  
    
    # Extract subject general info:
    target_group = 'Object' if log_table['conditionFace'].isnull().values.all() else 'Face'

    # Sort the rows:
    log_table = log_table.sort_values(by=['Task_Nr', 'Trial_Nr']).reset_index(drop=True)

    onset = 0
    # Loop through each trial:
    for trial_i, trial in log_table.iterrows():
        # Extract the block type:
        if 'Practice' in trial['Task_Name'] or 'End' in trial['Task_Name'] or 'Calibration' in trial['Task_Name'] or 'introduction' in trial['Task_Name']:
            continue 
        elif 'PostSurprise' in trial['Task_Name']:
            block_type = 'post-surprise'
        else:
            if trial['stimulusIDCritical'] != trial['stimulusIDCritical']:
                block_type = 'pre-surprise'
            else:
                block_type = 'surprise'

        # Extract stimulus ID:
        if block_type == 'post-surprise':
            stim_id = trial['stimulusIDPost']
        else:
            stim_id = trial['StimulusID ']

        if 'face' in stim_id.lower():
            category = 'face'
        else:
            category = 'object'

        # Extract orientation:
        if 'center' in stim_id.lower():
            orientation = 'center'
        elif 'right' in stim_id.lower():
            orientation = 'right'
        else:
            orientation = 'left'

        # Extract the task relevance:
        if 'target' in stim_id.lower():
            task_relevance = 'target' 
        else:
            task_relevance = 'non-target'

        # Extract the duration:
        if block_type == 'post-surprise':
            duration_str = trial['duration' + target_group]
        else:
            duration_str = trial['stimulusDurationPost']

        # Response:
        if trial['reactionTime'] != trial['reactionTime']:  # Check if Nan
            response_time = np.nan
            response = np.nan
        else:
            response_time = trial['reactionTime']
            response = 'hit' if task_relevance == 'target' else 'fa'
        # Add info to the table:
        events_tbl = pd.concat([events_tbl, pd.DataFrame({
            "onset": onset,
            "duration": 0.5 if duration_str == 'short' else 1.5,
            "block_type": block_type if block_type != 'surprise' else 'pre-surprise',
            "event_type": 'stimulus',
            "target_group": target_group,
            "category": category,
            "duration_str": duration_str,
            "orientation": orientation,
            "task_relevance": task_relevance,
            "stim_id": stim_id,
            "response_time": response_time,
            "response": response
        }, index=[0])], ignore_index=True)

        onset += 2.5

        # ===================================================================
        # Surprise trial:
        if block_type == 'surprise':
            stim_id = trial['stimulusIDCritical']
            # Extract duration:
            category = 'face' if 'Face' in stim_id else 'object'
            task_relevance = 'target'
            duration_str = trial['stimulusDurationCritical']
            if 'Center' in stim_id:
                orientation = 'center'
            elif 'Left' in stim_id:
                orientation = 'left'
            else:
                orientation = 'right'

            if trial['reactionTime'] != trial['reactionTime']:  # Check if Nan
                response_time = np.nan
                response = np.nan
            else:
                response_time = trial['reactionTime']
                response = 'hit' if task_relevance == 'target' else 'fa'
            # Add all that info to the table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": 'surprise',
                    "event_type": 'stimulus',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_time,
                    "response": response
                }, index=[0])], ignore_index=True)
            onset += 2.5
            
            # ===================================================================
            # Surprise probes, confidence ratings and mind wandering probes:
            # ===========================
            # Orientation probe:
            # Check orientation options:
            option_1 = trial['criticalOrientation1Stim']
            if 'Center' in option_1:
                option_1 = 'center'
            elif 'Left' in option_1:
                option_1 = 'left'
            else:
                option_1 = 'right'
            option_2 = trial['criticalOrientation2Stim']
            if 'Center' in option_1:
                option_2 = 'center'
            elif 'Left' in option_1:
                option_2 = 'left'
            else:
                option_2 = 'right'
            
            # Check the response participants gave:
            response_orientation = option_1 if trial['CBcriticalOrientation1'] else option_2
            response_times_orientation = trial['orientationRT'] - trial['OrientationOnset']
            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": 'surprise',
                    "event_type": 'probe_orientation',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_orientation * 10**(-3),
                    "response": response_orientation
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_orientation * 10**(-3)

            # ===========================
            # Orientation confidence rating:        
            response_orientation = trial['confidenceOrientationCritical']
            response_times_orientation = trial['confidenceOrientationRT'] - trial['orientationConfidenceOnset']
            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": 'surprise',
                    "event_type": 'probe_orientation_confidence',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_orientation * 10**(-3),
                    "response": response_orientation
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_orientation * 10**(-3)

            # ===========================
            # Duration probe:
            response_duration = 'short' if trial['criticalDurationShort'] else 'long'
            response_times_duration = trial['durationRT']

            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": 'surprise',
                    "event_type": 'probe_duration',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_duration * 10**(-3),
                    "response": response_duration
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_duration * 10**(-3)

            
            # ===========================
            # Duration confidence:
            response_duration = trial['confidenceDurationCritical']
            response_times_duration = trial['confidenceDurationRT'] - trial['durationConfidenceOnset']

            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": 'surprise',
                    "event_type": 'probe_duration_confidence',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_duration * 10**(-3),
                    "response": response_duration
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_duration * 10**(-3)

            # ===========================
            # Mind wandering:
            response_mw = trial['mindWanderingQuestion']
            response_times_mw = trial['mindWanderingRT']

            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": 'surprise',
                    "event_type": 'probe_mind_wandering',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_mw * 10**(-3),
                    "response": response_mw
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_duration * 10**(-3)

        # ===================================================================
        # Post-Surprise trial:
        if block_type == 'post-surprise':
            # ===========================
            # Check orientation options:
            option_1 = trial['postOrientation1Stim']
            if 'Center' in option_1:
                option_1 = 'center'
            elif 'Left' in option_1:
                option_1 = 'left'
            else:
                option_1 = 'right'
            option_2 = trial['postOrientation2Stim']
            if 'Center' in option_1:
                option_2 = 'center'
            elif 'Left' in option_1:
                option_2 = 'left'
            else:
                option_2 = 'right'
            
            # Check the response participants gave:
            response_orientation = option_1 if trial['postOrientation1'] else option_2
            response_times_orientation = trial['orientationRT'] - trial['OrientationOnset']
            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": block_type,
                    "event_type": 'probe_orientation',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_orientation * 10**(-3),
                    "response": response_orientation
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_orientation * 10**(-3)

            # ===========================
            # Orientation confidence rating:        
            response_orientation = trial['confidenceOrientationPostt']
            response_times_orientation = trial['confidenceOrientationRT']
            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": block_type,
                    "event_type": 'probe_orientation_confidence',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_orientation * 10**(-3),
                    "response": response_orientation
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_orientation * 10**(-3)

            # ===========================
            # Duration probe:
            response_duration = 'short' if trial['postDurationShort'] else 'long'
            response_times_duration = trial['durationRT']

            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": block_type,
                    "event_type": 'probe_duration',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_duration * 10**(-3),
                    "response": response_duration
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_duration * 10**(-3)

            
            # ===========================
            # Duration confidence:
            response_duration = trial['confidenceDurationPostt']
            response_times_duration = trial['confidenceDurationRT']

            # Fill table:
            events_tbl = pd.concat([events_tbl, pd.DataFrame({
                    "onset": onset,
                    "duration": 0.5 if duration_str == 'short' else 1.5,
                    "block_type": block_type,
                    "event_type": 'probe_duration_confidence',
                    "target_group": target_group,
                    "category": category,
                    "duration_str": duration_str,
                    "orientation": orientation,
                    "task_relevance": task_relevance,
                    "stim_id": stim_id,
                    "response_time": response_times_duration * 10**(-3),
                    "response": response_duration
                }, index=[0])], ignore_index=True)
            onset += 1 + response_times_duration * 10**(-3)
    # Add the probes order:
    events_tbl['probe_order'] = 'orientationFirst' if 'orientation' in trial['probeOrder'] else 'durationFirst'

    return events_tbl