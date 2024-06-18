
% this script if for deciding the groups you want to conduct chi square &
% create contingency tables for them 
% finally using the function chiSquareFunction, you conduct chi square of
% independence

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

    currentCellObject = objectCritical{j};
    currentOrientationObject = currentCellObject.orientationPerformance;
    currentDurationObject = currentCellObject.durationPerformance;
    orientationAllObject(j) = currentOrientationObject;
    durationAllObject(j) = currentDurationObject;
    
    
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

AllPostSurprise = [ orientationPostFace,durationPostFace,orientationPostObject, durationPostObject];
AllSurprise = [orientationAllFace,orientationAllObject,durationAllFace,durationAllObject];









% critical chi square value ( df and alpha is necessery)

criticalChi = chi2inv((1-0.05),1); % p is percentile, 1 is df


if cqiSquare > criticalChi

    disp('groups are significantly different')
else
    disp('groups are not significanly different')

end

%Fischer's exact test 

%[h,p,stats] = fishertest(contTable);
