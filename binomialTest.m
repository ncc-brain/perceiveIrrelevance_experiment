
% this script is for conducting binomial test

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

% load tables for the binomial test 

load('CriticalAccuracyTable.mat');
load('PostAccuracyTable.mat');

% orientation probe

binoOrientation = binomialFunction(CriticalAccuracyTable.Nr1IrrelevantProbe,CriticalAccuracyTable.totalCorrectOrientation,'criticalOrientation');

binoPostOrientation1 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(1),PostAccuracyTable.totalCorrectOrientation(1),'postOrientation1');

binoPostOrientation2 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(2),PostAccuracyTable.totalCorrectOrientation(2),'postOrientation2');

binoPostOrientation3 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(3),PostAccuracyTable.totalCorrectOrientation(3),'postOrientation3');

binoPostOrientation4 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(4),PostAccuracyTable.totalCorrectOrientation(3),'postOrientation4');

% duration probe 

binoDuration = binomialFunction(CriticalAccuracyTable.Nr1IrrelevantProbe,CriticalAccuracyTable.totalCorrectDuration,'criticalDuration');

binoPostDuration1 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(1),PostAccuracyTable.totalCorrectDuration(1),'postDuration1');

binoPostDuration2 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(2),PostAccuracyTable.totalCorrectDuration(2),'postDuration2');

binoPostDuration3 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(3),PostAccuracyTable.totalCorrectDuration(3),'postDuration3');

binoPostDuration4 = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(4),PostAccuracyTable.totalCorrectDuration(4),'postDuration4');


%face probes 

binoFace = binomialFunction(CriticalAccuracyTable.NrFaceProbes,CriticalAccuracyTable.totalCorrectFace,'criticalFace');

binoPostFace1 = binomialFunction(PostAccuracyTable.NrFaceProbes(1),PostAccuracyTable.totalCorrectFace(1),'postFace1');

binoPostFace2 = binomialFunction(PostAccuracyTable.NrFaceProbes(2),PostAccuracyTable.totalCorrectFace(2),'postFace2');

binoPostFace3 = binomialFunction(PostAccuracyTable.NrFaceProbes(3),PostAccuracyTable.totalCorrectFace(3),'postFace3');

binoPostFace4 = binomialFunction(PostAccuracyTable.NrFaceProbes(4),PostAccuracyTable.totalCorrectFace(4),'postFace4');


% object probes

binoObject = binomialFunction(CriticalAccuracyTable.NrObjectProbes,CriticalAccuracyTable.totalCorrectObject,'criticalObject');

binoPostObject1 = binomialFunction(PostAccuracyTable.NrObjectProbes(1),PostAccuracyTable.totalCorrectObject(1),'postObject1');

binoPostObject2 = binomialFunction(PostAccuracyTable.NrObjectProbes(2),PostAccuracyTable.totalCorrectObject(2),'postObject2');

binoPostObject3 = binomialFunction(PostAccuracyTable.NrObjectProbes(3),PostAccuracyTable.totalCorrectObject(3),'postObject3');

binoPostObject4 = binomialFunction(PostAccuracyTable.NrObjectProbes(4),PostAccuracyTable.totalCorrectObject(4),'postObject4');

% object specific probes 

binoObjectOrientation = binomialFunction(CriticalAccuracyTable.Nr1IrrelevantProbe,CriticalAccuracyTable.TotalCorrectObjectOrientation,'criticalObjectOrientation');
binoObjectDuration = binomialFunction(CriticalAccuracyTable.Nr1IrrelevantProbe,CriticalAccuracyTable.TotalCorrectObjectDuration,'criticalObjectDuration');

binoPostObjectOrientation1 = binomialFunction(PostAccuracyTable.NrObjectProbes(1),PostAccuracyTable.TotalPostCorrectOrientationObject(1),'postObjectOrientation1');
binoPostObjectDuration1 = binomialFunction(PostAccuracyTable.NrObjectProbes(1),PostAccuracyTable.TotalPostCorrectDurationObject(1),'postObjectDuration1');

binoPostObjectOrientation2 = binomialFunction(PostAccuracyTable.NrObjectProbes(2),PostAccuracyTable.TotalPostCorrectOrientationObject(2),'postObjectOrientation2');
binoPostObjectDuration2 = binomialFunction(PostAccuracyTable.NrObjectProbes(2),PostAccuracyTable.TotalPostCorrectDurationObject(2),'postObjectDuration2');

binoPostObjectOrientation3 = binomialFunction(PostAccuracyTable.NrObjectProbes(3),PostAccuracyTable.TotalPostCorrectOrientationObject(3),'postObjectOrientation3');
binoPostObjectDuration3 = binomialFunction(PostAccuracyTable.NrObjectProbes(3),PostAccuracyTable.TotalPostCorrectOrientationObject(3),'postObjectDuration3');

binoPostObjectOrientation4 = binomialFunction(PostAccuracyTable.NrObjectProbes(4),PostAccuracyTable.TotalPostCorrectOrientationObject(4),'postObjectOrientation4');
binoPostObjectDuration4 = binomialFunction(PostAccuracyTable.NrObjectProbes(4),PostAccuracyTable.TotalPostCorrectDurationObject(4),'postObjectDuration4');

% face specific probes 

binoFaceOrientation = binomialFunction(CriticalAccuracyTable.Nr1IrrelevantProbe,CriticalAccuracyTable.TotalCorrectFaceOrientation,'criticalFaceOrientation');
binoFaceDuration = binomialFunction(CriticalAccuracyTable.Nr1IrrelevantProbe,CriticalAccuracyTable.TotalCorrectFaceDuration,'criticalFaceDuration');

binoPostFaceOrientation1 = binomialFunction(PostAccuracyTable.NrObjectProbes(1),PostAccuracyTable.TotalPostCorrectOrientationFace(1),'postFaceOrientation1');
binoPostFaceDuration1 = binomialFunction(PostAccuracyTable.NrObjectProbes(1),PostAccuracyTable.TotalPostCorrectDurationFace(1),'postFaceDuration1');

binoPostFaceOrientation2 = binomialFunction(PostAccuracyTable.NrObjectProbes(2),PostAccuracyTable.TotalPostCorrectOrientationFace(2),'postFaceOrientation2');
binoPostFaceDuration2 = binomialFunction(PostAccuracyTable.NrObjectProbes(2),PostAccuracyTable.TotalPostCorrectDurationFace(2),'postFaceDuration2');

binoPostFaceOrientation3 = binomialFunction(PostAccuracyTable.NrObjectProbes(3),PostAccuracyTable.TotalPostCorrectOrientationFace(3),'postFaceOrientation3');
binoPostFaceDuration3 = binomialFunction(PostAccuracyTable.NrObjectProbes(3),PostAccuracyTable.TotalPostCorrectDurationFace(3),'postFaceDuration3');

binoPostFaceOrientation4 = binomialFunction(PostAccuracyTable.NrObjectProbes(4),PostAccuracyTable.TotalPostCorrectOrientationFace(4),'postFaceOrientation4');
binoPostFaceDuration4 = binomialFunction(PostAccuracyTable.NrObjectProbes(4),PostAccuracyTable.TotalPostCorrectDurationFace(4),'postFaceDuration4');

% all probes 

binoAll = binomialFunction(CriticalAccuracyTable.NrAllirrelevantProbes,CriticalAccuracyTable.TotalCorrectResponse,'criticalAll');

binoAllPost1 = binomialFunction(PostAccuracyTable.NrAllirrelevantProbes(1),PostAccuracyTable.TotalCorrectResponse(1),'postAll1');

binoAllPost2 = binomialFunction(PostAccuracyTable.NrAllirrelevantProbes(2),PostAccuracyTable.TotalCorrectResponse(2),'postAll2');

binoAllPost3 = binomialFunction(PostAccuracyTable.NrAllirrelevantProbes(3),PostAccuracyTable.TotalCorrectResponse(3),'postAll3');

binoAllPost4 = binomialFunction(PostAccuracyTable.NrAllirrelevantProbes(4),PostAccuracyTable.TotalCorrectResponse(1),'postAll4');

% combined table 

binomialTables = [binoOrientation,binoPostOrientation1,binoPostOrientation2,binoPostOrientation3,binoPostOrientation4,binoDuration,binoPostDuration1,binoPostDuration2,binoPostDuration3,binoPostDuration4,...
   binoFace,binoPostFace1,binoPostFace2,binoPostFace3,binoPostFace4,binoObject,binoPostObject1,binoPostObject2,binoPostObject3,binoPostObject4,binoObjectOrientation,binoObjectDuration,binoPostObjectOrientation1,binoPostObjectDuration1,...
   binoPostObjectOrientation2,binoPostObjectDuration2,binoPostObjectOrientation3,binoPostObjectDuration3,binoPostObjectOrientation4,binoPostObjectDuration4,binoFaceOrientation,binoFaceDuration,binoPostFaceOrientation1,binoPostFaceDuration1,...
   binoPostFaceOrientation2,binoPostFaceDuration2,binoPostFaceOrientation3,binoPostFaceDuration3,binoPostFaceOrientation4,binoPostFaceDuration4,binoAll,binoAllPost1,binoAllPost2,binoAllPost3,binoAllPost4];

binomialTableFile = 'binomialTables.mat';
save(fullfile(processedDataIrrelevant,binomialTableFile),'binomialTables');

