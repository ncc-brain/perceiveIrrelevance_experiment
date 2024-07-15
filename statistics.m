
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
load('orderEffect.mat');

%% Groups to compare 

%critical - compare performances in probes 

orientationCritical = (criticalTable.orientationPerformance(:))';
durationCritical = (criticalTable.durationPerformance(:))';

%groups for face and objects 

orientationFaceCritical = criticalTable.orientationPerformance(strcmp(criticalTable.groupName,'face'))';
durationFaceCritical = criticalTable.durationPerformance(strcmp(criticalTable.groupName,'face'))';

orientationObjectCritical = criticalTable.orientationPerformance(strcmp(criticalTable.groupName,'object'))';
durationObjectCritical = criticalTable.durationPerformance(strcmp(criticalTable.groupName,'object'))';

%post - compare the performance in the first control 

participantID = criticalTable.ParticipantID; % iterate over all subjects and get the first control performance
faceCounter = 0;
objectCounter = 0;

for i= 1: numel(participantID)

    currentParticipant = participantID(i);

    participantData = postTable(postTable.ParticipantID == currentParticipant,:);

    orientationControl(i) = participantData.orientationAccuracy(1); %post orientation scores
    durationControl(i)= participantData.durationAccuracy(1); %post duration scores 

    if strcmp(participantData.groupName(1),'face')

    faceCounter = faceCounter + 1;
    
    orientationFaceControl(faceCounter) = participantData.orientationAccuracy(1);
    durationFaceControl(faceCounter) = participantData.durationAccuracy(1);
    
    elseif strcmp(participantData.groupName(1),'object')

    objectCounter = objectCounter +1;

    orientationObjectControl(objectCounter) = participantData.orientationAccuracy(1);
    durationObjectControl(objectCounter) = participantData.durationAccuracy(1);
    

    end

end

  % compare the  performances in surprise & first control 

    surprisePerf = [orientationCritical,durationCritical];
    postPerf = [orientationControl,durationControl];

%% Chi square % Fisher Test

names = {'contTable', 'chi2', 'fisherExtract'};

%% stats for comparing probes in critical trial (within subject) - 

[contTableProbe,chiProbe,fisherProbe]= chiSquareFunction(orientationCritical,durationCritical); % compare two groups

criticalProbeStats = {array2table(contTableProbe),chiProbe,fisherProbe};


%% stats for comparing critical % post-surprise (within subject)

[contTablePerf,chiPerf,fisherPerf] = chiSquareFunction(surprisePerf,postPerf);

controlPerfStats = {array2table(contTablePerf),chiPerf,fisherPerf};

%% stats for comparing order effect (within subject)

[contTableOrientation,chiOrientation,fisherOrientation] = chiSquareFunction(orderEffect.orientationFirst,orderEffect.orientationSecond);

orientationOrderStats = {array2table(contTableOrientation),chiOrientation,fisherOrientation};

[contTableDuration,chiDuration,fisherDuration]=chiSquareFunction(orderEffect.durationFirst,orderEffect.durationSecond);

durationOrderStats = {array2table(contTableDuration),chiDuration,fisherDuration};


%% stats for comparing performance in face and object (between subject)

[contTableStimO,chiStimO,fisherStimO] = chiSquareFunction(orientationFaceCritical,orientationObjectCritical); % between group orientation
[contTableStimD,chiStimD,fisherStimD] = chiSquareFunction(durationFaceCritical,durationObjectCritical);

[contTablePostStimO,chiPostStimO,fisherPostStimO] = chiSquareFunction(orientationFaceControl,orientationObjectControl);
[contTablePostStimD,chiPostStimD,fisherPostStimD] = chiSquareFunction(durationFaceControl,durationObjectControl);

criticalOrientationStimStats = {array2table(contTableStimO),chiStimO,fisherStimO};
criticalDurationStimStats = {array2table(contTableStimD),chiStimD,fisherStimD};

postOrientationStimStats = {array2table(contTablePostStimO),chiPostStimO,fisherPostStimO};
postDurationStimStats = {array2table(contTablePostStimD),chiPostStimD,fisherPostStimD};
%% save the stats 

pilot1Stats = struct();
pilot1Stats.criticalProbeStats = criticalProbeStats;
pilot1Stats.controlPerfStats = controlPerfStats;
pilot1Stats.orientationOrderStats = orientationOrderStats;
pilot1Stats.durationOrderStats = durationOrderStats;
pilot1Stats.orientationStim = criticalOrientationStimStats;
pilot1Stats.orientationPostStim = postOrientationStimStats;
pilot1Stats.durationStim = criticalDurationStimStats;
pilot1Stats.durationPostStim=postDurationStimStats;

pilot1StatsName = 'pilot1CombinedStats.mat';
save(fullfile(processedDataComb,pilot1StatsName),'pilot1Stats');






