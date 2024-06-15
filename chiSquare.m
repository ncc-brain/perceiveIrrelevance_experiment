
% in this script I will do 

% 1- create contingency tables for orientation & duration 

% 2- run chi square test for independence 


clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

faceCritical = load("faceCritical.mat");
faceCritical = faceCritical.faceCriticalTrial;

objectCritical = load('objectCritical.mat');
objectCritical = objectCritical.objectCriticalTrial;


%% Contingency tables 

orientationAllFace = [];
durationAllFace = [];
orientationAllObject =[];
durationAllObject = [];


for i = 1:numel(faceCritical) 

    currentCellFace = faceCritical{i};
    currentOrientationFace = currentCellFace.orientationPerformance;
    currentDurationFace = currentCellFace.durationPerformance;
    orientationAllFace(i) = currentOrientationFace;
    durationAllFace (i) = currentDurationFace;
    

end



for j = 1:numel(objectCritical)


    currentCell = objectCritical{j};
    currentOrientation = currentCell.orientationPerformance;
    currentDuration = currentCell.durationPerformance;
    orientationAllObject(j) = currentOrientation;
    durationAllObject(j) = currentDuration;
    
end

%generate contingency tables 

AllOrientation = [orientationAllFace,orientationAllObject];
AllDuration = [durationAllFace,durationAllObject];


categoryNames = {'wrong', 'correct'}; 


AllOrientation = categorical(AllOrientation, [0, 1], categoryNames);
AllDuration = categorical(AllDuration,[0, 1], categoryNames);

contTable = crosstab(AllOrientation, AllDuration);

% chi square for independence

[h, p, stats] = chi2test(contTable);
