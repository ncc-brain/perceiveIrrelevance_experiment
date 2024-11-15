
% this script is for conducting binomial test 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataComb)
addpath(genpath(processedDataComb)); 

% load tables for the binomial test 

load('criticalAccuracyTable.mat');
load('postAccuracyTable.mat');
load('orderEffect.mat'); %for order effect performance 

%  combined orientation probe

binoOrientation = binomialFunction(criticalAccuracyTable.nrOfProbes,criticalAccuracyTable.correctOrientation,'criticalOrientation');

binoPostOrientation1 = binomialFunction(postAccuracyTable.nrOfProbes(1),postAccuracyTable.correctOrientation(1),'postOrientation1');

binoPostOrientation2 = binomialFunction(postAccuracyTable.nrOfProbes(2),postAccuracyTable.correctOrientation(2),'postOrientation2');

binoPostOrientation3 = binomialFunction(postAccuracyTable.nrOfProbes(3),postAccuracyTable.correctOrientation(3),'postOrientation3');

binoPostOrientation4 = binomialFunction(postAccuracyTable.nrOfProbes(4),postAccuracyTable.correctOrientation(4),'postOrientation4');

% combined duration probe 

binoDuration = binomialFunction(criticalAccuracyTable.nrOfProbes,criticalAccuracyTable.correctDuration,'criticalDuration');

binoPostDuration1 = binomialFunction(postAccuracyTable.nrOfProbes(1),postAccuracyTable.correctDuration(1),'postDuration1');

binoPostDuration2 = binomialFunction(postAccuracyTable.nrOfProbes(2),postAccuracyTable.correctDuration(2),'postDuration2');

binoPostDuration3 = binomialFunction(postAccuracyTable.nrOfProbes(3),postAccuracyTable.correctDuration(3),'postDuration3');

binoPostDuration4 = binomialFunction(postAccuracyTable.nrOfProbes(4),postAccuracyTable.correctDuration(4),'postDuration4');

% object probes

binoObjectOrientation = binomialFunction(criticalAccuracyTable.nrOfProbesOneGroup,criticalAccuracyTable.correctObjectOrientation,'criticalObjectOrientation');
binoObjectDuration = binomialFunction(criticalAccuracyTable.nrOfProbesOneGroup,criticalAccuracyTable.correctObjectDuration,'criticalObjectDuration');

binoPostObjectOrientation1 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(1),postAccuracyTable.correctObjectOrientation(1),'postObjectOrientation1');
binoPostObjectDuration1 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(1),postAccuracyTable.correctObjectDuration(1),'postObjectDuration1');

binoPostObjectOrientation2 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(2),postAccuracyTable.correctObjectOrientation(2),'postObjectOrientation2');
binoPostObjectDuration2 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(2),postAccuracyTable.correctObjectDuration(2),'postObjectDuration2');

binoPostObjectOrientation3 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(3),postAccuracyTable.correctObjectOrientation(3),'postObjectOrientation3');
binoPostObjectDuration3 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(3),postAccuracyTable.correctObjectDuration(3),'postObjectDuration3');

binoPostObjectOrientation4 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(4),postAccuracyTable.correctObjectOrientation(4),'postObjectOrientation4');
binoPostObjectDuration4 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(4),postAccuracyTable.correctObjectDuration(4),'postObjectDuration4');

% face probes 

binoFaceOrientation = binomialFunction(criticalAccuracyTable.nrOfProbesOneGroup,criticalAccuracyTable.correctFaceOrientation,'criticalFaceOrientation');
binoFaceDuration = binomialFunction(criticalAccuracyTable.nrOfProbesOneGroup,criticalAccuracyTable.correctFaceDuration,'criticalFaceDuration');

binoPostFaceOrientation1 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(1),postAccuracyTable.correctFaceOrientation(1),'postFaceOrientation1');
binoPostFaceDuration1 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(1),postAccuracyTable.correctFaceDuration(1),'postFaceDuration1');

binoPostFaceOrientation2 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(2),postAccuracyTable.correctFaceOrientation(2),'postFaceOrientation2');
binoPostFaceDuration2 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(2),postAccuracyTable.correctFaceDuration(2),'postFaceDuration2');

binoPostFaceOrientation3 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(3),postAccuracyTable.correctFaceOrientation(3),'postFaceOrientation3');
binoPostFaceDuration3 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(3),postAccuracyTable.correctFaceDuration(3),'postFaceDuration3');

binoPostFaceOrientation4 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(4),postAccuracyTable.correctFaceOrientation(4),'postFaceOrientation4');
binoPostFaceDuration4 = binomialFunction(postAccuracyTable.nrOfProbesOneGroup(4),postAccuracyTable.correctFaceDuration(4),'postFaceDuration4');

%order effect 

%handle NaN values 

NaNorientationFirst = ~isnan(orderEffect.orientationFirst);
NaNorientationSecond = ~isnan(orderEffect.orientationSecond);
NandurationFirst = ~isnan(orderEffect.durationFirst);
NaNdurationSecond = ~isnan(orderEffect.durationSecond);

orientationFirst = orderEffect.orientationFirst(NaNorientationFirst);
orientationSecond = orderEffect.orientationSecond(NaNorientationSecond);
durationFirst = orderEffect.durationFirst(NandurationFirst);
durationSecond = orderEffect.durationSecond(NaNdurationSecond);


accuracyOrientationFirst = binomialFunction((height(orderEffect)),sum(orientationFirst),'orientationFirst');
accuracyOrientationSecond = binomialFunction((height(orderEffect)),sum(orientationSecond),'orientationSecond');
accuracyDurationFirst= binomialFunction((height(orderEffect)),sum(durationFirst),'durationFirst');
accuracyDurationSecond=binomialFunction((height(orderEffect)),sum(durationSecond),'durationSecond');


% combined binomial table 

binomialTables = [binoOrientation,binoPostOrientation1,binoPostOrientation2,binoPostOrientation3,binoPostOrientation4,binoDuration,binoPostDuration1,binoPostDuration2,binoPostDuration3,binoPostDuration4,...
   binoObjectOrientation,binoObjectDuration,binoPostObjectOrientation1,binoPostObjectDuration1,...
   binoPostObjectOrientation2,binoPostObjectDuration2,binoPostObjectOrientation3,binoPostObjectDuration3,binoPostObjectOrientation4,binoPostObjectDuration4,binoFaceOrientation,binoFaceDuration,binoPostFaceOrientation1,binoPostFaceDuration1,...
   binoPostFaceOrientation2,binoPostFaceDuration2,binoPostFaceOrientation3,binoPostFaceDuration3,binoPostFaceOrientation4,binoPostFaceDuration4,accuracyOrientationFirst,accuracyOrientationSecond,accuracyDurationFirst,accuracyDurationSecond];

binomialTableFile = 'binomialTables.mat';
save(fullfile(processedDataComb,binomialTableFile),'binomialTables');

