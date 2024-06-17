
% this script is for conducting binomial test

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

% load tables for the binomial test 

load('CriticalAccuracyTable.mat');
load('PostAccuracyTableFile.mat');

binoOrientation = binomialFunction(CriticalAccuracyTable.Nr1IrrelevantProbe,CriticalAccuracyTable.totalCorrectOrientation,'criticalOrientation');

binoPostOrientation = binomialFunction(PostAccuracyTable.Nr1IrrelevantProbe(1),PostAccuracyTable.totalCorrectOrientation(1),'postOrientation1');

