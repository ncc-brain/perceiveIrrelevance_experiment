
clear
clc
addpath('./')
configIrrelevant;

%open processed files

cd(processedDataIrrelevant);
addpath(genpath(processedDataIrrelevant)); 

%face pre-surprise behavioral data


facePreSurpriseStruct = load("facePreSurprise.mat"); % load data
facePreSurpriseTable = behavioralPerformanceFunction(facePreSurpriseStruct,'face');
facePreSurpriseRTtable = 'facePreSurpriseRTtable.mat'; % save processes data
save(fullfile(processedDataIrrelevant,facePreSurpriseRTtable),'facePreSurpriseTable');

% object pre-surprise behavioral data

objectPreSurpriseStruct = load("objectPreSurprise.mat"); %load data
objectPreSurpriseTable = behavioralPerformanceFunction(objectPreSurpriseStruct,'object');
objectPreSurpriseRTtable = 'objectPreSurpriseRTtable.mat'; %save processed data
save(fullfile(processedDataIrrelevant,objectPreSurpriseRTtable),'objectPreSurpriseTable');
