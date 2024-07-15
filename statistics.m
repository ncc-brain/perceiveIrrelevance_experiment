
% this script if for deciding the groups you want to conduct chi square 
% and using the function ,chiSquareFunction, to conduct chi square of
% independence & fisher's extract test 

% in this experiment we will compare 2 probes (orientation & duration) and performance in surprise %
% first control 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataComb)
addpath(genpath(processedDataComb)); 

% load files

load('criticalTable.mat'); 
load('postTable.mat');

%% Groups to compare 

%post - get first control data

participantID = criticalTable.ParticipantID; % iterate over all subjects and get the first control performance

for i= 1: numel(participantID)

    currentParticipant = participantID(i);

    participantData = postTable(postTable.ParticipantID == currentParticipant,:);

    firstControlData{i} = participantData(1,:); %post orientation scores

end

    %convert it to table 
    firstControlData = vertcat(firstControlData{:});

%% stats for comparing probes in critical trial + in different stimulus categories (within subject) - linear mixed models



%% stats for comparing critical & post-surprise (within subject) - McNemar's test



%% stats for comparing order effect (within subject) - fisher's exact test 

% for orientation face group (compare orientation first with orientation
% second)

% for orientation object group


%for duration face group (compare duration first with duration second)
%for duration object group 




%% stats for comparing performance in face and object (between subject)

[contTableStimO,chiStimO,fisherStimO] = chiSquareFunction(criticalTable.groupName,criticalTable.orientationPerformance,'face','object'); % between group orientation
[contTableStimD,chiStimD,fisherStimD] = chiSquareFunction(criticalTable.groupName,criticalTable.durationPerformance,'face','object');

[contTablePostStimO,chiPostStimO,fisherPostStimO] = chiSquareFunction(firstControlData.groupName,firstControlData.orientationAccuracy,'face','object');
[contTablePostStimD,chiPostStimD,fisherPostStimD] = chiSquareFunction(firstControlData.groupName,firstControlData.durationAccuracy,'face','object');


%% save the stats 

pilot1Stats = struct();
%pilot1Stats.criticalProbeStats = criticalProbeStats;
%pilot1Stats.controlPerfStats = controlPerfStats;
%pilot1Stats.orientationOrderStats = orientationOrderStats;
%pilot1Stats.durationOrderStats = durationOrderStats;
%pilot1Stats.orientationStim = criticalOrientationStimStats;
%pilot1Stats.orientationPostStim = postOrientationStimStats;
%pilot1Stats.durationStim = criticalDurationStimStats;
%pilot1Stats.durationPostStim=postDurationStimStats;

%pilot1StatsName = 'pilot1CombinedStats.mat';
%save(fullfile(processedDataComb,pilot1StatsName),'pilot1Stats');






