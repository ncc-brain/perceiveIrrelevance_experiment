
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

load('criticalTable.mat'); 
load('postTable.mat');

%% Groups to compare 

%critical - compare performances in probes 

orientationCritical = (criticalTable.orientationPerformance(:))';
durationCritical = (criticalTable.durationPerformance(:))';


%post - compare the performance in the first control 

participantID = criticalTable.ParticipantID; % iterate over all subjects and get the first control performance

for i= 1: numel(participantID)

    currentParticipant = participantID(i);

    participantData = postTable(postTable.ParticipantID == currentParticipant,:);

    orientationControl(i) = participantData.orientationAccuracy(1); %post orientation scores
    durationControl(i)= participantData.durationAccuracy(1); %post duration scores 

end

  % compare the  performances in surprise & first control 

    surprisePerf = [orientationCritical,durationCritical];
    postPerf = [orientationControl,durationControl];


%  compare performance with order effect 

   orientationFirstRow = strcmp(criticalTable.probeOrder, 'orientationFirst');
   durationFirstRow = strcmp(criticalTable.probeOrder,'durationFirst');
   
   orientationFirst = (criticalTable.orientationPerformance(orientationFirstRow))'; % orientation performance if orientation first
   durationFirst = (criticalTable.durationPerformance(durationFirstRow))'; % duration performance if duration first

   orientationSecond = (criticalTable.orientationPerformance(durationFirstRow))';
   durationSecond = (criticalTable.durationPerformance(orientationFirstRow))'; 



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



