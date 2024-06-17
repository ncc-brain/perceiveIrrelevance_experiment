

% this script is preparing the critical trial and post-surprise data for binomial test. 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

faceCritical = load("faceCritical.mat"); % load the critical and post data
facePost = load ('facePostSurprise.mat');

objectCritical = load('objectCritical.mat');
objectPost = load('ob')


faceCriticalTrials = faceCritical.faceCriticalTrial; 
objectCriticalTrials = objectCritical.objectCriticalTrial;

% performance in orientation & duration for faces 

correctOrientationFace = 0; % nr of correct orientation face
correctDurationFace = 0; % nr of correct duration for face
correctOrientationObject = 0; % nr of correct orientation object
correctDurationObject = 0; % nr of duration object 

for i = 1:numel(faceCriticalTrials)

    currentCell = faceCriticalTrials{i}; 
    
    
    if currentCell.orientationPerformance == 1 % check total correct responses for orientation
        
        correctOrientationFace = correctOrientationFace + 1;
    end

    if currentCell.durationPerformance == 1

        correctDurationFace = correctDurationFace + 1;
    end
           

end


for i = 1: numel(objectCriticalTrials)

    currentCell = objectCriticalTrials{i};

    if currentCell.orientationPerformance == 1

      correctOrientationObject = correctOrientationObject + 1;

    end

    if currentCell.durationPerformance == 1
        
        correctDurationObject = correctDurationObject +1;
    end

end

TotalFaceProbes = 2*(numel(faceCriticalTrials));
TotalObjectProbes = 2*(numel(objectCriticalTrials));
TotalSpecificProbes = numel(faceCriticalTrials) + numel(objectCriticalTrials);

TotalProbes = TotalFaceProbes + TotalObjectProbes; % nr of orientation and duration are same 

TotalCorrectOrientation = correctOrientationFace + correctOrientationObject; % total correct orientation
TotalCorrectDuration = correctDurationFace + correctDurationObject; %total correct duration 

TotalCorrect = TotalCorrectOrientation + TotalCorrectDuration;

TotalCorrectFace = correctOrientationFace + correctDurationFace;
TotalCorrectObject = correctOrientationObject + correctDurationObject;


% binomial test 

% proportion of success (%binofit --> to infer variability and reliability
% [through confidence ratings] of the data. 

proportionOfSuccess = TotalCorrect / TotalProbes; % phat calculates this anyway 

% confidence interval (95%) 

alpha = 0.05;

% intervals for binomial proportion 

[phat, pci] = binofit(TotalCorrect,TotalProbes , alpha);

% phat: estimated proportion of succeses
% pci : confidence intervals 

successProbAll = table([phat; pci(1); pci(2)], 'VariableNames', {'All'}, 'RowNames', {'phat', 'LowerBound', 'UpperBound'});

[phat,pci] = binofit(TotalCorrectFace,TotalFaceProbes , alpha); 

successFace = table([phat; pci(1); pci(2)], 'VariableNames', {'Face'}, 'RowNames', {'phat', 'LowerBound', 'UpperBound'});

[phat,pci] = binofit(TotalCorrectObject,TotalObjectProbes , alpha); 

successObject = table([phat; pci(1); pci(2)], 'VariableNames', {'Object'}, 'RowNames', {'phat', 'LowerBound', 'UpperBound'});

[phat,pci] = binofit(TotalCorrectOrientation,TotalSpecificProbes , alpha); 

successOrientation = table([phat; pci(1); pci(2)], 'VariableNames', {'Orientation'}, 'RowNames', {'phat', 'LowerBound', 'UpperBound'});

[phat,pci] = binofit(TotalCorrectDuration,TotalSpecificProbes , alpha); 

successDuration = table([phat; pci(1); pci(2)], 'VariableNames', {'Duration'}, 'RowNames', {'phat', 'LowerBound', 'UpperBound'});

binomialTables = [successProbAll, successFace, successObject, successOrientation, successDuration];

binomialTablesFilename = 'binomialTables.mat';
save(fullfile(processedDataIrrelevant,binomialTablesFilename),'binomialTables');

% hypothesis testing ( whether success rate is better than chance, 50%) 
%binocdf

p0 = 0.5; %null hypothesis chance level p 

%binocdf gives the probability of gettin up to certain number of success
%(total correct number-1). To find the probability of getting certain
%number or more success ( in my case getting 37 correct values if
%participants are showing chance level performance  is 1- pValue 

AllPValue = 1-binocdf(TotalCorrect-1,TotalProbes,p0); % reject the null for the whole test 

OrientationPValue = 1-binocdf(TotalCorrectOrientation-1,TotalSpecificProbes,p0);

DurationPValue = 1- binocdf(TotalCorrectDuration-1,TotalSpecificProbes,p0);

