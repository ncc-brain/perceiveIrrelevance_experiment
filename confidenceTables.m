
% this script is for making tables for the confidence & accuracy relation

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataLab)
addpath(genpath(processedDataLab)); 

load("criticalConfidenceTable.mat");
load("postConfidenceTable.mat");

confidenceLevels = (1:5)';

% define the variables 

faceOrientationAccurate =[];
faceOrientationInaccurate =[];
PostfaceOrientationAccurate =[];
PostfaceOrientationInaccurate =[];

objectOrientationAccurate =[];
objectOrientationInaccurate =[];
PostobjectOrientationAccurate =[];
PostobjectOrientationInaccurate =[];

faceDurationAccurate = [];
faceDurationInaccurate = [];
PostfaceDurationAccurate = [];
PostfaceDurationInaccurate = [];

objectDurationAccurate = [];
objectDurationInaccurate = [];
PostobjectDurationAccurate = [];
PostobjectDurationInaccurate = [];

%face confidence counts for each feature

faceOrientationConfCount = [];
faceDurationConfCount =[];
facePostOrientationConfCount = [];
facePostDurationConfCount= [];

%object confidence counts for each feature 

objectOrientationConfCount = [];
objectDurationConfCount =[];
objectPostOrientationConfCount = [];
objectPostDurationConfCount=[];

%for each confidence level get the count 

for i = 1:5

    % get the critical data
    faceOrientationAccurate(i) = sum(criticalConfidence.faceOrientationConf == i & criticalConfidence.faceOrientationPerf == 1);
    faceOrientationInaccurate(i) = sum(criticalConfidence.faceOrientationConf == i & criticalConfidence.faceOrientationPerf == 0);
    faceOrientationConfCount(i) = faceOrientationAccurate(i) + faceOrientationInaccurate(i);
    faceOrientationAccuracy(i) = (faceOrientationAccurate(i) / faceOrientationConfCount(i)) * 100; 


    faceDurationAccurate(i)= sum(criticalConfidence.faceDurationConf == i & criticalConfidence.faceDurationPerf == 1);
    faceDurationInaccurate(i)= sum(criticalConfidence.faceDurationConf == i & criticalConfidence.faceDurationPerf == 0);
    faceDurationConfCount(i)= faceDurationAccurate(i) +  faceDurationInaccurate(i);
    faceDurationAccuracy(i) = (faceDurationAccurate(i) / faceDurationConfCount(i)) * 100;
    
    objectOrientationAccurate(i) = sum(criticalConfidence.objectOrientationConf == i & criticalConfidence.objectOrientationPerf == 1);
    objectOrientationInaccurate(i)= sum(criticalConfidence.objectOrientationConf == i & criticalConfidence.objectOrientationPerf == 0);
    objectOrientationConfCount(i)= objectOrientationAccurate(i)+ objectOrientationInaccurate(i);
    objectOrientationAccuracy(i) = (objectOrientationAccurate(i) / objectOrientationConfCount(i)) * 100;

    objectDurationAccurate(i)= sum(criticalConfidence.objectDurationConf == i & criticalConfidence.objectDurationPerf == 1);
    objectDurationInaccurate(i)= sum(criticalConfidence.objectDurationConf == i & criticalConfidence.objectDurationPerf == 0);
    objectDurationConfCount(i) =  objectDurationAccurate(i) + objectDurationInaccurate(i); 
    objectDurationAccuracy(i) = (objectDurationAccurate(i) / objectDurationConfCount(i)) * 100;

    % get the post data
    
    PostfaceOrientationAccurate(i) = sum(postConfidenceTable.postFaceOrientationConf == i & postConfidenceTable.postFaceOrientationPerf == 1);
    PostfaceOrientationInaccurate(i) = sum(postConfidenceTable.postFaceOrientationConf == i & postConfidenceTable.postFaceOrientationPerf == 0);
    facePostOrientationConfCount(i) = PostfaceOrientationAccurate(i) +  PostfaceOrientationInaccurate(i);
    PostfaceOrientationAccuracy(i) = (PostfaceOrientationAccurate(i) / facePostOrientationConfCount(i)) * 100;

    PostfaceDurationAccurate(i)= sum(postConfidenceTable.postFaceDurationConf == i & postConfidenceTable.postFaceDurationPerf == 1);
    PostfaceDurationInaccurate(i)= sum(postConfidenceTable.postFaceDurationConf == i & postConfidenceTable.postFaceDurationPerf == 0);
    facePostDurationConfCount(i)= PostfaceDurationAccurate(i)+ PostfaceDurationInaccurate(i);
    PostfaceDurationAccuracy(i) = (PostfaceDurationAccurate(i) / facePostDurationConfCount(i)) * 100;

    PostobjectOrientationAccurate(i) = sum(postConfidenceTable.postObjectOrientationConf == i & postConfidenceTable.postObjectOrientationPerf==1);
    PostobjectOrientationInaccurate(i)= sum(postConfidenceTable.postObjectOrientationConf == i & postConfidenceTable.postObjectOrientationPerf==0);
    objectPostOrientationConfCount(i)= PostobjectOrientationAccurate(i) + PostobjectOrientationInaccurate(i); 
    PostobjectOrientationAccuracy(i) = (PostobjectOrientationAccurate(i) / objectPostOrientationConfCount(i)) * 100;

    PostobjectDurationAccurate(i)= sum(postConfidenceTable.postObjectDurationConf == i & postConfidenceTable.postObjectDurationPerf == 1);
    PostobjectDurationInaccurate(i)= sum(postConfidenceTable.postObjectDurationConf == i & postConfidenceTable.postObjectDurationPerf == 0);
    objectPostDurationConfCount(i)= PostobjectDurationAccurate(i)+ PostobjectDurationInaccurate(i);
    PostobjectDurationAccuracy(i) = (PostobjectDurationAccurate(i) / objectPostDurationConfCount(i)) * 100;

end



%%
% critical confidence tables

criticalConfidenceTable = table(confidenceLevels, faceOrientationAccuracy', objectOrientationAccuracy',faceOrientationConfCount',objectOrientationConfCount',...
    faceDurationAccuracy',objectDurationAccuracy',faceDurationConfCount',objectDurationConfCount','VariableNames',{'Confidence Rating','Face Accurate Orientation','Object Accurate Orientation',...
    'Face Orientation Confidence Count','Object Orientation Confidence Counts','Face Accurate Duration','Object Accurate Duration','Face Duration Confidence Count','Object Duration Confidence Count'});
%save table as excel format 

criticalExcelFile = 'criticalConfidenceTable.xlsx';

filePath = fullfile(processedDataLab, criticalExcelFile);

writetable(criticalConfidenceTable,filePath);

%%
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

