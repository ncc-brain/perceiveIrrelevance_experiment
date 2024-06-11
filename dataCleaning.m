
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

correctOptionO = {}; % correct option for the critical orientation
chosenOptionO= {}; % participant response to critical orientation
chosenOptionD = {}; % participant response for critical duration 

OrientationAccuracy = []; % for orientation accuracy 

durationAccuracy = []; % for duration accuracy



% define cols for each part (pre-surprise, critical, postSurprise) 

FacePreSurpriseCols = {'Trial_Nr','conditionFace','orientationFace','orientationFaceTarget','StimulusID','durationFace',...
    'JitterTime','fixationOnset','stimulusOnset', 'emptyFramefixationOnset','reactionTime'};

FaceCriticalCols= {'JitterCritical','stimulusOnsetCritical','reactionTimeCritical','stimulusIDCritical',...
    'fixationOnset100ms','criticalOrientation1Stim','criticalOrientation2Stim','criticalDurationShort','criticalDurationLong',...
    'confidenceDurationCritical','confidenceOrientationCritical','confidenceOrientationRT','confidenceDurationRT','durationConfidenceOnset','durationRT','mindWanderingQuestion','mindWanderingRT',...
    'orientationConfidenceOnset','OrientationOnset','orientationRT','stimulusDurationCritical',...
    'CBcriticalOrientation1','CBcriticalOrientation2'};


ObjectPreSurpriseCols = {'Trial_Nr','conditionObject','orientationObject','orientationObjectTarget','StimulusID','durationObject',...
    'JitterTime','fixationOnset','stimulusOnset', 'emptyFramefixationOnset','reactionTime'};

ObjectCriticalCols = {'JitterCritical','stimulusOnsetCritical','reactionTimeCritical','stimulusIDCritical',...
    'fixationOnset100ms','criticalOrientation1Stim','criticalOrientation2Stim','criticalDurationShort','criticalDurationLong',...
    'confidenceDurationCritical','confidenceOrientationCritical','confidenceOrientationRT','confidenceDurationRT','durationConfidenceOnset','durationRT','mindWanderingQuestion','mindWanderingRT',...
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


  %critical face 

  FaceCritical = (preSurpriseTask (:,FaceCriticalCols));
  nan_rows = all(ismissing(FaceCritical), 2);
  FaceCritical = FaceCritical(~nan_rows, :);

  % critical orientation 

  % define the critical stimulus and options (there is only 1 value)
  criticalStim = cellstr(FaceCritical.stimulusIDCritical{1});
  Stim1 = cellstr(FaceCritical.criticalOrientation1Stim{1}); % stim displayed on the left side
  Stim2 = cellstr(FaceCritical.criticalOrientation2Stim{1}); % stim displayed on the right side
  
  if  isnumeric(FaceCritical.CBcriticalOrientation1) 
      optionStim1 = num2cell(FaceCritical.CBcriticalOrientation1(1));
      optionStim2 = cellstr(FaceCritical.CBcriticalOrientation2{1});

  elseif iscell(FaceCritical.CBcriticalOrientation1)
      optionStim1 = cellstr(FaceCritical.CBcriticalOrientation1{1});
      optionStim2 = num2cell(FaceCritical.CBcriticalOrientation2(1));

  end
  % find the correct option for 

        if strcmp(criticalStim,Stim1)

                correctOptionO = Stim1;

        elseif strcmp(criticalStim,Stim2)

                correctOptionO = Stim2;

        end

    %find which stim participant chose 

        if ~isempty(optionStim1) 
            chosenOptionO = Stim1;

        elseif ~isempty(optionStim2)
            chosenOptionO = Stim2;
        end

   % check whether participant chose the correct option 

        if strcmp(correctOptionO,chosenOptionO)

            OrientationAccuracy(j) = 1; 

        else
            OrientationAccuracy(j) = 0;
    
        end

    % critical duration 

    correctOptionD = cellstr(FaceCritical.stimulusDurationCritical(1)); % correct option for given critical trial

        if  isnumeric(FaceCritical.criticalDurationShort) 
      shortDuration = num2cell(FaceCritical.criticalDurationShort(1));
      longDuration = cellstr(FaceCritical.criticalDurationLong{1});

        elseif iscell(FaceCritical.criticalDurationShort)
      shortDuration = cellstr(FaceCritical.criticalDurationShort{1});
      longDuration = num2cell(FaceCritical.criticalDurationLong(1));

        end

      % check which option participant chose
        if ~isempty(shortDuration)
          chosenOptionD = {'short'};
        elseif ~isempty(longDuration)
          chosenOptionD = {'long'};
        end

    %check whether participant made the right choice 

      if strcmp(correctOptionD,chosenOptionD)
         durationAccuracy(j) = 1;
     else
         durationAccuracy(j) = 0;
      end

   %reaction times 

    orientationRT(j) = FaceCritical.orientationRT(1) - FaceCritical.OrientationOnset(1);
    OrientationConfidenceRT(j) = FaceCritical.confidenceOrientationRT(1) - FaceCritical.orientationConfidenceOnset(1);
    durationRT(j)= FaceCritical.durationRT(1);
    DurationConfidenceRT(j) = FaceCritical.confidenceDurationRT(1)- FaceCritical.durationConfidenceOnset(1);
    orientationConfidence(j)=FaceCritical.confidenceOrientationCritical(1);
    durationConfidence(j)= FaceCritical.confidenceDurationCritical(1);
    mindWanderingQuestion{j} = cellstr(FaceCritical.mindWanderingQuestion{1});
    mindWanderingRT(j)= FaceCritical.mindWanderingRT(1);
    
    criticalPerformance = table(OrientationAccuracy(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracy(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});

    faceCriticalTrial{j} = criticalPerformance; 

         
 end

 % Pre-surprise object
  for j = 1: numel(objectFolders)
        
     objectFolderPath = objectFolders{j}; %open facefolders
     objectTrialPath = fullfile(objectFolderPath,"trials.csv");
     currentObjectTrial = readtable(objectTrialPath); % access trial data

     preSurpriseTask = currentObjectTrial(strcmp(currentObjectTrial.Task_Name,'objectPre-surprise'),:);
     objectPreSurpriseTrials{j} = preSurpriseTask(:,ObjectPreSurpriseCols);
 
 

  %critical object
  

  ObjectCritical = (preSurpriseTask (:,ObjectCriticalCols));
  nan_rows = all(ismissing(ObjectCritical), 2);
  ObjectCritical = ObjectCritical(~nan_rows, :);

  % critical orientation 

  % define the critical stimulus and options (there is only 1 value)
  criticalStim = cellstr(ObjectCritical.stimulusIDCritical{1});
  Stim1 = cellstr(ObjectCritical.criticalOrientation1Stim{1}); % stim displayed on the left side
  Stim2 = cellstr(ObjectCritical.criticalOrientation2Stim{1}); % stim displayed on the right side
  
  if  isnumeric(ObjectCritical.criticalOrientation1) 
      optionStim1 = num2cell(ObjectCritical.criticalOrientation1(1));
      optionStim2 = cellstr(ObjectCritical.criticalOrientation2{1});

  elseif iscell(ObjectCritical.criticalOrientation1)
      optionStim1 = cellstr(ObjectCritical.criticalOrientation1{1});
      optionStim2 = num2cell(ObjectCritical.criticalOrientation2(1));

  end
  % find the correct option for 

        if strcmp(criticalStim,Stim1)

                correctOptionO = Stim1;

        elseif strcmp(criticalStim,Stim2)

                correctOptionO = Stim2;

        end

    %find which stim participant chose 

        if ~isempty(optionStim1) 
            chosenOptionO = Stim1;

        elseif ~isempty(optionStim2)
            chosenOptionO = Stim2;
        end

   % check whether participant chose the correct option 

        if strcmp(correctOptionO,chosenOptionO)

            OrientationAccuracy(j) = 1; 

        else
            OrientationAccuracy(j) = 0;
    
        end

    % critical duration 

    correctOptionD = cellstr(ObjectCritical.stimulusDurationCritical(1)); % correct option for given critical trial

        if  isnumeric(ObjectCritical.criticalDurationShort) 
      shortDuration = num2cell(ObjectCritical.criticalDurationShort(1));
      longDuration = cellstr(ObjectCritical.criticalDurationLong{1});

        elseif iscell(ObjectCritical.criticalDurationShort)
      shortDuration = cellstr(ObjectCritical.criticalDurationShort{1});
      longDuration = num2cell(ObjectCritical.criticalDurationLong(1));

        end

      % check which option participant chose
        if ~isempty(shortDuration)
          chosenOptionD = {'short'};
        elseif ~isempty(longDuration)
          chosenOptionD = {'long'};
        end

    %check whether participant made the right choice 

      if strcmp(correctOptionD,chosenOptionD)
         durationAccuracy(j) = 1;
     else
         durationAccuracy(j) = 0;
      end

   %reaction times 

    orientationRT(j) = ObjectCritical.orientationRT(1) - ObjectCritical.OrientationOnset(1);
    OrientationConfidenceRT(j) = ObjectCritical.confidenceOrientationRT(1) - ObjectCritical.orientationConfidenceOnset(1);
    durationRT(j)= ObjectCritical.durationRT(1);
    DurationConfidenceRT(j) = ObjectCritical.confidenceDurationRT(1)- ObjectCritical.durationConfidenceOnset(1);
    orientationConfidence(j)=ObjectCritical.confidenceOrientationCritical(1);
    durationConfidence(j)= ObjectCritical.confidenceDurationCritical(1);
    mindWanderingQuestion{j} = cellstr(ObjectCritical.mindWanderingQuestion{1});
    mindWanderingRT(j)= ObjectCritical.mindWanderingRT(1);
    
    criticalPerformance = table(OrientationAccuracy(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracy(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});

    objectCriticalTrial{j} = criticalPerformance; 

  end        



  %Save the files 

  facePreSurprise = 'facePreSurprise.mat';
  save(fullfile(processedDataIrrelevant,facePreSurprise),'facePreSurpriseTrials');
  objectPreSurprise = 'objectPreSurprise.mat';
  save(fullfile(processedDataIrrelevant,objectPreSurprise),'objectPreSurpriseTrials');

  faceCritical ='faceCritical.mat';
  save(fullfile(processedDataIrrelevant,faceCritical),'faceCriticalTrial');
  objectCritical = 'objectCritical.mat';
  save(fullfile(processedDataIrrelevant,objectCritical),'objectCriticalTrial');

 


%%










































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




    

