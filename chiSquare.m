
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
load('orderEffect.mat');

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


%% Chi square % Fisher Test

names = {'contTable', 'chi2', 'fisherExtract'};

%% stats for comparing probes in critical trial 

[contTableProbe,chiProbe,fisherProbe]= chiSquareFunction(orientationCritical,durationCritical); % compare two groups

criticalProbeStats = {array2table(contTableProbe),chiProbe,fisherProbe};


%% stats for comparing critical % post-surprise 

[contTablePerf,chiPerf,fisherPerf] = chiSquareFunction(surprisePerf,postPerf);

controlPerfStats = {array2table(contTablePerf),chiPerf,fisherPerf};

%% stats for comparing order effect 

[contTableOrientation,chiOrientation,fisherOrientation] = chiSquareFunction(orientationFirst,orientationSecond);

orientationOrderStats = {array2table(contTableOrientation),chiOrientation,fisherOrientation};

[contTableDuration,chiDuration,fisherDuration]=chiSquareFunction(durationFirst,durationSecond);

durationOrderStats = {array2table(contTableDuration),chiDuration,fisherDuration};

%% save the stats 

pilot1Stats = struct();
pilot1Stats.criticalProbeStats = criticalProbeStats;
pilot1Stats.controlPerfStats = controlPerfStats;
pilot1Stats.orientationOrderStats = orientationOrderStats;
pilot1Stats.durationOrderStats = durationOrderStats;

pilot1StatsName = 'pilot1Stats.mat';
save(fullfile(processedDataIrrelevant,pilot1StatsName),'pilot1Stats');






