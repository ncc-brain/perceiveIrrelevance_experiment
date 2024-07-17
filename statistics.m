
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
%% prepare matched pairs
faceOrientationCritical = [num2cell(criticalTable.orientationPerformance(strcmp(criticalTable.groupName, 'face'))), repmat({'face'}, sum(strcmp(criticalTable.groupName, 'face')), 1)];
faceDurationCritical = [num2cell(criticalTable.durationPerformance(strcmp(criticalTable.groupName, 'face'))), repmat({'face'}, sum(strcmp(criticalTable.groupName, 'face')), 1)];

objectOrientationCritical = [num2cell(criticalTable.orientationPerformance(strcmp(criticalTable.groupName, 'object'))), repmat({'object'}, sum(strcmp(criticalTable.groupName, 'object')), 1)];
objectDurationCritical = [num2cell(criticalTable.durationPerformance(strcmp(criticalTable.groupName, 'object'))), repmat({'object'}, sum(strcmp(criticalTable.groupName, 'object')), 1)];

faceOrientationPost = [num2cell(firstControlData.orientationAccuracy(strcmp(firstControlData.groupName, 'face'))), repmat({'face'}, sum(strcmp( firstControlData.groupName, 'face')), 1)];
faceDurationPost = [num2cell( firstControlData.durationAccuracy(strcmp(firstControlData.groupName, 'face'))), repmat({'face'}, sum(strcmp( firstControlData.groupName, 'face')), 1)];

objectOrientationPost = [num2cell(firstControlData.orientationAccuracy(strcmp(firstControlData.groupName, 'object'))), repmat({'object'}, sum(strcmp(firstControlData.groupName, 'object')), 1)];
objectDurationPost = [num2cell(firstControlData.durationAccuracy(strcmp(firstControlData.groupName, 'object'))), repmat({'object'}, sum(strcmp(firstControlData.groupName, 'object')), 1)];

orientationPerformance = [[faceOrientationCritical(:,1);objectOrientationCritical(:,1)],[faceOrientationCritical(:,2);objectOrientationCritical(:,2)],[repmat({'critical'},height(criticalTable),1)]];
durationPerformance = [[faceDurationCritical(:,1);objectDurationCritical(:,1)],[faceDurationCritical(:,2);objectDurationCritical(:,2)],[repmat({'critical'},height(criticalTable),1)]];

postOrientationPerformance = [[faceOrientationPost(:,1);objectOrientationPost(:,1)],[faceOrientationPost(:,2);objectOrientationPost(:,2)],[repmat({'control'},height(firstControlData),1)]];
postDurationPerformance = [[faceDurationPost(:,1);objectDurationPost(:,1)],[faceDurationPost(:,2);objectDurationPost(:,2)],[repmat({'control'},height(firstControlData),1)]];

orientationCombined = cell2table([orientationPerformance;postOrientationPerformance],'VariableNames',{'accuracy','group','test'});
durationCombined = cell2table([durationPerformance;postDurationPerformance],'VariableNames',{'accuracy','group','test'});

%decide the index 
faceIndexOrientation = strcmp(orientationCombined.group,'face');
objectIndexOrientation = strcmp(orientationCombined.group,'object');

faceIndexDuration = strcmp(durationCombined.group,'face');
objectIndexDuration= strcmp(durationCombined.group,'object');

%% stats for comparing probes in critical trial + in different stimulus categories (within subject) - linear mixed models



%% stats for comparing critical & post-surprise (within subject) - McNemar's test

[contFaceOrientation ,~ ,~ ,McNemfaceOrientation] = statsFunction(orientationCombined.test(faceIndexOrientation),orientationCombined.accuracy(faceIndexOrientation),'critical','control',2,1); % give the data ensuring b < c (if not b = c) and check whether b+c>10 for power 
[contFaceDuration,~,~,McNemfaceDuration] = statsFunction(durationCombined.test(faceIndexDuration),durationCombined.accuracy(faceIndexDuration),'control','critical',2,1);

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






