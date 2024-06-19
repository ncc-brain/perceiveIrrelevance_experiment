
% this script if for deciding the groups you want to conduct chi square 
% and using the function ,chiSquareFunction, to conduct chi square of
% independence & fisher's extract test 

% in this experiment we will compare 2 probes (orientation & duration) and performance in surprise %
% first control 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

% load files
load('faceCritical.mat');
load('objectCritical.mat');
load('facePostSurprise.mat');
load('objectPostSurprise.mat');

faceCritical= faceCriticalTrial;
objectCritical = objectCriticalTrial;

facePost = facePostSurpriseTrials;
objectPost = objectPostSurpriseTrials;


%% Contingency table groups 

%critical

orientationAllFace = [];
durationAllFace = [];
orientationAllObject =[];
durationAllObject = [];

% check size 

if numel(faceCritical) ~= numel(objectCritical)

    disp('ERROR! , size of the critical trials should be same');

end


for i = 1:numel(faceCritical) 

    currentCellFace = faceCritical{i};
    currentOrientationFace = currentCellFace.orientationPerformance;
    currentDurationFace = currentCellFace.durationPerformance;
    orientationAllFace(i) = currentOrientationFace;
    durationAllFace (i) = currentDurationFace;

    currentCellObject = objectCritical{i};
    currentOrientationObject = currentCellObject.orientationPerformance;
    currentDurationObject = currentCellObject.durationPerformance;
    orientationAllObject(i) = currentOrientationObject;
    durationAllObject(i) = currentDurationObject;
    
    
end


%generate comparison tables for orientation & duration 


AllOrientation = [orientationAllFace,orientationAllObject];
AllDuration = [durationAllFace,durationAllObject];



%first post surprise groups 

% check size 
if numel(facePost) ~= numel(objectPost)

    disp('ERROR! , size of the post trials should be same');

end



for i = 1:numel(facePost) 

    currentPostFace = facePost{i};
    currentOrientationPostFace= currentPostFace.orientationAccuracy(1);
    currentDurationPostFace = currentPostFace.durationAccuracy(1);
    orientationPostFace(i) = currentOrientationPostFace;
    durationPostFace(i) = currentDurationPostFace;

    currentPostObject = objectPost{i};
    currentOrientationPostObject= currentPostObject.orientationAccuracy(1);
    currentDurationPostObject = currentPostObject.durationAccuracy(1);
    orientationPostObject(i) = currentOrientationPostObject;
    durationPostObject(i) = currentDurationPostObject;
    
end

% generate groups 

AllPostSurprise = [orientationPostFace,durationPostFace,orientationPostObject, durationPostObject];
AllSurprise = [orientationAllFace,orientationAllObject,durationAllFace,durationAllObject];


%% Chi square 

[fisherProbe,chiProbe]= chiSquareFunction(AllOrientation,AllDuration); % compare two groups

ProbeFisher = fisherProbe;
ProbeChi = chiProbe; 

pilot1ProbeFisherFile = 'pilot1ProbeFisher';
save(fullfile(processedDataIrrelevant,pilot1ProbeFisherFile),'ProbeFisher');

pilot1ProbeChiFile = 'pilot1ProbeChi';
save(fullfile(processedDataIrrelevant,pilot1ProbeChiFile),'ProbeChi');

[fisherPerf,chiPerf]=chiSquareFunction(AllSurprise,AllPostSurprise); % difference between surprise and post surprise 

pilot1PerformanceFisherFile = 'pilot1PerfFisher';
save(fullfile(processedDataIrrelevant,pilot1PerformanceFisherFile),'fisherPerf');

pilot1PerformanceChiFile = 'pilot1PerfChi';
save(fullfile(processedDataIrrelevant,pilot1PerformanceChiFile),'ProbeChi');

% compare All faces % All objects 

AllFaces = [orientationAllFace,durationAllFace];
AllObjects = [orientationAllObject,durationAllObject];

[fisherGroup,chiGroup] = chiSquareFunction(AllFaces,AllObjects);

pilot1GroupsFisherFile = 'pilot1GroupsFisher';
save(fullfile(processedDataIrrelevant,pilot1GroupsFisherFile),'fisherGroup');

pilot1GroupsChiFile = 'pilot1GroupsChi';
save(fullfile(processedDataIrrelevant,pilot1GroupsChiFile),'chiGroup');


