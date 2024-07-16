
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

[faceOrientationMcNem] = statsFunction()


%% stats for comparing order effect (within subject) - fisher's exact test 

[contTableOrientationOrder,chiOrientationOrder,fisherOrientationOrder] = statsFunction(criticalTable.probeOrder,criticalTable.orientationPerformance,'orientationFirst','durationFirst',1,0); % between group orientation
[contTableDurationOrder,chiDurationOrder,FisherDurationOrder] = statsFunction(criticalTable.probeOrder,criticalTable.durationPerformance,'durationFirst','orientationFirst',1,0); % always put the one you expect better performance (based on your hypothesis) first

orientationOrderStats = {array2table(contTableOrientationOrder),chiOrientationOrder,fisherOrientationOrder};
durationOrderStats = {array2table(contTableDurationOrder),chiDurationOrder,FisherDurationOrder};

%% stats for comparing performance in face and object (between subject)

[contTableStimO,chiStimO,fisherStimO] = statsFunction(criticalTable.groupName,criticalTable.orientationPerformance,'face','object',2,0); % between group orientation
[contTableStimD,chiStimD,fisherStimD] = statsFunction(criticalTable.groupName,criticalTable.durationPerformance,'face','object',2,0);

[contTablePostStimO,chiPostStimO,fisherPostStimO] = statsFunction(firstControlData.groupName,firstControlData.orientationAccuracy,'face','object',2,0);
[contTablePostStimD,chiPostStimD,fisherPostStimD] = statsFunction(firstControlData.groupName,firstControlData.durationAccuracy,'face','object',2,0);

orientationStats = {array2table(contTableStimO),chiStimO,fisherStimO};
durationStats = {array2table(contTableStimD),chiStimD,fisherStimD};

postOrientationStats = {array2table(contTablePostStimO),chiPostStimO,fisherPostStimO};
postDurationStats = {array2table(contTablePostStimD),chiPostStimD,fisherPostStimD};


%% save the stats 

pilot1Stats = struct();
%pilot1Stats.criticalProbeStats = criticalProbeStats;
%pilot1Stats.controlPerfStats = controlPerfStats;
pilot1Stats.orientationOrderStats = orientationOrderStats;
pilot1Stats.durationOrderStats = durationOrderStats;
pilot1Stats.orientationGroupComp = orientationStats;
pilot1Stats.orientationPostGroupComp = postOrientationStats;
pilot1Stats.durationGroupComp= durationStats;
pilot1Stats.durationPostGroupComp=postDurationStats;

%pilot1StatsName = 'pilot1CombinedStats.mat';
%save(fullfile(processedDataComb,pilot1StatsName),'pilot1Stats');






