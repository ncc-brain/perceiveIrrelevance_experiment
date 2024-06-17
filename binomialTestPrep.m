
% this script is preparing the critical trial and post-surprise data for binomial test 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

faceCritical = load("faceCritical.mat"); % load the critical and post data
facePost = load ('facePostSurprise.mat');

objectCritical = load('objectCritical.mat');
objectPost = load('objectPostSurprise.mat');


faceCriticalTrials = faceCritical.faceCriticalTrial; 
objectCriticalTrials = objectCritical.objectCriticalTrial;

facePostTrials = facePost.facePostSurpriseTrials;
objectPostTrials = objectPost.objectPostSurpriseTrials;

% performance in orientation & duration for faces 

correctOrientationFace = 0; % nr of correct orientation face
correctDurationFace = 0; % nr of correct duration for face
correctOrientationObject = 0; % nr of correct orientation object
correctDurationObject = 0; % nr of duration object 

%face critical trial accuracy tables

for i = 1:numel(faceCriticalTrials)

    currentCell = faceCriticalTrials{i}; 
    
    
    if currentCell.orientationPerformance == 1 % check total correct responses for orientation
        
        correctOrientationFace = correctOrientationFace + 1;
    end

    if currentCell.durationPerformance == 1

        correctDurationFace = correctDurationFace + 1;
    end
           

end

%object critical trial accuracy table 

for i = 1: numel(objectCriticalTrials)

    currentCell = objectCriticalTrials{i};

    if currentCell.orientationPerformance == 1

      correctOrientationObject = correctOrientationObject + 1;

    end

    if currentCell.durationPerformance == 1
        
        correctDurationObject = correctDurationObject +1;
    end

end

% nr of corrects for the critical 

TotalFaceProbes = 2*(numel(faceCriticalTrials));
TotalObjectProbes = 2*(numel(objectCriticalTrials));

TotalSpecificProbes = numel(faceCriticalTrials) + numel(objectCriticalTrials);

TotalProbes = TotalFaceProbes + TotalObjectProbes; % nr of orientation and duration are same 

TotalCorrectOrientation = correctOrientationFace + correctOrientationObject; % total correct orientation
TotalCorrectDuration = correctDurationFace + correctDurationObject; %total correct duration 

TotalCorrect = TotalCorrectOrientation + TotalCorrectDuration;

TotalCorrectFace = correctOrientationFace + correctDurationFace;
TotalCorrectObject = correctOrientationObject + correctDurationObject;

CriticalAccuracyTable = table(TotalFaceProbes,TotalObjectProbes,TotalSpecificProbes,TotalProbes,TotalCorrectOrientation,...
    TotalCorrectDuration,TotalCorrect,TotalCorrectFace,TotalCorrectObject,'VariableNames',{'NrFaceProbes','NrObjectProbes','Nr1IrrelevantProbe',...
    'NrAllirrelevantProbes','totalCorrectOrientation','totalCorrectDuration','TotalCorrectResponse','totalCorrectFace','totalCorrectObject'});


% accuracy table for face post surprise 

PostTotalcorrectOrientationFace = zeros(height(facePostTrials{1}), 1); % nr of correct orientation post face
PostTotalcorrectDurationFace = zeros(height(facePostTrials{1}),1); % nr of correct duration for post face

PostTotalcorrectOrientationObject = zeros(height(objectPostTrials{1}),1); % nr of correct orientation post object
PostTotalcorrectDurationObject = zeros(height(objectPostTrials{1}),1); % nr of duration post object 


for i = 1:numel(facePostTrials) % iterate through the face files 

    currentTrial = facePostTrials{i};
   

    for j = 1:height(currentTrial)

        postCorrectOrientationFace = 0;
        postCorrectDurationFace = 0;
       
         if currentTrial.orientationAccuracy(j) == 1
            
             postCorrectOrientationFace = 1;
            
         end

            PostTotalcorrectOrientationFace(j) = PostTotalcorrectOrientationFace(j) + postCorrectOrientationFace;

         if currentTrial.durationAccuracy(j) == 1
            
            postCorrectDurationFace = 1;
         end

            PostTotalcorrectDurationFace(j) =  PostTotalcorrectDurationFace(j) + postCorrectDurationFace;
    end

        
end


% accuracy table for object post surprise 

for i = 1:numel(objectPostTrials) % iterate through the face files 

    currentTrial = objectPostTrials{i};
   

    for j = 1:height(currentTrial)

        postCorrectOrientationObject = 0;
        postCorrectDurationObject = 0;
       
         if currentTrial.orientationAccuracy(j) == 1
            
             postCorrectOrientationObject = 1;
            
         end

            PostTotalcorrectOrientationObject(j) = PostTotalcorrectOrientationObject(j) + postCorrectOrientationObject;

         if currentTrial.durationAccuracy(j) == 1
            
            postCorrectDurationObject = 1;
         end

            PostTotalcorrectDurationObject(j) =  PostTotalcorrectDurationObject(j) + postCorrectDurationObject;
    end

        
end


TotalPostFaceProbes = repmat(2*(numel(facePostTrials)),4,1); % each post trial has orientation & duration and this number is for per trial

TotalPostObjectProbes = repmat(2*(numel(objectPostTrials)),4,1);

TotalPostSpecificProbes = repmat((numel(facePostTrials) + numel(objectPostTrials)),4,1); % nr of orientation OR duration probes 

TotalPostProbes = TotalPostFaceProbes + TotalPostObjectProbes;


TotalPostCorrectOrientation = PostTotalcorrectOrientationFace + PostTotalcorrectOrientationObject; % total correct orientation
TotalPostCorrectDuration = PostTotalcorrectDurationFace + PostTotalcorrectDurationObject; %total correct duration 

TotalPostCorrect = TotalPostCorrectOrientation + TotalPostCorrectDuration;

TotalPostCorrectFace = PostTotalcorrectOrientationFace + PostTotalcorrectDurationFace;
TotalPostCorrectObject = PostTotalcorrectOrientationObject + PostTotalcorrectDurationObject;

PostAccuracyTable = table(TotalPostFaceProbes,TotalPostObjectProbes,TotalPostSpecificProbes,TotalPostProbes,TotalPostCorrectOrientation,...
    TotalPostCorrectDuration,TotalPostCorrect,TotalPostCorrectFace,TotalPostCorrectObject,'VariableNames',{'NrFaceProbes','NrObjectProbes','Nr1IrrelevantProbe',...
    'NrAllirrelevantProbes','totalCorrectOrientation','totalCorrectDuration','TotalCorrectResponse','totalCorrectFace','totalCorrectObject'});


% save the tables 

CriticalAccuracyTableFile = 'criticalAccuracyTable.mat';
save(fullfile(processedDataIrrelevant,CriticalAccuracyTableFile),'CriticalAccuracyTable');

PostAccuracyTableFile = 'PostAccuracyTable.mat';
save(fullfile(processedDataIrrelevant,PostAccuracyTableFile),'PostAccuracyTable');


