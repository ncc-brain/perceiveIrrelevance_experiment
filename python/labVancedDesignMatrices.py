import numpy as np
import pandas as pd
import itertools
import math
import re

# ======================================================================================================
# Set parameters:
nsubjects = 320
nPostSurprise = 4
categories = ['Face', 'Object']
orientations = ['Center', 'Left', 'Right']
durations = ["short", "long"]
tasks = ['nonTarget', 'Target']
probes_order = ['OrientationFirst', 'DurationFirst']
correct_probe_side = ["left", "right"]
nNonTarget = 18
nTarget = 2

# ======================================================================================================
# Create stimuli File Names
stimuliFiles = pd.DataFrame()
for task in tasks:
    for cate in categories:
        for ori in orientations:
            nstim = nNonTarget if task == 'nonTarget' else nTarget
            stimuliFiles = pd.concat([stimuliFiles, 
                                      pd.DataFrame({
                                          'category': [cate] * nstim,
                                          'orientation': [ori] * nstim,
                                          'task': [task] * nstim,
                                          'stimulusFile': [f'{task}{cate}{i+1}{ori}.png' for i in range(nstim)]
                                      })], ignore_index=True)
# Define the mapping of the stimuli ID:
mapping = stimuliFiles.reset_index().set_index('stimulusFile')['index'].to_dict()

# ======================================================================================================
# Create counter balancing data frame:
# Create all combinations
combinations = list(itertools.product(
    categories,
    categories,
    probes_order,
    categories,
    durations,
    correct_probe_side
))
# Convert to data frame:
columns = ['targetCategory', 'surpriseCategory', 'probeOrder', 'firstPostCategory', 'surpriseDuration', 'correctProbeSide']
counter_balance_df = pd.DataFrame(combinations, columns=columns)
# Repeat to make sure we have enough based on the number of subjects:
counter_balance_df = pd.DataFrame(np.repeat(counter_balance_df.to_numpy(), math.ceil(nsubjects/counter_balance_df.shape[0]), axis=0), 
                                  columns=counter_balance_df.columns)
    
# ======================================================================================================
# Loop through each subjects
subjectsDesigns = []

# Loop through each subject
for sub in range(nsubjects):
    # Extract the counter balancing info for that subject:
    subject_info = counter_balance_df.loc[sub]

    # ======================================================================================================
    # Presurprise trials
    presurprise_design = pd.DataFrame()
    presurprise_design = pd.concat([presurprise_design, 
                                    stimuliFiles[(stimuliFiles["category"] == subject_info["targetCategory"]) & 
                                                    (stimuliFiles["task"] == 'Target')]], ignore_index=True)
    # Add randomized durations:
    target_durations = durations * 3
    np.random.shuffle(target_durations)
    presurprise_design["duration"] = target_durations
    presurprise_design['trialType'] = 'presurprise'
    presurprise_design['targetCate'] = subject_info["targetCategory"]
    presurprise_design['probeOrder'] = subject_info["probeOrder"]
    presurprise_design['firstPostCategory'] = subject_info["firstPostCategory"]
    presurprise_design['correctProbeLocation'] = subject_info["correctProbeSide"]

    # Create and shuffle faces and objects identities
    nonTargetFaceID = [i+1 for i in range(nNonTarget)]
    np.random.shuffle(nonTargetFaceID)
    nonTargetObjectID = [i+1 for i in range(nNonTarget)]
    np.random.shuffle(nonTargetObjectID)
    ctr_Face = 0
    ctr_Object = 0
    for ori in orientations:
        presurprise_design = pd.concat([
            presurprise_design,
            pd.DataFrame({
                'trialType': ['presurprise'] * 6,
                'targetCate': [subject_info["targetCategory"]] * 6,
                'probeOrder': [subject_info["probeOrder"]] * 6,
                'firstPostCategory': [subject_info["firstPostCategory"]] * 6,
                'correctProbeLocation': [subject_info['correctProbeSide']] * 6,
                'category': ['Face'] * 6,
                'duration': durations * 3,
                'orientation': [ori] * 6,
                'task': 'nonTarget',
                'stimulusFile':  [f'nonTargetFace{i}{ori}.png' for i in nonTargetFaceID[ctr_Face:ctr_Face + 6]],
                'orientationProbeLeftFile': [None] * 6,
                'orientationProbeRightFile': [None] * 6,
                })
                ], ignore_index=True)
        presurprise_design = pd.concat([
            presurprise_design,
            pd.DataFrame({
                'trialType': ['presurprise'] * 6,
                'targetCate': [subject_info["targetCategory"]] * 6,
                'probeOrder': [subject_info["probeOrder"]] * 6,
                'firstPostCategory': [subject_info["firstPostCategory"]] * 6,
                'correctProbeLocation': [subject_info['correctProbeSide']] * 6,
                'category': ['Object'] * 6,
                'duration': durations * 3,
                'orientation': [ori] * 6,
                'task': 'nonTarget',
                'stimulusFile':  [f'nonTargetObject{i}{ori}.png' for i in nonTargetObjectID[ctr_Object:ctr_Object + 6]],
                'orientationProbeLeftFile': [None] * 6,
                'orientationProbeRightFile': [None] * 6,
                })
                ], ignore_index=True)
        ctr_Face += 6
        ctr_Object += 6
    # Shuffle the order:
    presurprise_design = presurprise_design.reindex(np.random.permutation(presurprise_design.index))

    # ======================================================================================================
    # Surprise trials
    identities_pool = [i + 1 for i in range(18)]
    surprise_design = pd.DataFrame()

    # Randomly pick one identitiy
    id_ind = int(np.random.choice(len(identities_pool), 1)[0])
    surprise_identity = identities_pool[id_ind-1]
    del identities_pool[id_ind-1]

    # Assemble in the table
    if subject_info['correctProbeSide'] == 'left':           
        surprise_design = pd.concat([
            surprise_design,
            pd.DataFrame({
                'trialType': 'surprise',
                'targetCate': subject_info["targetCategory"],
                'probeOrder': subject_info["probeOrder"],
                'firstPostCategory': subject_info["firstPostCategory"],
                'correctProbeLocation': subject_info['correctProbeSide'],
                'category': subject_info['surpriseCategory'],
                'duration': subject_info['surpriseDuration'],
                'orientation': None,
                'task': 'nonTarget',
                'stimulusFile': f'nonTarget{subject_info['surpriseCategory']}{surprise_identity}{ori}.png',
                'orientationProbeLeftFile': f'nonTarget{subject_info['surpriseCategory']}{surprise_identity}{ori}.png',
                'orientationProbeRightFile': f'nonTarget{subject_info['surpriseCategory']}{surprise_identity}{str(np.random.choice([ori2 for ori2 in orientations if ori2 != ori], 1)[0])}.png',
                }, index=[0])
                ], ignore_index=True)

    else:
        surprise_design = pd.concat([
            surprise_design,
                pd.DataFrame({  
                'trialType': 'surprise',
                'targetCate': subject_info["targetCategory"],
                'probeOrder': subject_info["probeOrder"],
                'firstPostCategory': subject_info["firstPostCategory"],
                'correctProbeLocation': subject_info['correctProbeSide'],
                'category': subject_info['surpriseCategory'],
                'duration': subject_info['surpriseDuration'],
                'orientation': None,
                'task': 'nonTarget',
                'stimulusFile': f'nonTarget{subject_info['surpriseCategory']}{surprise_identity}{ori}.png',
                'orientationProbeLeftFile': f'nonTarget{subject_info['surpriseCategory']}{surprise_identity}{str(np.random.choice([ori2 for ori2 in orientations if ori2 != ori], 1)[0])}.png',
                'orientationProbeRightFile': f'nonTarget{subject_info['surpriseCategory']}{surprise_identity}{ori}.png',
                }, index=[0])
                ], ignore_index=True)


    # ======================================================================================================
    # Postsurprise trials
    if subject_info["firstPostCategory"] == 'Face':
        postSurpriseSequence = ["Face", "Object", "Face", "Object"]
    else:
        postSurpriseSequence = ["Object", "Face", "Object", "Face"]
    
    for cate in postSurpriseSequence:

        # Randomly select an identity:
        id_ind = int(np.random.choice(len(identities_pool), 1)[0])
        id = identities_pool[id_ind]
        del identities_pool[id_ind]
        # Randomly select two orientations:
        ori1 = str(np.random.choice(orientations, 1)[0])
        ori2 = str(np.random.choice([ori2 for ori2 in orientations if ori2 != ori1], 1)[0])
        # Add to the table:
        if np.random.choice(2, 1) == 0:
            surprise_design = pd.concat([
            surprise_design,
                pd.DataFrame({
                    'trialType': 'postsurprise',
                    'targetCate': subject_info["targetCategory"],
                    'probeOrder': subject_info["probeOrder"],
                    'firstPostCategory': subject_info["firstPostCategory"],
                    'correctProbeLocation': subject_info['correctProbeSide'],
                    'category': cate,
                    'duration': durations[np.random.choice(2, 1)[0]],
                    'orientation': ori1,
                    'task': 'nonTarget',
                    'stimulusFile': f'nonTarget{cate}{id}{ori1}.png',
                    'orientationProbeLeftFile': f'nonTarget{cate}{id}{ori1}.png',
                    'orientationProbeRightFile': f'nonTarget{cate}{id}{ori2}.png',
                    }, index=[0])
                ], ignore_index=True)
        else:
            surprise_design = pd.concat([
            surprise_design,
                pd.DataFrame({
                    'trialType': 'postsurprise',
                    'targetCate': subject_info["targetCategory"],
                    'probeOrder': subject_info["probeOrder"],
                    'firstPostCategory': subject_info["firstPostCategory"],
                    'correctProbeLocation': subject_info['correctProbeSide'],
                    'category': cate,
                    'duration': durations[np.random.choice(2, 1)[0]],
                    'orientation': ori1,
                    'task': 'nonTarget',
                    'stimulusFile': f'nonTarget{cate}{id}{ori1}.png',
                    'orientationProbeLeftFile': f'nonTarget{cate}{id}{ori2}.png',
                    'orientationProbeRightFile': f'nonTarget{cate}{id}{ori1}.png',
                    }, index=[0])
                ], ignore_index=True)

    # ======================================================================================================
    # Concatenate all:
    subjectDesign = pd.concat([presurprise_design, surprise_design], ignore_index=True)
    subjectDesign["subjectID"] = sub
    subjectDesign['stimIndex'] = subjectDesign['stimulusFile'].map(mapping) + 1
    subjectDesign['probeLeftIndex'] = subjectDesign['orientationProbeLeftFile'].map(mapping) + 1
    subjectDesign['probeRightIndex'] = subjectDesign['orientationProbeRightFile'].map(mapping) + 1
    subjectsDesigns.append(subjectDesign)

# Combine all into one super matrix:
subjectsDesigns = pd.concat(subjectsDesigns).reset_index(drop=True)

# Calculate the total number of conditions we equate across:
ncond = len(categories) * len(categories) * len(probes_order) * len(categories) * len(durations) * len(correct_probe_side)
nrepeats = nsubjects / ncond
nperori = math.floor(nrepeats / len(orientations))
nremain = int(nrepeats % len(orientations))

# Counter balancing the oriention the best we can:
for target_cate in subjectsDesigns["targetCate"].unique():
    for surprise_cate in subjectsDesigns["category"].unique():
        for probe_order in probes_order:
            for post_cate in subjectsDesigns["firstPostCategory"].unique():
                for dur in subjectsDesigns["duration"].unique():
                    for probeLoc in subjectsDesigns["correctProbeLocation"].unique():
                        # Generate a set of orientation that ensures that each orientation occurs in each condition at least once:
                        oris = orientations.copy() * nperori + list(np.random.choice(orientations, size=nremain, replace=False))
                        np.random.shuffle(oris)

                        # Find all the index of all trials matching that particular condition:
                        cond_inds = subjectsDesigns[
                            (subjectsDesigns["targetCate"] == target_cate) &
                            (subjectsDesigns["category"] == surprise_cate) &
                            (subjectsDesigns["probeOrder"] == probe_order) &
                            (subjectsDesigns["firstPostCategory"] == post_cate) &
                            (subjectsDesigns["duration"] == dur) &
                            (subjectsDesigns["correctProbeLocation"] == probeLoc) & 
                            (subjectsDesigns["trialType"] == "surprise")].index
                        
                        # Assign the orientation to each condition: 
                        for idx, ori in zip(cond_inds, oris):
                            # Replace orientation of the stimulus file:
                            subjectsDesigns.at[idx, 'stimulusFile'] = re.sub(r'(Center|Left|Right)', 
                                                                                ori, 
                                                                                subjectsDesigns.at[idx, 'stimulusFile']
                                                                            )


                            if subjectsDesigns.at[idx, 'correctProbeLocation'] == 'left':
                                subjectsDesigns.at[idx, 'orientationProbeLeftFile'] = subjectsDesigns.at[idx, 'stimulusFile']
                                subjectsDesigns.at[idx, 'orientationProbeRightFile'] = re.sub(r'(Center|Left|Right)', 
                                                                                np.random.choice([v for v in orientations if v != ori], 1)[0], 
                                                                                subjectsDesigns.at[idx, 'stimulusFile']
                                                                            )
                            
                            else:
                                subjectsDesigns.at[idx, 'orientationProbeRightFile'] = subjectsDesigns.at[idx, 'stimulusFile']
                                subjectsDesigns.at[idx, 'orientationProbeLeftFile'] = re.sub(r'(Center|Left|Right)', 
                                                                                np.random.choice([v for v in orientations if v != ori], 1)[0], 
                                                                                subjectsDesigns.at[idx, 'stimulusFile']
                                                                            )
                            subjectsDesigns.at[idx, 'orientation'] = ori


subjectsDesigns.to_csv("DesignMatrix.csv",  index=False)

# Save a condensed version:
subjectsDesigns[["targetCate", "trialType", "stimIndex", "duration", "probeLeftIndex", "probeRightIndex", "probeOrder"]].to_csv("DesignMatixReduced.csv", index=False)

# Save the stimuli matrix:
stimuliFiles[["stimulusFile"]].to_csv("Stimuli.csv",  index=False)

# Count occurrences of each unique combination for the surprise trial:
surpriseTrials = subjectsDesigns[subjectsDesigns["trialType"] == "surprise"]
condition_counts = surpriseTrials.groupby(["targetCate", "category", "probeOrder", "firstPostCategory", "duration", "correctProbeLocation", "trialType"]).size().reset_index(name='count')

print(condition_counts)


# Generate practice trials matrix:
# 14 trials total, 2 targets, 6 task congruent, 6 task incongruent, orientations and durations are picked at random
# ======================================================================================================
# Loop through each subjects
praticeDesigns = []

# ==========================================
# Create stimuli File Names
stimuliFiles = pd.DataFrame()
for task in tasks:
    for cate in categories:
        for ori in orientations:
            nstim = nNonTarget if task == 'nonTarget' else nTarget
            if task == 'Target':
                tsk = 'target'
            else:
                tsk = task
            stimuliFiles = pd.concat([stimuliFiles, 
                                      pd.DataFrame({
                                          'category': [cate] * nstim,
                                          'orientation': [ori] * nstim,
                                          'task': [task] * nstim,
                                          'stimulusFile': [f'{tsk}{cate}{i+1}{ori}-Practice.png' for i in range(nstim)]
                                      })], ignore_index=True)
# Define the mapping of the stimuli ID:
mapping = stimuliFiles.reset_index().set_index('stimulusFile')['index'].to_dict()

# Loop through each subject
for sub in range(nsubjects):
    print(sub)
    # Extract the counter balancing info for that subject:
    subject_info = counter_balance_df.loc[sub]

    # ================================================
    # Target trials:
    # Pick two random orientations and durations:
    oris = np.random.choice(orientations, 2)
    dur = np.random.choice(durations, 2)
    subject_mat = pd.DataFrame({
        'targetCate': [subject_info["targetCategory"]] * 2,
        'category': [subject_info["targetCategory"]] * 2,
        'duration': dur,
        'orientation': oris,
        'task': ['Target'] * 2,
        'stimulusFile':  [f'target{subject_info["targetCategory"]}{i+1}{ori}-Practice.png' for i, ori in enumerate(oris)]
    })
    # ================================================
    # Task congruent trials:
    # Pick two random orientations and durations:
    oris = np.random.choice(orientations, 6)
    dur = np.random.choice(durations, 6)
    # Get random stimuli:
    stimuli = []
    stimuli_pool = stimuliFiles[(stimuliFiles['category'] == subject_info["targetCategory"]) & (stimuliFiles['task'] == 'nonTarget')]['stimulusFile'].to_list()
    for ori in oris:
        # Extract only the stimuli of the right orientation:
        candidate_stim = [stim for stim in stimuli_pool if ori in stim]
        stimuli.append(np.random.choice(candidate_stim, 1)[0])
        stimuli_pool = [stim for stim in stimuli_pool if stim != stimuli[-1]]
    subject_mat = pd.concat([subject_mat, 
        pd.DataFrame({
        'targetCate': [subject_info["targetCategory"]] * 6,
        'category': [subject_info["targetCategory"]] * 6,
        'duration': dur,
        'orientation': oris,
        'task': ['nonTarget'] * 6,
        'stimulusFile':  stimuli
    })], ignore_index=True)
    # ================================================
    # Task incongruent trials:
    # Pick two random orientations and durations:
    oris = np.random.choice(orientations, 6)
    dur = np.random.choice(durations, 6)
    cate = [cate for cate in categories if cate != subject_info["targetCategory"]][0]
    # Get random stimuli:
    stimuli = []
    stimuli_pool = stimuliFiles[(stimuliFiles['category'] == cate) & (stimuliFiles['task'] == 'nonTarget')]['stimulusFile'].to_list()
    for ori in oris:
        # Extract only the stimuli of the right orientation:
        candidate_stim = [stim for stim in stimuli_pool if ori in stim]
        stimuli.append(np.random.choice(candidate_stim, 1)[0])
        stimuli_pool = [stim for stim in stimuli_pool if stim != stimuli[-1]]
    subject_mat = pd.concat([subject_mat, pd.DataFrame({
        'targetCate': [subject_info["targetCategory"]] * 6,
        'category': [cate] * 6,
        'duration': dur,
        'orientation': oris,
        'task': ['nonTarget'] * 6,
        'stimulusFile':  stimuli
    })], ignore_index=True)

    # Shuffle the order:
    subject_mat = subject_mat.reindex(np.random.permutation(subject_mat.index))
    subject_mat["subjectID"] = sub
    subject_mat['stimIndex'] = subject_mat['stimulusFile'].map(mapping) + 1

    # Append to the rest:
    praticeDesigns.append(subject_mat)

# Combine all into one super matrix:
praticeDesigns = pd.concat(praticeDesigns).reset_index(drop=True)
# Save to file:
praticeDesigns.to_csv("PracticeDesign.csv",  index=False)

# Save the stimuli matrix:
stimuliFiles[["stimulusFile"]].to_csv("PracticeStimuli.csv",  index=False)
