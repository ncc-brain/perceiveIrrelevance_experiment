import pandas as pd

# Read data:
subjects_design = pd.read_csv("DesignMatrix.csv", sep=',')
within_subjects_counterbalancing_nonTarget = subjects_design[(subjects_design["trialType"] == "presurprise") & (subjects_design["task"] == "nonTarget")].groupby(['subjectID', 'task', 'category', 'orientation', 'duration']).size().reset_index(name='counts')
within_subjects_counterbalancing_Target = subjects_design[(subjects_design["trialType"] == "presurprise") & (subjects_design["task"] == "Target")].groupby(['subjectID', 'task', 'category', 'orientation', 'duration', 'stimulusFile']).size().reset_index(name='counts')
surprise_balance = subjects_design[(subjects_design["trialType"] == "surprise")].groupby(['category', 'duration', 'probeOrder', 'firstPostCategory', 'correctProbeLocation']).size().reset_index(name='counts')
post_surprise_balance = subjects_design[(subjects_design["trialType"] == "postsurprise")].groupby(['category', 'probeOrder', 'firstPostCategory', 'correctProbeLocation']).size().reset_index(name='counts')

surprise_balance = subjects_design[(subjects_design["trialType"] == "surprise")].groupby(['category', 'stimulusFile']).size().reset_index(name='counts')

print('A')
