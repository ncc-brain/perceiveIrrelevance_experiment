
%% Clear & open the file

clear
clc
cd('/Users/ece.ziya/Documents/GitHub/dissimilarity_experiment');

dataPath = ('/Users/ece.ziya/Desktop/testFiles/examplePilot');
cd(dataPath);

pilotTrial = 'trials.csv';
pilotSession = 'sessions.csv';

pilotTrial = readtable(pilotTrial);
pilotSession = readtable(pilotSession);


%% Pre-surprise  

% get the data for the pre-surprise

 preSurpriseTask = pilotTrial(strcmp(pilotTrial.Task_Name,'facePre-surprise'),:);

% get the coloumns for the analyis (behavioral performance & reaction times

preSurpriseCols = {'Trial_Nr','conditionFace','orientationFace','orientationFaceTarget','StimulusID','durationFace',...
   'JitterTime','fixationOnset','stimulusOnset', 'emptyFramefixationOnset','reactionTime'};

preSurpriseTable = preSurpriseTask(:,preSurpriseCols);

% hit rate (if the stim condition is target and participants pressed space (value in rt)
% false alarm rate ( if the stim condition is not a target and participants
% pressed space (value in rt)

numberHits = 0; % nr of times participants pressed space when it is target
numberFalseAlarms = 0; % nr of times participants pressed space when it is not target
rtHit = []; % rt hit
rtFalseAlarm = []; %rt false alarm
hitsTable = table(); % everything about hits
falseAlarmTable = table(); %everything about false alarm 
hitIndex = 1;
falseAlarmIndex = 1;

for i= 1: height(preSurpriseTable)
     
    if ~isnan(preSurpriseTable.reactionTime(i)) % if there is space press, there is a number in RT
         
           if strcmp(preSurpriseTable.conditionFace{i},'target')
              
              numberHits = numberHits + 1; % if it is a target then it is a hit

              % accurate RT calculations

           if strcmp(preSurpriseTable.durationFace{i},'short') && preSurpriseTable.reactionTime(i) <= 500
              
               rtHit(hitIndex) = preSurpriseTable.reactionTime(i)- preSurpriseTable.stimulusOnset(i);
           
           elseif strcmp(preSurpriseTable.durationFace{i},'short') && preSurpriseTable.reactionTime(i) > 500

               rtHit(hitIndex) = preSurpriseTable.reactionTime(i) - preSurpriseTable.emptyFramefixationOnset(i);
           elseif strcmp(preSurpriseTable.durationFace{i},'long') && preSurpriseTable.reactionTime(i) <= 1500 %pressed in the stim frame

               rtHit(hitIndex) = preSurpriseTable.reactionTime(i)- preSurpriseTable.stimulusOnset(i);
           elseif strcmp(preSurpriseTable.durationFace{i},'long') && preSurpriseTable.reactionTime(i) > 1500 %pressed in the empty frame 
               rtHit(hitIndex) = preSurpriseTable.reactionTime(i) - preSurpriseTable.emptyFramefixationOnset(i);
           end

              hitsTable = [hitsTable;table(preSurpriseTable.Trial_Nr(i),{preSurpriseTable.durationFace(i)},{preSurpriseTable.orientationFaceTarget(i)},rtHit(hitIndex),...
                  'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
              hitIndex = hitIndex + 1;
              
           else
               numberFalseAlarms = numberFalseAlarms +1;
               
             
           if strcmp(preSurpriseTable.durationFace{i},'short') && preSurpriseTable.reactionTime(i) <= 500
              
               rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(i)- preSurpriseTable.stimulusOnset(i);
           
           elseif strcmp(preSurpriseTable.durationFace{i},'short') && preSurpriseTable.reactionTime(i) > 500

               rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(i) - preSurpriseTable.emptyFramefixationOnset(i);
           elseif strcmp(preSurpriseTable.durationFace{i},'long') && preSurpriseTable.reactionTime(i) <= 1500

               rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(i)- preSurpriseTable.stimulusOnset(i);
           elseif strcmp(preSurpriseTable.durationFace{i},'long') && preSurpriseTable.reactionTime(i) > 1500
               rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(i) - preSurpriseTable.emptyFramefixationOnset(i);
           end

            falseAlarmTable = [falseAlarmTable;table(preSurpriseTable.Trial_Nr(i),{preSurpriseTable.durationFace(i)},{preSurpriseTable.orientationFace(i)},rtFalseAlarm(falseAlarmIndex),...
                 'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
            falseAlarmIndex = falseAlarmIndex + 1;
           end  
    end

end


%behavioral performance check : min 80 percent hit rate & max 20 percent false alarm 

numberTargets = sum(strcmp(preSurpriseTable.conditionFace,'target'));
numberNonTargets = sum(~strcmp(preSurpriseTable.conditionFace,'target'));

if numberHits/numberTargets >=.80 && numberFalseAlarms/numberNonTargets <=.20
    disp('participant passed');
else
    disp('participant failed');
end



%% Critical Trial 

% which stimulus (stim ID & orientation) 
%take the data from pre-surprise + add probe order too ! 
criticalCols= {'JitterCritical','stimulusOnsetCritical','reactionTimeCritical','stimulusIDCritical',...
    'fixationOnset100ms','criticalOrientation1Stim','criticalOrientation2Stim','criticalDurationShort','criticalDurationLong',...
    'confidenceDurationCritical','confidenceOrientationRT','durationConfidenceOnset','durationRT','mindWanderingQuestion','mindWanderingRT',...
    'orientationConfidenceOnset','OrientationOnset','orientationRT','stimulusDurationCritical',...
    'CBcriticalOrientation1','CBcriticalOrientation2'};

criticalTable = (preSurpriseTask (:,criticalCols));

nan_rows = all(ismissing(criticalTable), 2);
cleanCritical = criticalTable(~nan_rows, :);

%check accuracy of orientation  

%check the stimulus ID and find its match in one of the criticalOrientation 

correctOptionO = {};
chosenOptionO= {};

criticalStim = cleanCritical.stimulusIDCritical;
Stim1 = cleanCritical.criticalOrientation1Stim;
Stim2 = cleanCritical.criticalOrientation2Stim; 
optionStim1 = cleanCritical.CBcriticalOrientation1;
optionStim2 = cleanCritical.CBcriticalOrientation2;

% find the correct option 

if strcmp(criticalStim,Stim1)

    correctOptionO = Stim1;

elseif strcmp(criticalStim,Stim2)

    correctOptionO = Stim2;

end

%find which stim participant chose 

if iscell(optionStim1(1)) 
    chosenOptionO = Stim1;

elseif iscell(optionStim2(1))
    chosenOptionO = Stim2;
end

% check whether participant chose the correct option 

OrientationAccuracy = [];

if strcmp(correctOption,chosenOption)

    OrientationAccuracy = 1; 

else
    OrientationAccuracy = 0;
    
end

%check the participant response to duration
durationAccuracy = [];

correctOptionD = cleanCritical.stimulusDurationCritical;
chosenOptionD = {};

shortDuration = cleanCritical.criticalDurationShort;
longDuration = cleanCritical.criticalDurationLong; 

if iscell(shortDuration(1))
    chosenOptionD = {'short'};
else
    chosenOptionD = {'long'};
end

%check whether participant made the right choice 

if strcmp(correctOptionD,chosenOptionD)
    durationAccuracy = 1;
else
    durationAccuracy = 0;
end


% add confidence ratings 

% when it is shown (stim duration) 
% which probe came first ( orientation or duration)
% orientation options & which one is chosen
% duration options (which one is chosen)
% mindwandering --> which one is chosen 
% RT for all 
% confidence for all 
%add probe order to the critical stim as well ( same for the

%% Post-surprise 

% which stim were shown for 4 trials 
% how long they were shown 
% options & answers given by participants 

postSurpriseTask = pilotTrial(strcmp(pilotTrial.Task_Name,'facePostSurprise'),:);

postSurpriseCols = {'confidenceDurationPostt','confidenceDurationRT','confidenceOrientationRT','congruencyCheck','durationConfidenceOnset',...
    'durationRT','emptyFramefixationOnset','fixationOnset','JitterTime','orientationConfidenceOnset','OrientationOnset',...
    'orientationRT','postDurationLong','postDurationShort','postOrientation1','postOrientation2','postOrientation1Stim','postOrientation2Stim','probeOrder','reactionTime',...
    'stimulusDurationPost','stimulusIDPost','stimulusOnset'};

postSurpriseTable = postSurpriseTask(:,postSurpriseCols);