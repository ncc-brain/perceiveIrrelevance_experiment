import re
import warnings
import json
from pathlib import Path
import pandas as pd
import numpy as np
from config import source_root


def get_subjects_list(directory, prefix='Sub'):
    # Compile a regex pattern to match folder names starting with the specified prefix
    pattern = re.compile(rf'^{prefix}')

    # List all directories in the given directory with the specified prefix
    subjects = [folder.name for folder in Path(directory).iterdir() if folder.is_dir() and pattern.match(folder.name)]
    
    return subjects


def get_category(stim_id):
    if 'face' in stim_id.lower():
        return 'face'
    else:
        return 'object'


def get_orientation(stim_id):
    # Extract orientation:
    if 'center' in stim_id.lower():
        return 'center'
    elif 'right' in stim_id.lower():
        return 'right'
    else:
        return 'left'
    

def get_task(stim_id):
    # Extract the task relevance:
    if 'nonTarget' in stim_id:
        return 'non-target' 
    else:
        return 'target'


def beh_cleanup(source_root, subject_id):

    warnings.simplefilter(action='ignore', category=FutureWarning)

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
        if any(keyword in trial['Task_Name'].lower() for keyword in ['consent', 'practice', 'end', 'calibration', 'introduction']):
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

        # Extract info:
        category = get_category(stim_id)
        orientation = get_orientation(stim_id)
        task_relevance = get_task(stim_id)
        # Extract the duration:
        if block_type != 'post-surprise':
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
            # Extract info
            category = get_category(stim_id)
            orientation = get_orientation(stim_id)
            task_relevance = 'target'
            duration_str = trial['stimulusDurationCritical']

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
            option_1 = get_orientation(trial['criticalOrientation1Stim'])
            option_2 = get_orientation(trial['criticalOrientation2Stim'])
            
            # Check the response participants gave:
            if target_group == 'Face':
                response_orientation = option_2 if pd.isna(trial['CBcriticalOrientation1']) or trial['CBcriticalOrientation1'] is False else option_1
            else:
                response_orientation = option_2 if pd.isna(trial['criticalOrientation1']) or trial['criticalOrientation1'] is False else option_1
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
            option_1 = get_orientation(trial['postOrientation1Stim'])
            option_2 = get_orientation(trial['postOrientation2Stim'])
            
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


def get_demo(source_root, subject_id):
        demo_tbl = pd.read_csv(Path(source_root, subject_id, 'sessions.csv'))
        # Extract age, gender and location:
        age = demo_tbl['SelectedAge'][0]
        gender = demo_tbl['SelectedGender'][0]

        return age, gender


def validate_sidecar(df, sidecar):
    """
    Validates that each column in the DataFrame has a corresponding entry in the sidecar dictionary.

    Parameters:
    - df: pandas DataFrame whose columns need to be validated.
    - sidecar: Dictionary representing the JSON sidecar.

    Returns:
    - missing_columns: List of columns in the DataFrame that do not have corresponding entries in the sidecar.
    """
    # Identify missing columns in the sidecar
    missing_columns = [col for col in df.columns if col not in sidecar]

    # Issue a warning if there are missing columns
    if missing_columns:
        warnings.warn(f"The following columns are missing in the JSON sidecar: {missing_columns}")
    
    return missing_columns


def dataframe2bids(df, bids_root, subject, task, data_type='beh', json_sidecar=None):
    """
    Saves a DataFrame to a BIDS-compatible folder structure.
    
    Parameters:
    - df: pandas DataFrame to be saved.
    - bids_root: Root path where BIDS data should be saved.
    - subject: Subject identifier (e.g., 'Sub101').
    - task: Task name to be included in the filename.
    - data_type: Type of data being saved, default is 'beh' (behavioral data).
    - json_sidecar: Optional path to a JSON file or dictionary to be used as the JSON sidecar.
    
    Returns:
    - Path to the saved TSV file.
    """
    # Ensure data_type is currently only 'beh'
    if data_type != 'beh':
        raise ValueError("Currently only 'beh' data type is supported.")
    
    # Define paths for subject folder, data type folder, and filename
    subject_dir = Path(bids_root) / subject / data_type
    subject_dir.mkdir(parents=True, exist_ok=True)  # Create directories as needed
    file_name = f"{subject}_task-{task}_events.tsv"
    file_path = subject_dir / file_name
    
    # Save the DataFrame to TSV format
    df.to_csv(file_path, sep='\t', index=False)

    # Handle JSON sidecar loading and validation
    if json_sidecar is None:
        warnings.warn("A JSON sidecar is recommended but was not provided.")
    else:
        if isinstance(json_sidecar, dict):
            sidecar_data = json_sidecar
        else:  # If a path is provided, load JSON file
            try:
                with open(json_sidecar, 'r') as f:
                    sidecar_data = json.load(f)
            except (FileNotFoundError, json.JSONDecodeError) as e:
                raise ValueError(f"Failed to load JSON sidecar: {e}")

        # Validate the JSON sidecar against DataFrame columns
        validate_sidecar(df, sidecar_data)
        
        # Save the JSON sidecar next to the TSV file
        json_path = file_path.with_suffix('.json')
        with open(json_path, 'w') as f:
            json.dump(sidecar_data, f, indent=4)
    
    return file_path


def exclusion_criterion(df, hit_thresh=0.8, fa_thresh=0.2):
    # Extract the pre-surprise trials:
    df_pre = df[df['block_type'] == 'pre-surprise']
    # Count the proportion of hits and FAs:
    hits = np.sum(df_pre['response'] == 'hit') / np.sum(df_pre['task_relevance'] == 'target')
    fa = np.sum(df_pre['response'] == 'fa') / np.sum(df_pre['task_relevance'] != 'target')
    
    # Check if the proportions meet the thresholds
    if hits < hit_thresh or fa > fa_thresh:
        return True
    else:
        return False


def count_trailing_zeros_after_decimal(number):
    # Convert the number to a string in scientific notation to handle small numbers properly
    str_num = f"{number:.10f}"
    
    # Remove any trailing zeros and split at the decimal
    decimal_part = str_num.split(".")[1]
    
    # Count leading zeros after the decimal point
    count = 0
    for char in decimal_part:
        if char == '0':
            count += 1
        else:
            break
    return count
