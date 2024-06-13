
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

correctOptionPostO = {}; % correct option for post surprise orientation
chosenOptionPostO= {}; % participant response to post orientation
correctOptionPostD = {}; % correct option for the duration
chosenOptionPostD = {}; %participant response to post duration
OrientationAccuracyPost = [];
durationAccuracyPost = [];




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
    'stimulusDurationPost','stimulusIDPost','stimulusOnset','confidenceOrientationPostt'};

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
     participantIDPath = fullfile(faceFolderPath,"sessions.csv");
     participantIDtable = readtable(participantIDPath);
     participantID = participantIDtable.Subject_Code;
       
  % Pre-surprise face
        
   preSurpriseTask = currentFaceTrial(strcmp(currentFaceTrial.Task_Name,'facePre-surprise'),:);
   facePreSurpriseTrials{j} = preSurpriseTask(:,FacePreSurpriseCols);
   facePreSurpriseTrials{j}.ParticipantID = repmat((participantID), height(facePreSurpriseTrials{j}), 1);
 

  %critical face 

  FaceCritical = (preSurpriseTask (:,FaceCriticalCols));
  nan_rows = all(ismissing(FaceCritical), 2);
  FaceCritical = FaceCritical(~nan_rows, :);

  % critical orientation 

  % define the critical stimulus and options (there is only 1 value)
  criticalStim = cellstr(FaceCritical.stimulusIDCritical{42});
  Stim1 = cellstr(FaceCritical.criticalOrientation1Stim{42}); % stim displayed on the left side
  Stim2 = cellstr(FaceCritical.criticalOrientation2Stim{42}); % stim displayed on the right side
  
  if  isnumeric(FaceCritical.CBcriticalOrientation1) 
      optionStim1 = num2cell(FaceCritical.CBcriticalOrientation1(42));
      optionStim2 = cellstr(FaceCritical.CBcriticalOrientation2{42});

  elseif iscell(FaceCritical.CBcriticalOrientation1)
      optionStim1 = cellstr(FaceCritical.CBcriticalOrientation1{42});
      optionStim2 = num2cell(FaceCritical.CBcriticalOrientation2(42));

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

    correctOptionD = cellstr(FaceCritical.stimulusDurationCritical(42)); % correct option for given critical trial

        if  isnumeric(FaceCritical.criticalDurationShort) 
      shortDuration = num2cell(FaceCritical.criticalDurationShort(42));
      longDuration = cellstr(FaceCritical.criticalDurationLong{42});

        elseif iscell(FaceCritical.criticalDurationShort)
      shortDuration = cellstr(FaceCritical.criticalDurationShort{42});
      longDuration = num2cell(FaceCritical.criticalDurationLong(42));

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

    orientationRT(j) = FaceCritical.orientationRT(42) - FaceCritical.OrientationOnset(42);
    OrientationConfidenceRT(j) = FaceCritical.confidenceOrientationRT(42) - FaceCritical.orientationConfidenceOnset(42);
    durationRT(j)= FaceCritical.durationRT(42);
    DurationConfidenceRT(j) = FaceCritical.confidenceDurationRT(42)- FaceCritical.durationConfidenceOnset(42);
    orientationConfidence(j)=FaceCritical.confidenceOrientationCritical(42);
    durationConfidence(j)= FaceCritical.confidenceDurationCritical(42);
    mindWanderingQuestion{j} = cellstr(FaceCritical.mindWanderingQuestion{42});
    mindWanderingRT(j)= FaceCritical.mindWanderingRT(42);
    
    criticalPerformance = table(OrientationAccuracy(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracy(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});

    faceCriticalTrial{j} = criticalPerformance; 
    faceCriticalTrial{j}.ParticipantID = repmat((participantID), height(faceCriticalTrial{j}), 1);


    %post surprise face 

     postSurpriseTask = currentFaceTrial(strcmp(currentFaceTrial.Task_Name,'facePostSurprise'),:);
     facePostSurpriseTrials{j} = postSurpriseTask(:,PostSurpriseCols);
     onePostSurpriseTrial = table();

    for k = 1:height(postSurpriseTask)
        
        postTrialData = postSurpriseTask(k, :);

    %define the stimulus and duration for each trial
    
     postStim = cellstr(postTrialData.stimulusIDPost{k}); % correct orientation
     postStim1 = cellstr(postTrialData.postOrientation1Stim{k}); % option on the left
     postStim2 = cellstr(postTrialData.postOrientation2Stim{k}); %option on the right
     
      if  isnumeric(postTrialData.postOrientation1) 
            postOption1 = num2cell(postTrialData.postOrientation1(k));
            postOption2 = cellstr(postTrialData.postOrientation2{k});

     elseif iscell(postTrialData.postOrientation1)
            postOption1 = cellstr(postTrialData.postOrientation1{k});
            postOption2 = num2cell(postTrialData.postOrientation2(k));

      end
     
     
    
     
         if  isnumeric(postTrialData.postDurationShort) 
            postShortDuration = num2cell(postTrialData.postDurationShort(k)); %option short
            postLongDuration = cellstr(postTrialData.postDurationLong{k}); 

        elseif iscell(postTrialData.postDurationShort)
            postShortDuration = cellstr(postTrialData.postDurationShort{k});
            postLongDuration = num2cell(postTrialData.postDurationLong(k));

        end
    
    
        correctOptionPostD = cellstr(postTrialData.stimulusDurationPost(k)); %correct duration

    % check the correct option for the stimulus orientation in given post
    % trial
     
        if strcmp(postStim,postStim1)

        correctOptionPostO = postStim1;

    elseif strcmp(postStim,postStim2)

        correctOptionPostO = postStim2;

       end

    
     % chosen Orientation

    if ~isempty(postOption1)
        chosenOptionPostO = postStim1;

    elseif ~isempty(postOption2)
        chosenOptionPostO = postStim2;
    end

    %check whether participant made the right decision

    if strcmp(correctOptionPostO,chosenOptionPostO)

       OrientationAccuracyPost = 1; 

    else
       OrientationAccuracyPost = 0;

    end

% check the stimulus in given post trial 
   
    if ~isempty(postShortDuration)
       chosenOptionPostD = {'short'};
    elseif ~isempty(postLongDuration)
        chosenOptionPostD = {'long'};
    end

%check whether participant made the right choice 

    if strcmp(correctOptionPostD,chosenOptionPostD)
        durationAccuracyPost = 1;
    else
        durationAccuracyPost = 0;
    end

    postOrientationRT = postTrialData.orientationRT - postTrialData.OrientationOnset;
    postOrientationConfidence = postTrialData.confidenceOrientationPostt;
    postOrientationConfRT = postTrialData.confidenceOrientationRT - postTrialData.orientationConfidenceOnset;
    postDurationRT = postTrialData.durationRT; 
    postDurationConfidence = postTrialData.confidenceDurationPostt;
    postDurationConfRT = postTrialData.confidenceDurationRT - postTrialData.durationConfidenceOnset;
    probeOrder = postTrialData.probeOrder;

    trialTable = table(OrientationAccuracyPost,postOrientationRT,postOrientationConfidence, postOrientationConfRT,durationAccuracyPost,postDurationRT,postDurationConfidence,postDurationConfRT,probeOrder,'VariableNames',{'orientationAccuracy','orientationRT','orientationConfidence','orientationConfidenceRT',...
       'durationAccuracy','durationRT','durationConfidence','durationConfidenceRT','probeOrder'});
    
    onePostSurpriseTrial = [onePostSurpriseTrial;trialTable];

    end
    facePostSurpriseTrials{j} =  onePostSurpriseTrial; 
    facePostSurpriseTrials{j}.ParticipantID = repmat((participantID), height(facePostSurpriseTrials{j}), 1); 
 end

 % Pre-surprise object
  for j = 1: numel(objectFolders)
        
     objectFolderPath = objectFolders{j}; %open facefolders
     objectTrialPath = fullfile(objectFolderPath,"trials.csv");
     currentObjectTrial = readtable(objectTrialPath); % access trial data
     participantIDPath = fullfile(objectFolderPath,"sessions.csv");
     participantIDtable = readtable(participantIDPath);
     participantID = participantIDtable.Subject_Code;
       

     preSurpriseTask = currentObjectTrial(strcmp(currentObjectTrial.Task_Name,'objectPre-surprise'),:);
     objectPreSurpriseTrials{j} = preSurpriseTask(:,ObjectPreSurpriseCols);
     objectPreSurpriseTrials{j}.ParticipantID = repmat((participantID), height(objectPreSurpriseTrials{j}), 1); 

  %critical object
  

  ObjectCritical = (preSurpriseTask (:,ObjectCriticalCols));
  nan_rows = all(ismissing(ObjectCritical), 2);
  ObjectCritical = ObjectCritical(~nan_rows, :);

  % critical orientation 

  % define the critical stimulus and options (there is only 1 value)
  criticalStim = cellstr(ObjectCritical.stimulusIDCritical{42});
  Stim1 = cellstr(ObjectCritical.criticalOrientation1Stim{42}); % stim displayed on the left side
  Stim2 = cellstr(ObjectCritical.criticalOrientation2Stim{42}); % stim displayed on the right side
  
  if  isnumeric(ObjectCritical.criticalOrientation1) 
      optionStim1 = num2cell(ObjectCritical.criticalOrientation1(42));
      optionStim2 = cellstr(ObjectCritical.criticalOrientation2{42});

  elseif iscell(ObjectCritical.criticalOrientation1)
      optionStim1 = cellstr(ObjectCritical.criticalOrientation1{42});
      optionStim2 = num2cell(ObjectCritical.criticalOrientation2(42));

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

    correctOptionD = cellstr(ObjectCritical.stimulusDurationCritical{42}); % correct option for given critical trial

        if  isnumeric(ObjectCritical.criticalDurationShort) 
      shortDuration = num2cell(ObjectCritical.criticalDurationShort(42));
      longDuration = cellstr(ObjectCritical.criticalDurationLong{42});

        elseif iscell(ObjectCritical.criticalDurationShort)
      shortDuration = cellstr(ObjectCritical.criticalDurationShort{42});
      longDuration = num2cell(ObjectCritical.criticalDurationLong(42));

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

    orientationRT(j) = ObjectCritical.orientationRT(42) - ObjectCritical.OrientationOnset(42);
    OrientationConfidenceRT(j) = ObjectCritical.confidenceOrientationRT(42) - ObjectCritical.orientationConfidenceOnset(42);
    durationRT(j)= ObjectCritical.durationRT(42);
    DurationConfidenceRT(j) = ObjectCritical.confidenceDurationRT(42)- ObjectCritical.durationConfidenceOnset(42);
    orientationConfidence(j)=ObjectCritical.confidenceOrientationCritical(42);
    durationConfidence(j)= ObjectCritical.confidenceDurationCritical(42);
    mindWanderingQuestion{j} = cellstr(ObjectCritical.mindWanderingQuestion{42});
    mindWanderingRT(j)= ObjectCritical.mindWanderingRT(42);
    
    criticalPerformance = table(OrientationAccuracy(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracy(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});

    objectCriticalTrial{j} = criticalPerformance; 
    objectCriticalTrial{j}.ParticipantID = repmat((participantID), height(objectCriticalTrial{j}), 1);

   % post surprise object


     postSurpriseTask = currentObjectTrial(strcmp(currentObjectTrial.Task_Name,'objectPostSurprise'),:);
     objectPostSurpriseTrials{j} = postSurpriseTask(:,PostSurpriseCols);
     onePostSurpriseTrial = table();

    for k = 1:height(postSurpriseTask)
        
        postTrialData = postSurpriseTask(k, :);

    %define the stimulus and duration for each trial
    
     postStim = cellstr(postTrialData.stimulusIDPost{k}); % correct orientation
     postStim1 = cellstr(postTrialData.postOrientation1Stim{k}); % option on the left
     postStim2 = cellstr(postTrialData.postOrientation2Stim{k}); %option on the right
     
      if  isnumeric(postTrialData.postOrientation1) 
            postOption1 = num2cell(postTrialData.postOrientation1(k));
            postOption2 = cellstr(postTrialData.postOrientation2{k});

     elseif iscell(postTrialData.postOrientation1)
            postOption1 = cellstr(postTrialData.postOrientation1{k});
            postOption2 = num2cell(postTrialData.postOrientation2(k));

      end
     
     
      if  isnumeric(postTrialData.postDurationShort) 
            postShortDuration = num2cell(postTrialData.postDurationShort(k)); %option short
            postLongDuration = cellstr(postTrialData.postDurationLong{k}); 

      elseif iscell(postTrialData.postDurationShort)
            postShortDuration = cellstr(postTrialData.postDurationShort{k});
            postLongDuration = num2cell(postTrialData.postDurationLong(k));

      end
    
    
        correctOptionPostD = cellstr(postTrialData.stimulusDurationPost(k)); %correct duration

    % check the correct option for the stimulus orientation in given post
    % trial
     
        if strcmp(postStim,postStim1)

        correctOptionPostO = postStim1;

    elseif strcmp(postStim,postStim2)

        correctOptionPostO = postStim2;

       end

    
     % chosen Orientation

    if ~isempty(postOption1)
        chosenOptionPostO = postStim1;

    elseif ~isempty(postOption2)
        chosenOptionPostO = postStim2;
    end

    %check whether participant made the right decision

    if strcmp(correctOptionPostO,chosenOptionPostO)

       OrientationAccuracyPost = 1; 

    else
       OrientationAccuracyPost = 0;

    end

% check the stimulus in given post trial 
   
    if ~isempty(postShortDuration)
       chosenOptionPostD = {'short'};
    elseif ~isempty(postLongDuration)
        chosenOptionPostD = {'long'};
    end

%check whether participant made the right choice 

    if strcmp(correctOptionPostD,chosenOptionPostD)
        durationAccuracyPost = 1;
    else
        durationAccuracyPost = 0;
    end

    postOrientationRT = postTrialData.orientationRT - postTrialData.OrientationOnset;
    postOrientationConfidence = postTrialData.confidenceOrientationPostt;
    postOrientationConfRT = postTrialData.confidenceOrientationRT - postTrialData.orientationConfidenceOnset;
    postDurationRT = postTrialData.durationRT; 
    postDurationConfidence = postTrialData.confidenceDurationPostt;
    postDurationConfRT = postTrialData.confidenceDurationRT - postTrialData.durationConfidenceOnset;
    probeOrder = postTrialData.probeOrder;

    trialTable = table(OrientationAccuracyPost,postOrientationRT,postOrientationConfidence, postOrientationConfRT,durationAccuracyPost,postDurationRT,postDurationConfidence,postDurationConfRT,probeOrder,'VariableNames',{'orientationAccuracy','orientationRT','orientationConfidence','orientationConfidenceRT',...
       'durationAccuracy','durationRT','durationConfidence','durationConfidenceRT','probeOrder'});
    
    onePostSurpriseTrial = [onePostSurpriseTrial;trialTable];

    end
    objectPostSurpriseTrials{j} =  onePostSurpriseTrial;
    objectPostSurpriseTrials{j}.ParticipantID = repmat((participantID), height(objectPostSurpriseTrials{j}), 1); 
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

  facePostSurprise = 'facePostSurprise.mat';
  save(fullfile(processedDataIrrelevant,facePostSurprise),'facePostSurpriseTrials');
  objectPostSurprise ='objectPostSurprise.mat';
  save(fullfile(processedDataIrrelevant,facePostSurprise),'objectPostSurpriseTrials');            
 












































  



    

