import re
import warnings
import json
from pathlib import Path
import pandas as pd
import numpy as np
from config import source_root
import os


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


def beh_cleanup(log_table):

    warnings.simplefilter(action='ignore', category=FutureWarning)
    # Load the log file:
    if log_table['Trial_Nr'].max() < 47 or len([stim for stim in log_table[log_table['Task_Name'] == "main"]["StimID"].to_list() if 'nonTarget' not in stim]) == 0:
        return None
    # Load the design matrix:
    design_matrix = pd.read_csv('DesignMatrix.csv', sep=',')
    # Prepare clean up table:
    events_tbl = pd.DataFrame(columns=["onset", "duration", "block_type", "event_type", "target_group", "category", 
                                       "duration_str", "orientation", "task_relevance", "stim_id", "response_time", 
                                       "response"])  
    
    
    # Extract subject general info:
    target_group = 'Object' if 'Object' in [stim for stim in log_table[log_table['Task_Name'] == "main"]["StimID"].to_list() if 'nonTarget' not in stim][0] else 'Face'
    # Sort the rows:
    log_table = log_table.sort_values(by=['Task_Nr', 'Trial_Nr']).reset_index(drop=True)
    probe_oder = design_matrix.at[log_table["trialIndex"].to_list()[-2], "probeOrder"]
    # Get the surprise cate:
    surprise_cate = get_category(log_table[log_table['Trial_Nr'] == 43]['StimID'].values[0])
    # Loop through each trial:
    for trial_i, trial in log_table.iterrows():
        # Extract the block type:
        if trial['Task_Name'].lower() != 'main':
            continue 
        elif trial['Trial_Nr'] == 43:
            block_type = 'surprise'
        elif trial['Trial_Nr'] < 43:
            block_type = 'pre-surprise'
        else:
            block_type = 'post-surprise'

        # Extract stimulus ID:
        stim_id = trial['StimID']
        # Extract info:
        category = get_category(stim_id)
        orientation = get_orientation(stim_id)
        task_relevance = get_task(stim_id)
        duration_str = trial['StimDuration']

        # Response:
        if trial['ResponseMain'] == False:  # Check if Nan
            response_time = np.nan
            response = np.nan
        else:
            response_time = trial['RTMain'] - trial['stimOnset']
            response = 'hit' if task_relevance == 'target' else 'fa'
        # Add info to the table:
        events_tbl = pd.concat([events_tbl, pd.DataFrame({
            "onset": trial['stimOnset'],
            "duration": 0.5 if duration_str == 'short' else 1.5,
            "block_type": block_type if block_type != 'surprise' else 'pre-surprise',
            "event_type": 'stimulus',
            "target_group": target_group,
            "category": category,
            "duration_str": duration_str,
            "orientation": orientation,
            "task_relevance": task_relevance,
            "surprise_category": surprise_cate,
            "surprise_congruency": 'congruent' if surprise_cate.lower() == target_group.lower() else 'incongruent',
            "probe_order": probe_oder,
            "stim_id": stim_id,
            "response_time": response_time,
            "response": response
        }, index=[0])], ignore_index=True)

    return events_tbl


def get_demo(session_info):
        subject_num = session_info['Subject_Nr'].values[0]
        prolific_id = session_info['Crowdsourcing_SubjId'].to_list()[0]
        demographic_file = [val for val in os.listdir(source_root) if 'prolific_demographic' in val][0]
        demo_tbl = pd.read_csv(Path(source_root, demographic_file))

        # Extract age, gender and location:
        try:
            age = demo_tbl[demo_tbl['Participant id'] == prolific_id]['Age'].values[0]
            sex = demo_tbl[demo_tbl['Participant id'] == prolific_id]['Sex'].values[0]
        except:
            return None, None, None, None
        

        return age, sex, subject_num, prolific_id


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


def dataframe2bids(df, bids_root, subject, task, data_type='beh', json_sidecar=None, verbose=False):
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
    subject_dir = Path(bids_root,'sub-' + str(subject), data_type)
    subject_dir.mkdir(parents=True, exist_ok=True)  # Create directories as needed
    file_name = f"sub-{subject}_task-{task}_events.tsv"
    file_path = subject_dir / file_name
    
    # Save the DataFrame to TSV format
    df.to_csv(file_path, sep='\t', index=False)

    # Handle JSON sidecar loading and validation
    if json_sidecar is None:
        if verbose:
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
    # Check max trial number:
    trial_N = df.shape[0]
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
