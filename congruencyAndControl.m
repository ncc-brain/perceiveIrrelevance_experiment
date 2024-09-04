
%this script is for checking the congruency effect on the first control
%orientation and duration performances  

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataComb);
addpath(genpath(processedDataComb)); 

load("congruencyControl.mat"); 
load('postAccuracyTable.mat');

% face and congruecy 

faceOrientationCongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'face')));  
faceDurationCongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'face')));  

faceOrientationIncongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'face')));  
faceDurationIncongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'face')));  


%object and congruency 

objectOrientationCongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'object')));  
objectDurationCongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'object')));  

objectOrientationIncongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'object')));  
objectDurationIncongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'object')));  

%congruencyBinomial 

congruentSum = numel(congruencyTable.orientationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'face')));
% congruentSum is equal to incongruent sum and same for faces and objects

binoCongruentfaceOrientation = binomialFunction(congruentSum,faceOrientationCongruent,'faceOrientationCongruent');

