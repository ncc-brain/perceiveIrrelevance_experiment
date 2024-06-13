
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

  correctOptionOFace = {}; % correct option for the critical orientation
  chosenOptionOFace= {}; % participant response to critical orientation
  chosenOptionDFace = {}; % participant response for critical duration 
  correctOptionDFace = {}; % correct critical duration

  FaceCritical = table();
  FaceCritical = (preSurpriseTask (:,FaceCriticalCols));

  % critical orientation 

  % define the critical stimulus and options (there is only 1 value)

  
       criticalStimFace = cellstr(FaceCritical.stimulusIDCritical{42});
       Stim1Face = cellstr(FaceCritical.criticalOrientation1Stim{42}); % stim displayed on the left side
       Stim2Face = cellstr(FaceCritical.criticalOrientation2Stim{42}); % stim displayed on the right side
  
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

 

 
  % find the correct option for 

        if strcmp(criticalStimFace,Stim1Face)

                correctOptionOFace = Stim1Face;

        elseif strcmp(criticalStimFace,Stim2Face)

                correctOptionOFace = Stim2Face;

        end

    %find which stim participant chose 

        if strcmp(optionStim1Face,'true')
            chosenOptionOFace = Stim1Face;

        elseif strcmp(optionStim2Face,'true')
            chosenOptionOFace = Stim2Face;
        end

   % check whether participant chose the correct option 

        if strcmp(correctOptionOFace,chosenOptionOFace)

            OrientationAccuracyFace(j) = 1; 

        else
            OrientationAccuracyFace(j) = 0;
    
        end

    % critical duration 

    correctOptionDFace = cellstr(FaceCritical.stimulusDurationCritical{42}); % correct option for given critical trial

        if  iscell(FaceCritical.criticalDurationShort) 
      
            shortDurationFace = cellstr(FaceCritical.criticalDurationShort{42});
      
        elseif ~iscell (FaceCritical.criticalDurationShort)
            shortDurationFace = cellstr(num2str(FaceCritical.criticalDurationShort(42)));
        end
      
        if iscell(FaceCritical.criticalDurationLong) 
        
            longDurationFace = cellstr(FaceCritical.criticalDurationLong{42});
        else
            longDurationFace = cellstr(num2str(FaceCritical.criticalDurationLong(42)));
        end

      

      % check which option participant chose
        if strcmp(shortDurationFace,'true')
          chosenOptionDFace = {'short'};
        elseif strcmp(longDurationFace,'true')
          chosenOptionDFace = {'long'};
        end

    %check whether participant made the right choice 

      if strcmp(correctOptionDFace,chosenOptionDFace)
         durationAccuracyFace(j) = 1;
     else
         durationAccuracyFace(j) = 0;
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
    
    criticalPerformance = table(OrientationAccuracyFace(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracyFace(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});

    faceCriticalTrial{j} = criticalPerformance; 
    faceCriticalTrial{j}.ParticipantID = repmat((participantID), height(faceCriticalTrial{j}), 1);


    %post surprise face 

     postSurpriseTask = currentFaceTrial(strcmp(currentFaceTrial.Task_Name,'facePostSurprise'),:);
     facePostSurpriseTrials{j} = postSurpriseTask(:,PostSurpriseCols);
     onePostSurpriseTrial = table();

      

    for k = 1:height(postSurpriseTask)

        trialTable = table();
        postTrialData = postSurpriseTask(k, :);

        FacecorrectOptionPostO = {}; % correct option for the critical orientation
        FacechosenOptionPostO= {}; % participant response to critical orientation
        FacechosenOptionPostD = {}; % participant response for critical duration 
        FacecorrectOptionPostD = {}; % correct critical duration

        FaceOrientationAccuracyPost = [];
        FacedurationAccuracyPost = [];

        FacepostStim = {};
        FacepostStim1 = {};
        FacepostStim2 = {};
        FacepostOption1 = {};
        FacepostOption2 = {};
        FacepostShortDuration ={};
        FaceLongDuration = {};
    
       
    %define the stimulus and duration for each trial
    
     FacepostStim = cellstr(postTrialData.stimulusIDPost); % correct orientation
     FacepostStim1 = cellstr(postTrialData.postOrientation1Stim); % option on the left
     FacepostStim2 = cellstr(postTrialData.postOrientation2Stim); %option on the right
     
      if  iscell(postTrialData.postOrientation1) 
            FacepostOption1 = cellstr(postTrialData.postOrientation1);

      else
           FacepostOption1 = num2str(postTrialData.postOrientation1);

      end

      
      if iscell(postTrialData.postOrientation2)
         FacepostOption2 = cellstr(postTrialData.postOrientation2);
      else
         FacepostOption2 = num2str(postTrialData.postOrientation2);
      end

       
         if  iscell(postTrialData.postDurationShort) 

            FacepostShortDuration = cellstr(postTrialData.postDurationShort);
        else
            FacepostShortDuration = num2str(postTrialData.postDurationShort);

        end

        if iscell(postTrialData.postDurationLong)

            FacepostLongDuration = cellstr(postTrialData.postDurationLong);
       else

            FacepostLongDuration = num2str(postTrialData.postDurationLong);
       end
    
    
    
        FacecorrectOptionPostD = cellstr(postTrialData.stimulusDurationPost); %correct duration

    % check the correct option for the stimulus orientation in given post
    % trial
     
        if strcmp(FacepostStim,FacepostStim1)

        FacecorrectOptionPostO = FacepostStim1;

    elseif strcmp(FacepostStim,FacepostStim2)

        FacecorrectOptionPostO = FacepostStim2;

       end

    
     % chosen Orientation

    if strcmp(FacepostOption1,'true')
        FacechosenOptionPostO = FacepostStim1;

    elseif strcmp(FacepostOption2,'true')
        FacechosenOptionPostO = FacepostStim2;
    end

    %check whether participant made the right decision

    if strcmp(FacecorrectOptionPostO,FacechosenOptionPostO)

       FaceOrientationAccuracyPost(k) = 1; 

    else
       FaceOrientationAccuracyPost(k) = 0;

    end

% check the stimulus in given post trial 
   
    if strcmp(FacepostShortDuration,'true')
       FacechosenOptionPostD = {'short'};
    elseif strcmp(FacepostLongDuration,'true')
       FacechosenOptionPostD = {'long'};
    end

%check whether participant made the right choice 

    if strcmp(FacecorrectOptionPostD,FacechosenOptionPostD)
        FacedurationAccuracyPost(k) = 1;
    else
        FacedurationAccuracyPost(k) = 0;
    end

    postOrientationRT = postTrialData.orientationRT - postTrialData.OrientationOnset;
    postOrientationConfidence = postTrialData.confidenceOrientationPostt;
    postOrientationConfRT = postTrialData.confidenceOrientationRT - postTrialData.orientationConfidenceOnset;
    postDurationRT = postTrialData.durationRT; 
    postDurationConfidence = postTrialData.confidenceDurationPostt;
    postDurationConfRT = postTrialData.confidenceDurationRT - postTrialData.durationConfidenceOnset;
    probeOrder = postTrialData.probeOrder;

    trialTable = table(FaceOrientationAccuracyPost(k),postOrientationRT,postOrientationConfidence, postOrientationConfRT,FacedurationAccuracyPost(k),postDurationRT,postDurationConfidence,postDurationConfRT,probeOrder,'VariableNames',{'orientationAccuracy','orientationRT','orientationConfidence','orientationConfidenceRT',...
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

  % critical orientation 

  correctOptionO = {}; % correct option for the critical orientation
  chosenOptionO= {}; % participant response to critical orientation
  chosenOptionD = {}; % participant response for critical duration 
  correctOptionD = {}; % correct critical duration


  % define the critical stimulus and options (there is only 1 value)
  criticalStim = cellstr(ObjectCritical.stimulusIDCritical{42});
  Stim1 = cellstr(ObjectCritical.criticalOrientation1Stim{42}); % stim displayed on the left side
  Stim2 = cellstr(ObjectCritical.criticalOrientation2Stim{42}); % stim displayed on the right side
  
        if  iscell(ObjectCritical.criticalOrientation1) 

            optionStim1 = cellstr(ObjectCritical.criticalOrientation1{42});

        else
            optionStim1 = cellstr(num2str(ObjectCritical.criticalOrientation1(42)));

        end
      
        if iscell(ObjectCritical.criticalOrientation2) 

          optionStim2 = cellstr(ObjectCritical.criticalOrientation2{42});
        else 

          optionStim2 = cellstr(num2str(ObjectCritical.criticalOrientation2(42)));
        end


 
  
  % find the correct option for 

        if strcmp(criticalStim,Stim1)

                correctOptionO = Stim1;

        elseif strcmp(criticalStim,Stim2)

                correctOptionO = Stim2;

        end

    %find which stim participant chose 

        if strcmp(optionStim1,'true') 
            chosenOptionO = Stim1;

        elseif strcmp(optionStim2,'true')
            chosenOptionO = Stim2;
        end

   % check whether participant chose the correct option 

        if strcmp(correctOptionO,chosenOptionO)

            OrientationAccuracyObject(j) = 1; 

        else
            OrientationAccuracyObject(j) = 0;
    
        end

    % critical duration 

    correctOptionD = cellstr(ObjectCritical.stimulusDurationCritical{42}); % correct option for given critical trial

        if  iscell(ObjectCritical.criticalDurationShort) 
      
            shortDuration = cellstr(ObjectCritical.criticalDurationShort{42});
      
        else
            shortDuration = cellstr(num2str(ObjectCritical.criticalDurationShort(42)));
        end
      
        if iscell(ObjectCritical.criticalDurationLong) 
        
            longDuration = cellstr(ObjectCritical.criticalDurationLong{42});
        else
            longDuration = cellstr(num2str(ObjectCritical.criticalDurationLong(42)));
        end

      % check which option participant chose
        if strcmp(shortDuration,'true')
          chosenOptionD = {'short'};
        elseif strcmp(longDuration,'true')
          chosenOptionD = {'long'};
        end

    %check whether participant made the right choice 

      if strcmp(correctOptionD,chosenOptionD)
         durationAccuracyObject(j) = 1;
     else
         durationAccuracyObject(j) = 0;
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
    
    criticalPerformance = table(OrientationAccuracyObject(j),orientationRT(j),orientationConfidence(j),OrientationConfidenceRT(j),durationAccuracyObject(j),durationRT(j),durationConfidence(j),...
    DurationConfidenceRT(j),mindWanderingQuestion{j},mindWanderingRT(j),'VariableNames',{'orientationPerformance','orientationRT','orientationConfidence','orientationConfidenceRT','durationPerformance',...
    'durationRT','durationConfidence','durationConfidenceRT','mindwandering','mindwanderingRT'});

    objectCriticalTrial{j} = criticalPerformance; 
    objectCriticalTrial{j}.ParticipantID = repmat((participantID), height(objectCriticalTrial{j}), 1);

   % post surprise object


     postSurpriseTask = currentObjectTrial(strcmp(currentObjectTrial.Task_Name,'objectPostSurprise'),:);
     objectPostSurpriseTrials{j} = postSurpriseTask(:,PostSurpriseCols);
     onePostSurpriseTrial = table();

     OrientationAccuracyPost = [];
     durationAccuracyPost = [];


    for k = 1:height(postSurpriseTask)
        
        trialTable = table();
        postTrialData = postSurpriseTask(k, :);

        correctOptionPostO = {}; % correct option for the critical orientation
        chosenOptionPostO= {}; % participant response to critical orientation
        chosenOptionPostD = {}; % participant response for critical duration 
        correctOptionPostD = {}; % correct critical duration
        
        postStim = {};
        postStim1 = {};
        postStim2 = {};
        postOption1 = {};
        postOption2 = {};
        postShortDuration ={};
        postLongDuration = {};

        ObjectOrientationAccuracyPost = [];
        ObjectdurationAccuracyPost = [];

    


    %define the stimulus and duration for each trial
    
     postStim = cellstr(postTrialData.stimulusIDPost); % correct orientation
     postStim1 = cellstr(postTrialData.postOrientation1Stim); % option on the left
     postStim2 = cellstr(postTrialData.postOrientation2Stim); %option on the right
     
      if  iscell(postTrialData.postOrientation1) 
            postOption1 = cellstr(postTrialData.postOrientation1);

      else
           postOption1 = num2str(postTrialData.postOrientation1);

      end

      
      if iscell(postTrialData.postOrientation2)
         postOption2 = cellstr(postTrialData.postOrientation2);
      else
         postOption2 = num2str(postTrialData.postOrientation2);
      end

         

     
     
      if  iscell(postTrialData.postDurationShort) 

            postShortDuration = cellstr(postTrialData.postDurationShort);
      else
          postShortDuration = num2str(postTrialData.postDurationShort);

      end

      if iscell(postTrialData.postDurationLong)

            postLongDuration = cellstr(postTrialData.postDurationLong);
      else

            postLongDuration = num2str(postTrialData.postDurationLong);
      end
    
    
      correctOptionPostD = cellstr(postTrialData.stimulusDurationPost); %correct duration

    % check the correct option for the stimulus orientation in given post
    % trial
     
        if strcmp(postStim,postStim1)

        correctOptionPostO = postStim1;

    elseif strcmp(postStim,postStim2)

        correctOptionPostO = postStim2;

       end

    
     % chosen Orientation

    if strcmp(postOption1,'true')
        chosenOptionPostO = postStim1;

    elseif strcmp(postOption2,'true')
        chosenOptionPostO = postStim2;
    end

    %check whether participant made the right decision

    if strcmp(correctOptionPostO,chosenOptionPostO)

       OrientationAccuracyPost(k) = 1; 

    else
       OrientationAccuracyPost(k) = 0;

    end

% check the stimulus in given post trial 
   
    if strcmp(postShortDuration,'true')
       chosenOptionPostD = {'short'};
    elseif strcmp(postLongDuration,'true')
        chosenOptionPostD = {'long'};
    end

%check whether participant made the right choice 

    if strcmp(correctOptionPostD,chosenOptionPostD)
        durationAccuracyPost(k) = 1;
    else
        durationAccuracyPost(k) = 0;
    end

    postOrientationRT = postTrialData.orientationRT - postTrialData.OrientationOnset;
    postOrientationConfidence = postTrialData.confidenceOrientationPostt;
    postOrientationConfRT = postTrialData.confidenceOrientationRT - postTrialData.orientationConfidenceOnset;
    postDurationRT = postTrialData.durationRT; 
    postDurationConfidence = postTrialData.confidenceDurationPostt;
    postDurationConfRT = postTrialData.confidenceDurationRT - postTrialData.durationConfidenceOnset;
    probeOrder = postTrialData.probeOrder;

    trialTable = table(OrientationAccuracyPost(k),postOrientationRT,postOrientationConfidence, postOrientationConfRT,durationAccuracyPost(k),postDurationRT,postDurationConfidence,postDurationConfRT,probeOrder,'VariableNames',{'orientationAccuracy','orientationRT','orientationConfidence','orientationConfidenceRT',...
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
 












































  



    

