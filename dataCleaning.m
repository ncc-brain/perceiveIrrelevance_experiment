
%% Clear & open the file

clear
clc
addpath('./')
configIrrelevant;

cd(rawDataIrrelevant);
addpath(genpath(rawDataIrrelevant)); 

participantFolders = dir(rawDataIrrelevant); % open participant files
participantFolders = participantFolders([participantFolders.isdir] & ~startsWith({participantFolders.name}, '.')); % remove hidden files


% decide the type of the file (face or object) 

objectFolders = {}; % object folders
faceFolders = {};  %face folders

facePreSurpriseTrials = {}; %this includes pre-surprise performance 
objectPreSurpriseTrials = {}; 

faceCriticalTrial = {}; % this includes critical trials
objectCriticalTrial ={}; 

facePostSurpriseTrials = {}; % this includes post performance 
objectPostSurpriseTrials = {};


% define cols for each part (pre-surprise, critical, postSurprise) 

FacePreSurpriseCols = {'Trial_Nr','conditionFace','orientationFace','orientationFaceTarget','StimulusID','durationFace',...
    'JitterTime','fixationOnset','stimulusOnset', 'emptyFramefixationOnset','reactionTime'};

FaceCriticalCols= {'JitterCritical','stimulusOnsetCritical','reactionTimeCritical','stimulusIDCritical',...
    'fixationOnset100ms','criticalOrientation1Stim','criticalOrientation2Stim','criticalDurationShort','criticalDurationLong',...
    'confidenceDurationCritical','confidenceOrientationCritical','confidenceOrientationRT','durationConfidenceOnset','durationRT','mindWanderingQuestion','mindWanderingRT',...
    'orientationConfidenceOnset','OrientationOnset','orientationRT','stimulusDurationCritical',...
    'CBcriticalOrientation1','CBcriticalOrientation2'};


ObjectPreSurpriseCols = {'Trial_Nr','conditionObject','orientationObject','orientationObjectTarget','StimulusID','durationObject',...
    'JitterTime','fixationOnset','stimulusOnset', 'emptyFramefixationOnset','reactionTime'};

ObjectCriticalCols = {'JitterCritical','stimulusOnsetCritical','reactionTimeCritical','stimulusIDCritical',...
    'fixationOnset100ms','criticalOrientation1Stim','criticalOrientation2Stim','criticalDurationShort','criticalDurationLong',...
    'confidenceDurationCritical','confidenceOrientationCritical','confidenceOrientationRT','durationConfidenceOnset','durationRT','mindWanderingQuestion','mindWanderingRT',...
    'orientationConfidenceOnset','OrientationOnset','orientationRT','stimulusDurationCritical',...
    'criticalOrientation1','criticalOrientation2'};

PostSurpriseCols = {'confidenceDurationPostt','confidenceDurationRT','confidenceOrientationRT','congruencyCheck','durationConfidenceOnset',...
    'durationRT','emptyFramefixationOnset','fixationOnset','JitterTime','orientationConfidenceOnset','OrientationOnset',...
    'orientationRT','postDurationLong','postDurationShort','postOrientation1','postOrientation2','postOrientation1Stim','postOrientation2Stim','probeOrder','reactionTime',...
    'stimulusDurationPost','stimulusIDPost','stimulusOnset'};

%% seperate object and face files
 
for i = 1:numel(participantFolders)


    currentSubject = fullfile(rawDataIrrelevant,participantFolders(i).name);
    subjectFileContent = dir(currentSubject);
    subjectSessionFile = fullfile(currentSubject,'sessions.csv');
    sessionData = readtable(subjectSessionFile);

    if sessionData.Group_Name(1) == "GroupFace"
        faceFolders{end+1} = currentSubject; 
        faceFolders = faceFolders(~cellfun(@isempty, faceFolders)); 
    elseif sessionData.Group_Name(1) == "GroupObject"
        objectFolders{end+1} = currentSubject; 
        objectFolders = objectFolders(~cellfun(@isempty, objectFolders));
    end
end

%% create seperate pre-surprise, critical and post surprise files
  

 for j = 1: numel(faceFolders) % iterares over face files
        
     faceFolderPath = faceFolders{j}; %open facefolders
     faceTrialPath = fullfile(faceFolderPath,"trials.csv");
     currentFaceTrial = readtable(faceTrialPath); % access trial data
       
  % Pre-surprise face
        
   preSurpriseTask = currentFaceTrial(strcmp(currentFaceTrial.Task_Name,'facePre-surprise'),:);
   facePreSurpriseTrials{j} = preSurpriseTask(:,FacePreSurpriseCols);
         
 end

 % Pre-surprise object
  for j = 1: numel(objectFolders)
        
     objectFolderPath = objectFolders{j}; %open facefolders
     objectTrialPath = fullfile(objectFolderPath,"trials.csv");
     currentObjectTrial = readtable(objectTrialPath); % access trial data

     preSurpriseTask = currentObjectTrial(strcmp(currentObjectTrial.Task_Name,'objectPre-surprise'),:);
     objectPreSurpriseTrials{j} = preSurpriseTask(:,ObjectPreSurpriseCols);

  end
 


 
















%% Critical Trial Face 

% which stimulus (stim ID & orientation) 
%take the data from pre-surprise + add probe order too ! 


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

if strcmp(correctOptionO,chosenOptionO)

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

if iscell(shortDuration)
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

%reaction times 

confidenceRT = cleanCritical.confidenceOrientationRT(1) - cleanCritical.orientationConfidenceOnset(1);
orientationRT = cleanCritical.orientationRT(1) - cleanCritical.OrientationOnset(1);


criticalPerformance = table(OrientationAccuracy,cleanCritical.confidenceOrientationCritical,durationAccuracy,cleanCritical.confidenceDurationCritical...
    ,cleanCritical.mindWanderingQuestion,orientationRT,confidenceRT,'VariableNames',{'orientationPerformance','orientationConfidence','durationPerformance','durationConfidence','mindwandering','orientationRT','confidenceRT'});



% which probe came first ( orientation or duration)


%% Post-surprise Face

% which stim were shown for 4 trials 
% how long they were shown 
% options & answers given by participants 

postSurpriseTask = pilotTrial(strcmp(pilotTrial.Task_Name,'facePostSurprise'),:);



postSurpriseTable = postSurpriseTask(:,postSurpriseCols);

%post surprise performance 

correctOptionPostO = {};
chosenOptionPostO= {};
correctOptionPostD = {};
chosenOptionPostD = {};
OrientationAccuracyPost = [];
durationAccuracyPost = [];

for i = 1:height(postSurpriseTable)

    %define the stimulus and duration for each trial
    
    postStim = postSurpriseTable.stimulusIDPost{i}; % correct orientation
    postStim1 = postSurpriseTable.postOrientation1Stim{i}; % option on the left
    postStim2 = postSurpriseTable.postOrientation2Stim{i}; %option on the right
    postOption1 = postSurpriseTable.postOrientation1{i}; %choose the left one
    postOption2 = postSurpriseTable.postOrientation2{i}; %choose the right one 

    postShortDuration = postSurpriseTable.postDurationShort{i}; %option short
    postLongDuration = postSurpriseTable.postDurationLong{i}; %option long
    correctOptionPostD = cellstr(postSurpriseTable.stimulusDurationPost(i)); %correct duration

    % correct orientation option 

    if strcmp(postStim,postStim1)

        correctOptionPostO{i} = postStim1;

    elseif strcmp(postStim,postStim2)

        correctOptionPostO{i} = postStim2;

    end

    
    % chosen Orientation

    if ~isnan(postOption1)
        chosenOptionPostO{i} = postStim1;

    elseif ~isnan(postOption2)
        chosenOptionPostO{i} = postStim2;
    end

    %check whether participant made the right decision

    if strcmp(correctOptionPostO{i},chosenOptionPostO{i})

        OrientationAccuracyPost(i) = 1; 

    else
        OrientationAccuracyPost(i) = 0;

    end

% check the stimulus in given post trial 
   
if ~isnan(postShortDuration)
        chosenOptionPostD{i} = {'short'};
    elseif ~isnan(postLongDuration)
        chosenOptionPostD{i} = {'long'};
    end

%check whether participant made the right choice 

    if strcmp(correctOptionPostD,chosenOptionPostD{i})
        durationAccuracyPost(i) = 1;
    else
        durationAccuracyPost(i) = 0;
    end

end




    

