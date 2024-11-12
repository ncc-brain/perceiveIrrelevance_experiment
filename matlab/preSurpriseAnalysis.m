
clear
clc
addpath('./')
configIrrelevant;

%open processed files

cd(processedDataComb);
addpath(genpath(processedDataComb)); 

% face pre-surprise behavioral data


facePreSurpriseStruct = load("facePreSurprise.mat"); % load data
facePreSurpriseTable = behavioralPerformanceFunction(facePreSurpriseStruct,'face');
facePreSurpriseRTtable = 'facePreSurpriseRTtable.mat'; % save processes data
save(fullfile(processedDataComb,facePreSurpriseRTtable),'facePreSurpriseTable');

% object pre-surprise behavioral data

objectPreSurpriseStruct = load("objectPreSurprise.mat"); %load data
objectPreSurpriseTable = behavioralPerformanceFunction(objectPreSurpriseStruct,'object');
objectPreSurpriseRTtable = 'objectPreSurpriseRTtable.mat'; %save processed data
save(fullfile(processedDataComb,objectPreSurpriseRTtable),'objectPreSurpriseTable');
