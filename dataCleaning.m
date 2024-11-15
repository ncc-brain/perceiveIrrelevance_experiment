
%% Clear & open the file

clear
clc
addpath('./')
configIrrelevant;

cd(rawDataComb);
addpath(genpath(rawDataComb)); 

participantFolders = dir(rawDataComb); % open participant files
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

OrientationAccuracyFace = []; % for orientation accuracy 
OrientationAccuracyObject =[];

durationAccuracyFace = []; % for duration accuracy
durationAccuracyObject = [];


% define cols for each part (pre-surprise, critical, postSurprise) 

FacePreSurpriseCols = {'Trial_Nr','conditionFace','orientationFace','orientationFaceTarget','StimulusID','durationFace',...
    'JitterTime','fixationOnset','stimulusOnset', 'emptyFramefixationOnset','reactionTime'};

FaceCriticalCols= {'JitterCritical','stimulusOnsetCritical','reactionTimeCritical','stimulusIDCritical',...
    'fixationOnset100ms','criticalOrientation1Stim','criticalOrientation2Stim','criticalDurationShort','criticalDurationLong',...
    'confidenceDurationCritical','confidenceOrientationCritical','confidenceOrientationRT','confidenceDurationRT','durationConfidenceOnset','durationRT','mindWanderingQuestion','mindWanderingRT',...
    'orientationConfidenceOnset','OrientationOnset','orientationRT','stimulusDurationCritical',...
    'CBcriticalOrientation1','CBcriticalOrientation2'};

% criticalOrientation1Stim : stimulus shown on the left side  
% criticalOrientation2Stim : stimulus shown on the right side 
% CBcriticalOrientation1 : orientation checkbox on the left side 
% CBcriticalOrientation2 : orientation checkbox on the right side 
% criticalDurationShort : duration checkbox for short 
% criticalDurationLong : duration checkbox for long 

% stimulusIDCritical : critical stimulus ID (it matches with the 
% criticalOrientation1Stim or criticalOrientation2Stim.) 
% stimulusDurationCritical : critical stimulus duration 


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

% congruencyCheck : it records the post-surprise groups. 
% Congruent = stimulus shown in the given post-surprise trial is in the same
%group as the target 
% probeOrder = records which probe was asked first (orientation or duration)
% postOrientation1Stim : stimulus shown on the left side 
% probeOrientation2Stim : stimulus shown on the right side 
% postOrientation1 : orientation checkbox on the left side 
% postOrientation2 : orientation checkbox on the right side 
% postDurationShort : duration checkbox for the short 
% postDurationLong : duration checkbox for the long 
% stimulusIDPost : post stimulus ID 
% stimulusDurationPost : post stimulus duration 

%% seperate object and face files
 
for i = 1:numel(participantFolders)


    currentSubject = fullfile(rawDataComb,participantFolders(i).name);
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

%change the format (participant ID is long %Change display format

format long g % for lab subject id 

% in this loop I generate seperate tables for pre-surprise, surprise and
% post-surprise trials. For surprise and post-surprise trials, accuracy of
% responses are also calculated in this loop. 
 
for j = 1: numel(faceFolders) % iterares over face files % 
        
     faceFolderPath = faceFolders{j}; %open facefolders
     faceTrialPath = fullfile(faceFolderPath,"trials.csv");
     currentFaceTrial = readtable(faceTrialPath); % access trial data
     participantIDPath = fullfile(faceFolderPath,"sessions.csv");
     participantIDtable = readtable(participantIDPath);
    
     %participantID = participantIDtable.Subject_Code; % this part is for
     %lab experiment
     
     participantID = participantIDtable.Exp_Subject_Id;   % this added specifically for online experiment    
     disp (participantIDtable.Subject_Nr_Per_Group);
     % Pre-surprise face

  % seperate the data for the pre-surprise trials 
  % this part generates seperate tables for each subject's pre-surprise
  % performance 
        
   preSurpriseTask = currentFaceTrial(strcmp(currentFaceTrial.Task_Name,'facePre-surprise'),:);
   facePreSurpriseTrials{j} = preSurpriseTask(:,FacePreSurpriseCols);
   facePreSurpriseTrials{j}.ParticipantID = repmat((participantID), height(facePreSurpriseTrials{j}), 1);
 

  %critical face 

  %this part calculates the critical face performance also prepares the
  %table for the binomial analysis 

  correctOptionOFace = {}; % correct option for the critical orientation
  chosenOptionOFace= {}; % participant response to critical orientation
  chosenOptionDFace = {}; % participant response for critical duration 
  correctOptionDFace = {}; % correct critical duration

  FaceCritical = table();
  FaceCritical = (preSurpriseTask (:,FaceCriticalCols));

  % critical orientation accuracy 

  % define the critical stimulus and options (there is only 1 value)

       criticalStimFace = cellstr(FaceCritical.stimulusIDCritical{42}); % 42 is the trial number for the critical stimulus. It is embedded inside the pre-surprise trials
       Stim1Face = cellstr(FaceCritical.criticalOrientation1Stim{42}); % stim displayed on the left side
       Stim2Face = cellstr(FaceCritical.criticalOrientation2Stim{42}); % stim displayed on the right side
  
  % get the stimulus ID shown in options 
       
       if  iscell(FaceCritical.CBcriticalOrientation1) 
            optionStim1Face = cellstr(FaceCritical.CBcriticalOrientation1{42});

        else
            optionStim1Face = cellstr(num2str(FaceCritical.CBcriticalOrientation1(42)));

        end
      
        if iscell(FaceCritical.CBcriticalOrientation2) 
          optionStim2Face = cellstr(FaceCritical.CBcriticalOrientation2{42});
        else 
         optionStim2Face = cellstr(num2str(FaceCritical.CBcriticalOrientation2(42)));
        end
 
 
  % compare the critical stimulus ID with given options and find the correct option  

        if strcmp(criticalStimFace,Stim1Face)

                correctOptionOFace = Stim1Face;

        elseif strcmp(criticalStimFace,Stim2Face)

                correctOptionOFace = Stim2Face;

        end

    %   check the checkboxes and find which checkbox was chosen by the
    %   participant 

        if strcmp(optionStim1Face,'true') % 'true' --> checkbox chosen by participant
            chosenOptionOFace = Stim1Face;

        elseif strcmp(optionStim2Face,'true')
            chosenOptionOFace = Stim2Face;
        end

   % compare the correct option ID and ID chosen by the participant  

        if strcmp(correctOptionOFace,chosenOptionOFace)

            OrientationAccuracyFace(j) = 1; % if correct option and chosen ID are same, accuracy = 1 

        else
            OrientationAccuracyFace(j) = 0;  % if correct option and chosen ID are not same, accuracy = 0
    
        end

    % critical duration for face 

    correctOptionDFace = cellstr(FaceCritical.stimulusDurationCritical{42}); % correct option for given critical trial

        if  iscell(FaceCritical.criticalDurationShort) 
      
            shortDurationFace = cellstr(FaceCritical.criticalDurationShort{42});  % duration is short 
      
        elseif ~iscell (FaceCritical.criticalDurationShort)
            shortDurationFace = cellstr(num2str(FaceCritical.criticalDurationShort(42)));
        end
      
        if iscell(FaceCritical.criticalDurationLong) 
        
            longDurationFace = cellstr(FaceCritical.criticalDurationLong{42});  % duration is long 
        else
            longDurationFace = cellstr(num2str(FaceCritical.criticalDurationLong(42)));
        end

      

      % check which option participant chose
        if strcmp(shortDurationFace,'true')  % if participant chose the short duration, it will be shown as 'true'
          chosenOptionDFace = {'short'};
        elseif strcmp(longDurationFace,'true') % if participant chose the long duration, it will be shown as 'true'
          chosenOptionDFace = {'long'};
        end

    %check whether participant made the right choice 

      if strcmp(correctOptionDFace,chosenOptionDFace) % if correct option and participant's option matches --> duration accuracy = 1
         durationAccuracyFace(j) = 1;
     else
         durationAccuracyFace(j) = 0; % if correct option and participant option does not match --> duration accuracy = 0 
      end

   %reaction times 

   %get the accurate reaction times ( calculate the RT starting from the
   %onset of the stimulus rather than frame onset) & confidence ratings 

    orientationRT(j) = FaceCritical.orientationRT(42) - FaceCritical.OrientationOnset(42); % rt when participant gave an answer to orientation probe
    OrientationConfidenceRT(j) = FaceCritical.confidenceOrientationRT(42) - FaceCritical.orientationConfidenceOnset(42); % rt when participant gave confidence to orientation probe
    durationRT(j)= FaceCritical.durationRT(42); %rt when participant gave an answer to duration probe
    DurationConfidenceRT(j) = FaceCritical.confidenceDurationRT(42)- FaceCritical.durationConfidenceOnset(42); %rt when participant gave an answer to duration probe
    orientationConfidence(j)=FaceCritical.confidenceOrientationCritical(42); % confidence given to orientation
    durationConfidence(j)= FaceCritical.confidenceDurationCritical(42); % confidence given to duration
    mindWanderingQuestion{j} = cellstr(FaceCritical.mindWanderingQuestion{42}); % mind-wandering result
    mindWanderingRT(j)= FaceCritical.mindWanderingRT(42); %rt when participant responded mind-wandering 


  criticalPerformanceFace = table(OrientationAccuracyFace(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracyFace(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});
    
   criticalPerformanceFace.probeOrder = {''}; % add probe order as extra variable 

    faceCriticalTrial{j} = criticalPerformanceFace; 
    faceCriticalTrial{j}.ParticipantID = repmat((participantID), height(faceCriticalTrial{j}), 1);
   
    %post surprise face 

     postSurpriseTask = currentFaceTrial(strcmp(currentFaceTrial.Task_Name,'facePostSurprise'),:); % get the current post surprisr 
     facePostSurpriseTrials{j} = postSurpriseTask(:,PostSurpriseCols);
     onePostSurpriseTrial = table();   

    for k = 1:height(postSurpriseTask)

        trialTable = table(); % save each post trial inside this 
        postTrialData = postSurpriseTask(k, :); % get the trial data 

        FacecorrectOptionPostO = {}; % correct option for the post orientation
        FacechosenOptionPostO= {}; % participant response to post orientation
        FacechosenOptionPostD = {}; % participant response for post duration 
        FacecorrectOptionPostD = {}; % correct option for post duration

        FaceOrientationAccuracyPost = []; % save the orientation accuracy results 
        FacedurationAccuracyPost = []; % save the duration accuracy results 

        FacepostStim = {}; % post stimulus ID 
        FacepostStim1 = {}; % post stimulus orientation shown on the left 
        FacepostStim2 = {}; % post stimulus orientation  shown on the right
        FacepostOption1 = {}; % left option chosen
        FacepostOption2 = {}; % right option chosen
        FacepostShortDuration ={}; % short duration
        FacepostLongDuration = {}; % long duration 
    
       
    %get the stimulus orientation and duration for each trial
    
     FacepostStim = cellstr(postTrialData.stimulusIDPost); % correct orientation
     FacepostStim1 = cellstr(postTrialData.postOrientation1Stim); % orientation option on the left
     FacepostStim2 = cellstr(postTrialData.postOrientation2Stim); % orientation option on the right
     
      if  iscell(postTrialData.postOrientation1) 
            FacepostOption1 = cellstr(postTrialData.postOrientation1); %orientation checkbox on the left side (it is either false or true)

      else
            FacepostOption1 = num2str(postTrialData.postOrientation1);

      end

      
      if iscell(postTrialData.postOrientation2)
            FacepostOption2 = cellstr(postTrialData.postOrientation2); %orientation checkbox on the right side (it is false or true) 
      else
            FacepostOption2 = num2str(postTrialData.postOrientation2);
      end

       
         if  iscell(postTrialData.postDurationShort) 

            FacepostShortDuration = cellstr(postTrialData.postDurationShort); % checkbox for the short duration (true or false)
        else
            FacepostShortDuration = num2str(postTrialData.postDurationShort);

        end

        if iscell(postTrialData.postDurationLong)

            FacepostLongDuration = cellstr(postTrialData.postDurationLong);  % checkbox for the long duration (true or false)
       else

            FacepostLongDuration = num2str(postTrialData.postDurationLong);
       end
    
    
    
            FacecorrectOptionPostD = cellstr(postTrialData.stimulusDurationPost); %correct duration (return the cell array either long or short)

    % get the correct option for the stimulus orientation in given post
    % probe by comparing stimulus ID with the options shown on the
    % orientation probe 

        if strcmp(FacepostStim,FacepostStim1) % compare stimulus ID with the option shown on the left side 

        FacecorrectOptionPostO = FacepostStim1;

    elseif strcmp(FacepostStim,FacepostStim2)  % compare stimulus ID with the shown on the right side 

        FacecorrectOptionPostO = FacepostStim2;

       end

    
     % get the chosen orientation

    if strcmp(FacepostOption1,'true')  % the checkbox option returns true is the option chosen by the participant
        FacechosenOptionPostO = FacepostStim1;

    elseif strcmp(FacepostOption2,'true')
        FacechosenOptionPostO = FacepostStim2;
    end

    % check whether participant made the right decision

    if strcmp(FacecorrectOptionPostO,FacechosenOptionPostO) % compare the correct option with the chosen option

       FaceOrientationAccuracyPost(k) = 1; 

    else
       FaceOrientationAccuracyPost(k) = 0;

    end

% get the stimulus duration in given post trial 
   
    if strcmp(FacepostShortDuration,'true') % checkbox option returns true is the checkbox chosen by participant
       FacechosenOptionPostD = {'short'};
    elseif strcmp(FacepostLongDuration,'true')
       FacechosenOptionPostD = {'long'};
    end

% check whether participant made the right choice 

    if strcmp(FacecorrectOptionPostD,FacechosenOptionPostD) % compare the correct option with the chosen option 
        FacedurationAccuracyPost(k) = 1; % if they match, duration accuracy = 1
    else
        FacedurationAccuracyPost(k) = 0; %if they don't match, duration accuracy = 0 
    end


    % get the correct RTs for post-suprise trials & confidence ratings 
    
    postOrientationRT = postTrialData.orientationRT - postTrialData.OrientationOnset; % rt when participant gave an answer to orientation probe
    postOrientationConfidence = postTrialData.confidenceOrientationPostt; % confidence given to orientation answer
    postOrientationConfRT = postTrialData.confidenceOrientationRT - postTrialData.orientationConfidenceOnset; % rt when participant gave a confidence rating to orientation probe
    postDurationRT = postTrialData.durationRT; % rt when participant gave an answer to duration probe
    postDurationConfidence = postTrialData.confidenceDurationPostt; % confidence given to duration answer 
    postDurationConfRT = postTrialData.confidenceDurationRT - postTrialData.durationConfidenceOnset; % rt when participant gave a confidence rating 
    probeOrder = postTrialData.probeOrder; % probe order for the post surprise (orientation or duration first)


    % only for the first control is what we are interested in  

   if postTrialData.congruencyCheck == 1

        controlCongruency = 1;

   else
        controlCongruency = 0;

   end

    trialTable = table(FaceOrientationAccuracyPost(k),postOrientationRT,postOrientationConfidence, postOrientationConfRT,FacedurationAccuracyPost(k),postDurationRT,postDurationConfidence,postDurationConfRT,probeOrder,controlCongruency,'VariableNames',{'orientationAccuracy','orientationRT','orientationConfidence','orientationConfidenceRT',...
       'durationAccuracy','durationRT','durationConfidence','durationConfidenceRT','probeOrder','congruency'});
    
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
     
     %participantID = participantIDtable.Subject_Code; %this part is for
     %lab experiment 

     participantID = participantIDtable.Exp_Subject_Id;
     disp(participantIDtable.Subject_Nr_Per_Group);  
    % get the pre-surprise trials 
     preSurpriseTask = currentObjectTrial(strcmp(currentObjectTrial.Task_Name,'objectPre-surprise'),:);
     objectPreSurpriseTrials{j} = preSurpriseTask(:,ObjectPreSurpriseCols);
     objectPreSurpriseTrials{j}.ParticipantID = repmat((participantID), height(objectPreSurpriseTrials{j}), 1); 

  %critical object
 
  ObjectCritical = (preSurpriseTask (:,ObjectCriticalCols));

  % critical orientation 

  correctOptionO = {}; % correct option for the critical orientation
  chosenOptionO= {}; % participant response to critical orientation
  chosenOptionD = {}; % participant response for critical duration 
  correctOptionD = {}; % correct critical duration


  % define the critical stimulus and options 
  
  criticalStim = cellstr(ObjectCritical.stimulusIDCritical{42});
  Stim1 = cellstr(ObjectCritical.criticalOrientation1Stim{42}); % stim displayed on the left side
  Stim2 = cellstr(ObjectCritical.criticalOrientation2Stim{42}); % stim displayed on the right side
  
        if  iscell(ObjectCritical.criticalOrientation1) % options can return true or false. 

            optionStim1 = cellstr(ObjectCritical.criticalOrientation1{42});

        else
            optionStim1 = cellstr(num2str(ObjectCritical.criticalOrientation1(42)));

        end
      
        if iscell(ObjectCritical.criticalOrientation2) 

          optionStim2 = cellstr(ObjectCritical.criticalOrientation2{42});
        else 

          optionStim2 = cellstr(num2str(ObjectCritical.criticalOrientation2(42)));
        end


 
  
  % find the correct option for critical orientation 

        if strcmp(criticalStim,Stim1) % compare critical stim ID with the ID of stim displayed on the left side

                correctOptionO = Stim1;

        elseif strcmp(criticalStim,Stim2) % compare critical stim ID with the ID of stim displayed on the right side

                correctOptionO = Stim2;

        end

    %find which stim participant chose 

        if strcmp(optionStim1,'true')  % option return true is the one that is chosen by participant 
            chosenOptionO = Stim1;

        elseif strcmp(optionStim2,'true')
            chosenOptionO = Stim2;
        end

   % check whether participant chose the correct option 

        if strcmp(correctOptionO,chosenOptionO) % compare the correct option with the chosen option

            OrientationAccuracyObject(j) = 1; %if they match, accuracy = 1

        else
            OrientationAccuracyObject(j) = 0; % if they don't match, accuracy = 0
    
        end

    % critical duration for object 

    correctOptionD = cellstr(ObjectCritical.stimulusDurationCritical{42}); % correct option for given critical trial

    % get the duration checkbox results (either true or false)
    
        if  iscell(ObjectCritical.criticalDurationShort) 
      
            shortDuration = cellstr(ObjectCritical.criticalDurationShort{42}); %checkbox for short duration
      
        else
            shortDuration = cellstr(num2str(ObjectCritical.criticalDurationShort(42)));
        end
      
        if iscell(ObjectCritical.criticalDurationLong) 
        
            longDuration = cellstr(ObjectCritical.criticalDurationLong{42}); %checkbox for the long duration
        else
            longDuration = cellstr(num2str(ObjectCritical.criticalDurationLong(42)));
        end

      % check which option participant chose
        
        if strcmp(shortDuration,'true')  % checkbox returns true is the checkbox participant selected
          chosenOptionD = {'short'};
        elseif strcmp(longDuration,'true')
          chosenOptionD = {'long'};
        end

    % compare participant response with chosen response

      if strcmp(correctOptionD,chosenOptionD)
         durationAccuracyObject(j) = 1; %if they match, duration accuracy = 1
     else
         durationAccuracyObject(j) = 0; % if they don't match, duration accuracy = 0
      end

   % get accurate reaction times & confidence ratings 

    orientationRT(j) = ObjectCritical.orientationRT(42) - ObjectCritical.OrientationOnset(42); 
    OrientationConfidenceRT(j) = ObjectCritical.confidenceOrientationRT(42) - ObjectCritical.orientationConfidenceOnset(42);
    durationRT(j)= ObjectCritical.durationRT(42);
    DurationConfidenceRT(j) = ObjectCritical.confidenceDurationRT(42)- ObjectCritical.durationConfidenceOnset(42);
    orientationConfidence(j)=ObjectCritical.confidenceOrientationCritical(42);
    durationConfidence(j)= ObjectCritical.confidenceDurationCritical(42);
    mindWanderingQuestion{j} = cellstr(ObjectCritical.mindWanderingQuestion{42});
    mindWanderingRT(j)= ObjectCritical.mindWanderingRT(42);
    
    criticalPerformanceObject = table(OrientationAccuracyObject(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracyObject(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});

    criticalPerformanceObject.probeOrder = {''}; % add probe order as extra variable 

    objectCriticalTrial{j} = criticalPerformanceObject; 
    objectCriticalTrial{j}.ParticipantID = repmat((participantID), height(objectCriticalTrial{j}), 1);

   % post surprise object

     postSurpriseTask = currentObjectTrial(strcmp(currentObjectTrial.Task_Name,'objectPostSurprise'),:);
     objectPostSurpriseTrials{j} = postSurpriseTask(:,PostSurpriseCols);
     onePostSurpriseTrial = table();


    for k = 1:height(postSurpriseTask)
        
        trialTable = table();
        postTrialData = postSurpriseTask(k, :);

        correctOptionPostO = {}; % correct option for the post orientation
        chosenOptionPostO= {}; % participant response to post orientation
        chosenOptionPostD = {}; % participant response for post duration 
        correctOptionPostD = {}; % correct critical duration
        
        postStim = {}; % post stimulus ID
        postStim1 = {}; %post stim ID shown on the left side
        postStim2 = {}; %post stim ID shown on the right side 
        postOption1 = {}; % orientation checkbox on the left side 
        postOption2 = {}; %orientation checkbox on the right side 
        postShortDuration ={}; %checkbox for short duration 
        postLongDuration = {}; %checkbox for long duration 
 
        OrientationAccuracyPost = []; %save the post orientation accuracy here
        durationAccuracyPost = []; %save the post duration accuracy here 

    %define the stimulus and duration for each trial
    
     postStim = cellstr(postTrialData.stimulusIDPost); % correct orientation
     postStim1 = cellstr(postTrialData.postOrientation1Stim); % option on the left
     postStim2 = cellstr(postTrialData.postOrientation2Stim); %option on the right
     
      if  iscell(postTrialData.postOrientation1) 
           postOption1 = cellstr(postTrialData.postOrientation1); % get the options (returns true or false)

      else
           postOption1 = num2str(postTrialData.postOrientation1);

      end

      
      if iscell(postTrialData.postOrientation2)
         postOption2 = cellstr(postTrialData.postOrientation2);
      else
         postOption2 = num2str(postTrialData.postOrientation2);
      end
              
     % get the duration checkboxes ( returns either true or false) 

      if  iscell(postTrialData.postDurationShort) 

            postShortDuration = cellstr(postTrialData.postDurationShort); %checkbox for short 
      else
            postShortDuration = num2str(postTrialData.postDurationShort);

      end

      if iscell(postTrialData.postDurationLong)

            postLongDuration = cellstr(postTrialData.postDurationLong); %checkbox for long 
      else

            postLongDuration = num2str(postTrialData.postDurationLong);
      end
    
    
      correctOptionPostD = cellstr(postTrialData.stimulusDurationPost); %correct duration

    % compare the stim ID with options to get the correct option
     
        if strcmp(postStim,postStim1)

        correctOptionPostO = postStim1;

    elseif strcmp(postStim,postStim2)

        correctOptionPostO = postStim2;

       end

    
     % get chosen orientation

    if strcmp(postOption1,'true') %checkbox returns true is the one chosen by the participant
        chosenOptionPostO = postStim1;

    elseif strcmp(postOption2,'true')
        chosenOptionPostO = postStim2;
    end

    % compare participant response with the correct option 

    if strcmp(correctOptionPostO,chosenOptionPostO)

       OrientationAccuracyPost(k) = 1; 

    else
       OrientationAccuracyPost(k) = 0;

    end

% get the stimulus duration in given post trial 
   
    if strcmp(postShortDuration,'true')
       chosenOptionPostD = {'short'};
    elseif strcmp(postLongDuration,'true')
        chosenOptionPostD = {'long'};
    end

% compare participant response with the correct duration 

    if strcmp(correctOptionPostD,chosenOptionPostD)
        durationAccuracyPost(k) = 1;
    else
        durationAccuracyPost(k) = 0;
    end

    %get the rt % confidence ratings 

    postOrientationRT = postTrialData.orientationRT - postTrialData.OrientationOnset;
    postOrientationConfidence = postTrialData.confidenceOrientationPostt;
    postOrientationConfRT = postTrialData.confidenceOrientationRT - postTrialData.orientationConfidenceOnset;
    postDurationRT = postTrialData.durationRT; 
    postDurationConfidence = postTrialData.confidenceDurationPostt;
    postDurationConfRT = postTrialData.confidenceDurationRT - postTrialData.durationConfidenceOnset;
    probeOrder = postTrialData.probeOrder;

   % get the probe order

   if postTrialData.congruencyCheck == 1

        controlCongruency = 1;

   else
       controlCongruency = 0;

   end

    trialTable = table(OrientationAccuracyPost(k),postOrientationRT,postOrientationConfidence, postOrientationConfRT,durationAccuracyPost(k),postDurationRT,postDurationConfidence,postDurationConfRT,probeOrder,controlCongruency,'VariableNames',{'orientationAccuracy','orientationRT','orientationConfidence','orientationConfidenceRT',...
       'durationAccuracy','durationRT','durationConfidence','durationConfidenceRT','probeOrder','congruency'});
    
    onePostSurpriseTrial = [onePostSurpriseTrial;trialTable]; % each post-surprise consists of 4 trials. Save them here

    end

    objectPostSurpriseTrials{j} =  onePostSurpriseTrial;
    objectPostSurpriseTrials{j}.ParticipantID = repmat((participantID), height(objectPostSurpriseTrials{j}), 1); 

 end


%get the probe order (only saved for the post-surprise & it is same as
%critical trial) 

subOrientationFirstFace = {}; % face subjects orientation asked first
subDurationFirstFace = {};  % face subjects duration asked first

subOrientationFirstObject = {}; % object subjects orientation asked first
subDurationFirstObject = {};  % object subjects duration asked first

%in case object and face trials are not same size 

maxNumber = max(numel(facePostSurpriseTrials),numel(objectPostSurpriseTrials));

for i = 1:maxNumber %nr of trials for face and object are equal 

     if i <= numel(facePostSurpriseTrials)
        currentFaceSubject = facePostSurpriseTrials{i};
     
   if strcmp(currentFaceSubject.probeOrder,'orientationFirsr') % orientationFirsr --> typo during the recording ( stands for orientation First) 
       subOrientationFirstFace{end+1} = currentFaceSubject.ParticipantID(1); % subject number orientation probed first
       currentFaceSubject.probeOrder =  repmat({'orientationFirst'}, height(currentFaceSubject.probeOrder), 1); % fix the typo 

   elseif strcmp(currentFaceSubject.probeOrder,'durationFirst')
       subDurationFirstFace{end+1} = currentFaceSubject.ParticipantID(1); %subject number duration probed first
       
   end
        facePostSurpriseTrials{i} = currentFaceSubject; % update the cell without typo 

     end

   if i <= numel(objectPostSurpriseTrials)

           currentObjectSubject = objectPostSurpriseTrials{i};

   if strcmp(currentObjectSubject.probeOrder,'orientationFirst')
       subOrientationFirstObject{end+1} = currentObjectSubject.ParticipantID(1);

   elseif strcmp(currentObjectSubject.probeOrder,'durationFirst')
       subDurationFirstObject{end+1} = currentObjectSubject.ParticipantID(1);

   end

   end  
 
end




% save the probe order in critical trials using the participant numbers 

for j = 1:maxNumber % same nr for objects 
    
     if j <= numel(faceCriticalTrial)

   currentFaceCritical = faceCriticalTrial{j};
   

       %critical data orientation probed first 
    if  any(cellfun(@(x) isequal(x, currentFaceCritical.ParticipantID),subOrientationFirstFace)) 
        currentFaceCritical.probeOrder ={'orientationFirst'};
    end  
    % critical data duration probed first
    if  any(cellfun(@(x) isequal(x, currentFaceCritical.ParticipantID),subDurationFirstFace))
       currentFaceCritical.probeOrder = {'durationFirst'};
    end
     faceCriticalTrial{j} = currentFaceCritical;  % update your tables 
     end
    
     if j <= numel(objectCriticalTrial)
    
         currentObjectCritical = objectCriticalTrial{j};

     if  any(cellfun(@(x) isequal(x, currentObjectCritical.ParticipantID),subOrientationFirstObject))
       currentObjectCritical.probeOrder = {'orientationFirst'};
     end
    
    % critical data duration probed first
    if  any(cellfun(@(x) isequal(x, currentObjectCritical.ParticipantID), subDurationFirstObject))        
      currentObjectCritical.probeOrder = {'durationFirst'};
    end
 
    objectCriticalTrial{j} = currentObjectCritical; % update your tables
     end

     end

% convert tables into one table 

%face table 

criticalTableFace = vertcat(faceCriticalTrial{:});
criticalTableFace.groupName = repmat({'face'}, height(criticalTableFace), 1); %add group name 

%object table 

criticalTableObject = vertcat(objectCriticalTrial{:});
criticalTableObject.groupName = repmat({'object'},height(criticalTableObject),1); %add group name

criticalTable = [criticalTableFace;criticalTableObject]; % combine tables 


%face post-table

postTableFace = vertcat(facePostSurpriseTrials{:});
postTableFace.groupName =  repmat({'face'}, height(postTableFace), 1);

%object post-table 

postTableObject = vertcat (objectPostSurpriseTrials{:});
postTableObject.groupName =  repmat({'object'}, height(postTableObject), 1);


postTable = [postTableFace;postTableObject];

%generate accuracy tables for future accuracy analysis 

nrOfProbes = height(criticalTable); %this stands for one specific probe (orientation or duration) - nr of orientation & duration are equal
nrOfProbesOneGroup = sum(strcmp(criticalTable.groupName,'object')); %this  stands for one specific probe in one group (e.g. total orientation probes in object group), number of specific probes in one group are equal

correctOrientation = sum(criticalTable.orientationPerformance == 1);
correctDuration = sum(criticalTable.durationPerformance == 1);

incorrectOrientation = sum(criticalTable.orientationPerformance==0);
incorrectDuration = sum(criticalTable.durationPerformance == 0);

correctFaceOrientation = sum(strcmp(criticalTable.groupName,'face') & criticalTable.orientationPerformance==1);
correctFaceDuration = sum(strcmp(criticalTable.groupName,'face') & criticalTable.durationPerformance==1);

incorrectFaceOrientation = sum(strcmp(criticalTable.groupName,'face') & criticalTable.orientationPerformance==0);
incorrectFaceDuration = sum(strcmp(criticalTable.groupName,'face') & criticalTable.durationPerformance==0);

correctObjectOrientation  = sum(strcmp(criticalTable.groupName,'object') & criticalTable.orientationPerformance==1);
correctObjectDuration = sum(strcmp(criticalTable.groupName,'object') & criticalTable.durationPerformance==1);

incorrectObjectOrientation = sum(strcmp(criticalTable.groupName,'object') & criticalTable.orientationPerformance==0);
incorrectObjectDuration = sum(strcmp(criticalTable.groupName,'object') & criticalTable.durationPerformance==0);

criticalAccuracyTable = table(nrOfProbes,nrOfProbesOneGroup,correctOrientation,correctDuration,incorrectOrientation,incorrectDuration,correctFaceOrientation,...
    correctFaceDuration,incorrectFaceOrientation,incorrectFaceDuration,correctObjectOrientation,correctObjectDuration,...
    incorrectObjectOrientation,incorrectObjectDuration,'VariableNames',{'nrOfProbes','nrOfProbesOneGroup','correctOrientation','correctDuration','incorrectOrientation','incorrectDuration','correctFaceOrientation',...
    'correctFaceDuration','incorrectFaceOrientation','incorrectFaceDuration','correctObjectOrientation','correctObjectDuration','incorrectObjectOrientation','incorrectObjectDuration'});


%post accuracy 

uniqueParticipants = unique(postTable.ParticipantID); % get accuracy for each row of each participant 
disp(uniqueParticipants)

numTrials = 4; % each post-suprise has 4 trials. 

orientationGroups = cell(1, numTrials);
durationGroups = cell(1,numTrials);
congruencyTable = []; % I added this to save congruency and each participants orientation and duration scores for the first control

for i = 1:numel(uniqueParticipants) 

     currentParticipant = uniqueParticipants(i); % get the current participant

         participantData=postTable(postTable.ParticipantID == currentParticipant,:); %combined Data 
     
     for j = 1:numTrials

         orientationGroups{i,j} = participantData.orientationAccuracy(j); % get orientation for 4 trials
         
         durationGroups{i,j} =  participantData.durationAccuracy(j); % get duration for 4 trials          
         
     end

      % congruency Table 
        
         congruencyRow = table(participantData.congruency(1),participantData.groupName(1),participantData.orientationAccuracy(1),participantData.durationAccuracy(1),participantData.ParticipantID(1),'VariableNames',{'congruency','group','orientationControlAccuracy','durationControlAccuracy','ParticipantID'});

         congruencyTable = vertcat(congruencyTable, congruencyRow);
          
        
        groupNames{i} = participantData.groupName{1};
end
    
        groupNames = groupNames';

        % add group names to the post-surprise tables 

        for i = 1:height(groupNames)
         orientationGroup(i, :) = [orientationGroups(i, :),  groupNames(i)];
         durationGroup(i,:) = [durationGroups(i,:),groupNames(i)];
        end

        orientationGroup = cell2table(orientationGroup); % includes the name of the cell
        durationGroup = cell2table(durationGroup); % includes the name of the cell
% get accuracy numbers for post-surprise 

        variableNames = {'control1','control2','control3','control4'};

        correctOrientation = sum(orientationGroup(:,1:end-1)==1);
        correctOrientation.Properties.VariableNames = variableNames; % make it ready to combine them all in one table 
        
        correctDuration = sum(durationGroup(:,1:end-1)==1);
        correctDuration.Properties.VariableNames = variableNames; 

        falseOrientation = sum(orientationGroup(:,1:end-1)==0);
        falseOrientation.Properties.VariableNames = variableNames; 

        falseDuration = sum(durationGroup(:,1:end-1)==0);
        falseDuration.Properties.VariableNames = variableNames; 

        correctFaceOrientation = array2table(sum((orientationGroup{:,1:end-1} == 1) & strcmp(orientationGroup.orientationGroup5, 'face')));
        correctFaceOrientation.Properties.VariableNames = variableNames; 
        
        correctFaceDuration =  array2table(sum((durationGroup{:,1:end-1} == 1) & strcmp(durationGroup.durationGroup5, 'face')));
        correctFaceDuration.Properties.VariableNames = variableNames; 
        
        falseFaceOrientation = array2table(sum((orientationGroup{:,1:end-1} == 0) & strcmp(orientationGroup.orientationGroup5, 'face')));
        falseFaceOrientation.Properties.VariableNames = variableNames; 
        
        falseFaceDuration = array2table(sum((durationGroup{:,1:end-1} == 0) & strcmp(durationGroup.durationGroup5, 'face')));
        falseFaceDuration.Properties.VariableNames = variableNames; 


        correctObjectOrientation = array2table(sum((orientationGroup{:,1:end-1} == 1) & strcmp(orientationGroup.orientationGroup5, 'object')));
        correctObjectOrientation.Properties.VariableNames = variableNames; 
        
        correctObjectDuration = array2table(sum((durationGroup{:,1:end-1} == 1) & strcmp(durationGroup.durationGroup5, 'object')));
        correctObjectDuration.Properties.VariableNames = variableNames; 
        
        falseObjectOrientation = array2table(sum((orientationGroup{:,1:end-1} == 0) & strcmp(orientationGroup.orientationGroup5, 'object')));
        falseObjectOrientation.Properties.VariableNames = variableNames; 
        
        falseObjectDuration = array2table(sum((durationGroup{:,1:end-1} == 0) & strcmp(durationGroup.durationGroup5, 'object')));
        falseObjectDuration.Properties.VariableNames = variableNames; 

        
        postAccuracyTable = rows2vars([correctOrientation;correctDuration;falseOrientation;falseDuration;correctFaceOrientation;correctFaceDuration;falseFaceOrientation;falseFaceDuration;correctObjectOrientation;...
            correctObjectDuration;falseObjectOrientation;falseObjectDuration]);
      

        colNames = {'controlGroups','correctOrientation','correctDuration','falseOrientation','falseDuration','correctFaceOrientation','correctFaceDuration','falseFaceOrientation','falseFaceDuration','correctObjectOrientation',...
           'correctObjectDuration','falseObjectOrientation','falseObjectDuration'};      

        postAccuracyTable.Properties.VariableNames=colNames; % add the variable names

        
        % add the number of probes (same as the critical) to the postAccuracyTable  
        
        postNrOfProbes = repmat(nrOfProbes,height(postAccuracyTable),1);
        postNrOfProbesGroup = repmat(nrOfProbesOneGroup,height(postAccuracyTable),1); 

        postAccuracyTable = addvars(postAccuracyTable, postNrOfProbes, 'NewVariableNames', 'nrOfProbes');
        postAccuracyTable = addvars(postAccuracyTable, postNrOfProbesGroup, 'NewVariableNames', 'nrOfProbesOneGroup');
   

        % compare performance with order effect 

   orientationFirstRow = strcmp(criticalTable.probeOrder, 'orientationFirst');
   durationFirstRow = strcmp(criticalTable.probeOrder,'durationFirst');
   
   orientationFirst = (criticalTable.orientationPerformance(orientationFirstRow))'; % orientation performance if orientation first
   durationFirst = (criticalTable.durationPerformance(durationFirstRow))'; % duration performance if duration first

   orientationSecond = (criticalTable.orientationPerformance(durationFirstRow))';
   durationSecond = (criticalTable.durationPerformance(orientationFirstRow))'; 


   % if it is not same size, replace empty cells with NaN (I added this to
   % test while the full dataset is not collected.

   maxLength = max([length(orientationFirst), length(durationFirst), length(orientationSecond), length(durationSecond)]);

   % Add NaN to the empty cells 
    orientationFirst = [orientationFirst, NaN(1, maxLength - length(orientationFirst))];
    durationFirst = [durationFirst, NaN(1, maxLength - length(durationFirst))];
    orientationSecond = [orientationSecond, NaN(1, maxLength - length(orientationSecond))];
    durationSecond = [durationSecond, NaN(1, maxLength - length(durationSecond))];
  
   %save the order effect results 
   orderEffect = table(orientationFirst',durationFirst',orientationSecond',durationSecond','VariableNames',{'orientationFirst','durationFirst','orientationSecond','durationSecond'});
 




%Save the files '
%pre-surprise file
facePreSurprise = 'facePreSurprise.mat';
save(fullfile(processedDataComb,facePreSurprise),'facePreSurpriseTrials');
objectPreSurprise = 'objectPreSurprise.mat';
save(fullfile(processedDataComb,objectPreSurprise),'objectPreSurpriseTrials');

%critical file
criticalTableName = 'criticalTable.mat';
save(fullfile(processedDataComb,criticalTableName),'criticalTable');

%post surprise file 
postTableName = 'postTable.mat';
save(fullfile(processedDataComb,postTableName),'postTable');

%accuracy files 
criticalAccuracyTableFile = 'criticalAccuracyTable.mat';
save(fullfile(processedDataComb,criticalAccuracyTableFile),'criticalAccuracyTable');

postAccuracyTableFile= 'postAccuracyTable.mat';
save(fullfile(processedDataComb,postAccuracyTableFile),'postAccuracyTable');

%orderEffect
orderEffectName = 'orderEffect.mat';
   save(fullfile(processedDataComb,orderEffectName),'orderEffect');

%congruencyTable

congruencyTableName = 'congruencyControl';
  save(fullfile(processedDataComb,congruencyTableName),'');








































  



    

