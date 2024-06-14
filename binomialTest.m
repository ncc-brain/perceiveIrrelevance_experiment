

% this script is for calculating the accuracy of the responses given by the
% participants for orientation and duration 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

faceCritical = load("faceCritical.mat");
objectCritical = load('objectCritical.mat');

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

% proportion of success 

proportionOfSuccess = TotalCorrect / TotalProbes; % phat calculates this anyway 

% confidence interval (95%) 

alpha = 0.05;

% intervals for binomial proportion 

[phat, pci] = binofit(TotalCorrect,TotalProbes , alpha);

% phat estimated proportion of succeses
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

chanceLevel = 0.5;

[h, p] = binotest(TotalCorrect, TotalProbes, chanceLevel, 'Tail', 'both');

