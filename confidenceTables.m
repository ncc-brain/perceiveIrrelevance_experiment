
% this script is for making tables for the confidence & accuracy relation

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataOnline)
addpath(genpath(processedDataOnline)); 

load("criticalConfidenceTable.mat");
load("postConfidenceTable.mat");

confidenceLevels = (1:5)';

faceOrientationAccurate =[];
faceOrientationInaccurate =[];

faceDurationAccurate = [];
faceDurationInaccurate = [];

%for each confidence level get the count 

for i = 1:5

    % get the critical data
    faceOrientationAccurate(i) = sum(criticalConfidence.faceOrientationConf == i & criticalConfidence.faceOrientationPerf == 1);
    faceOrientationInaccurate(i) = sum(criticalConfidence.faceOrientationConf == i & criticalConfidence.faceOrientationPerf == 0);

    faceDurationAccurate(i)= sum(criticalConfidence.faceDurationConf == i & criticalConfidence.faceDurationPerf == 1);
    faceDurationInaccurate(i)= sum(criticalConfidence.faceDurationConf == i & criticalConfidence.faceDurationPerf == 0);

    objectOrientationAccurate(i) = sum(criticalConfidence.objectOrientationConf == i & criticalConfidence.objectOrientationPerf == 1);
    objectOrientationInaccurate(i)= sum(criticalConfidence.objectOrientationConf == i & criticalConfidence.objectOrientationPerf == 0);

    objectDurationAccurate(i)= sum(criticalConfidence.objectDurationConf == i & criticalConfidence.objectDurationPerf == 1);
    objectDurationInaccurate(i)= sum(criticalConfidence.objectDurationConf == i & criticalConfidence.objectDurationPerf == 0);

    % get the post data
    
    PostfaceOrientationAccurate(i) = sum(postConfidenceTable.postFaceOrientationConf == i & postConfidenceTable.postFaceOrientationPerf == 1);
    PostfaceOrientationInaccurate(i) = sum(postConfidenceTable.postFaceOrientationConf == i & postConfidenceTable.postFaceOrientationPerf == 0);

    PostfaceDurationAccurate(i)= sum(postConfidenceTable.postFaceDurationConf == i & postConfidenceTable.postFaceDurationPerf == 1);
    PostfaceDurationInaccurate(i)= sum(postConfidenceTable.postFaceDurationConf == i & postConfidenceTable.postFaceDurationPerf == 0);

    PostobjectOrientationAccurate(i) = sum(postConfidenceTable.postObjectOrientationConf == i & postConfidenceTable.postObjectOrientationPerf==1);
    PostobjectOrientationInaccurate(i)= sum(postConfidenceTable.postObjectOrientationConf == i & postConfidenceTable.postObjectOrientationPerf==0);

    PostobjectDurationAccurate(i)= sum(postConfidenceTable.postObjectDurationConf == i & postConfidenceTable.postObjectDurationPerf == 1);
    PostobjectDurationInaccurate(i)= sum(postConfidenceTable.postObjectDurationConf == i & postConfidenceTable.postObjectDurationPerf == 0);


end
%%
% face confidence tables

faceConfidenceTable = table(confidenceLevels, faceOrientationAccurate', faceOrientationInaccurate', faceDurationAccurate', faceDurationInaccurate', ...
    'VariableNames', {'Confidence Score', 'Orientation Accurate', 'Orientation Inaccurate', 'Duration Accurate', 'Duration Inaccurate'});

postFaceConfidenceTable = table(confidenceLevels, PostfaceOrientationAccurate', PostfaceOrientationInaccurate', PostfaceDurationAccurate', PostfaceDurationInaccurate', ...
    'VariableNames', {'Confidence Score', 'Orientation Accurate', 'Orientation Inaccurate', 'Duration Accurate', 'Duration Inaccurate'});


%object confidence tables
objectConfidenceTable = table(confidenceLevels, objectOrientationAccurate', objectOrientationInaccurate', objectDurationAccurate', objectDurationInaccurate', ...
    'VariableNames', {'Confidence Score', 'Orientation Accurate', 'Orientation Inaccurate', 'Duration Accurate', 'Duration Inaccurate'});


postObjectConfidenceTable = table(confidenceLevels, PostobjectOrientationAccurate', PostobjectOrientationInaccurate', PostobjectDurationAccurate', PostobjectDurationInaccurate', ...
    'VariableNames', {'Confidence Score', 'Orientation Accurate', 'Orientation Inaccurate', 'Duration Accurate', 'Duration Inaccurate'});



%face figure 
figure('Name', 'Face Confidence and Accuracy', 'Position', [100, 100, 1000, 300]); % Position [left, bottom, width, height]
uitable('Data', faceConfidenceTable{:,:}, 'ColumnName', faceConfidenceTable.Properties.VariableNames, ...
    'RowName', [], 'Units', 'normalized', 'Position', [0, 0, 1, 1]); % Adjust the size to fit the figure

%post face figure

figure('Name', 'Post Face Confidence and Accuracy', 'Position', [100, 100, 1000, 300]); % Position [left, bottom, width, height]
uitable('Data', postFaceConfidenceTable{:,:}, 'ColumnName', postFaceConfidenceTable.Properties.VariableNames, ...
    'RowName', [], 'Units', 'normalized', 'Position', [0, 0, 1, 1]); % Adjust the size to fit the figure

%object figure 
figure('Name', 'Object Confidence and Accuracy', 'Position', [100, 100, 1000, 300]); % Position [left, bottom, width, height]
uitable('Data', objectConfidenceTable{:,:}, 'ColumnName', objectConfidenceTable.Properties.VariableNames, ...
    'RowName', [], 'Units', 'normalized', 'Position', [0, 0, 1, 1]); % Adjust the size to fit the figure

%post object figure 

figure('Name', 'Post Object Confidence and Accuracy', 'Position', [100, 100, 1000, 300]); % Position [left, bottom, width, height]
uitable('Data', postObjectConfidenceTable{:,:}, 'ColumnName', postObjectConfidenceTable.Properties.VariableNames, ...
    'RowName', [], 'Units', 'normalized', 'Position', [0, 0, 1, 1]); % Adjust the size to fit the figure

