
%this script is for checking the confidence ratings given for probes and
%compares whether there is a relation between confidence rating and
%accuracy

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

%load the data 

load('faceCritical.mat');
load('objectCritical.mat');
load("facePostSurprise.mat");
load('objectPostSurprise.mat');

faceCritical = faceCriticalTrial;
objectCritical = objectCriticalTrial;

facePost = facePostSurpriseTrials;
objectPost= objectPostSurpriseTrials;

% get confidence ratings given in critical 

faceOrientationConfidence = [];
faceDurationConfidence = [];
mindWanderingFace = {};
mindWanderingObject = {};

objectOrientationConfidence = [];
objectDurationConfidence = [];

confidentAccuracyOrientationFace = 0;
confidentFailOrientationFace = 0;

confidentAccuracyDurationFace = 0;
confidentFailDurationFace = 0;

confidentAccuracyOrientationObject = 0;
confidentFailOrientationObject = 0;

confidentAccuracyDurationObject = 0;
confidentFailDurationObject = 0;


for i = 1:numel(faceCritical)

    currentFaceTrial = faceCritical{i};
    currentObjectTrial = objectCritical{i};
     
    % get the confidence ratings for mode 

        currentOrientationFace = currentFaceTrial.orientationConfidence;
        currentDurationFace = currentFaceTrial.durationConfidence;

        faceOrientationConfidence(i) = currentOrientationFace;
        faceDurationConfidence(i)= currentDurationFace;


        currentOrientationObject = currentObjectTrial.orientationConfidence;
        currentDurationObject = currentObjectTrial.durationConfidence;

        objectOrientationConfidence(i) = currentOrientationObject;
        objectDurationConfidence(i) =  currentDurationObject;

        %save mindwandering responses

        currentfocusAnswerFace = currentFaceTrial.mindwandering;
        currentfocusAnswerObject = currentObjectTrial.mindwandering;
        
        mindWanderingFace(i) =  currentfocusAnswerFace;
        mindWanderingObject(i)= currentfocusAnswerObject;



       % check how accurate people are 

       % orientation face 

       if currentOrientationFace >= 4 && currentFaceTrial.orientationPerformance == 1

           confidentAccuracyOrientationFace =  confidentAccuracyOrientationFace +1 ;

       elseif currentOrientationFace <= 2 && currentFaceTrial.orientationPerformance == 0

           confidentFailOrientationFace = confidentFailOrientationFace + 1; 

       end

       %duration face 

       if currentDurationFace >= 4 && currentFaceTrial.durationPerformance == 1

           confidentAccuracyDurationFace =  confidentAccuracyDurationFace +1 ;

       elseif currentDurationFace <= 2 && currentFaceTrial.durationPerformance == 0

           confidentFailDurationFace = confidentFailDurationFace + 1;
            

       end

       %orientation object 

       if currentOrientationObject >= 4 && currentObjectTrial.orientationPerformance == 1

           confidentAccuracyOrientationObject =  confidentAccuracyOrientationObject +1 ;

       elseif currentOrientationObject <= 2 && currentObjectTrial.orientationPerformance == 0

           confidentFailOrientationObject = confidentFailOrientationObject + 1; 

       end

       %duration object 
        
       if currentDurationObject >= 4 && currentObjectTrial.durationPerformance == 1

           confidentAccuracyDurationObject =  confidentAccuracyDurationObject +1 ;

       elseif currentDurationObject <= 2 && currentObjectTrial.durationPerformance == 0

           confidentFailDurationObject = confidentFailDurationObject + 1; 

       end

    
end


% mode of answers

modeFaceOrientationConfidence = mode(faceOrientationConfidence);
minFaceOrientation = min(faceOrientationConfidence);
maxFaceOrientation = max(faceOrientationConfidence);

modeFaceDurationConfidence = mode(faceDurationConfidence);
minFaceDuration = min(faceDurationConfidence);
maxFaceDuration = max(faceDurationConfidence);


modeObjectOrientationConfidence = mode(objectOrientationConfidence);
minObjectOrientation = min(objectOrientationConfidence);
maxObjectOrientation = max(objectOrientationConfidence);


modeObjectDurationConfidence = mode(objectDurationConfidence);
minObjectDuration = min(objectDurationConfidence);
maxObjectDuration= max(objectDurationConfidence);

modeConfidenceTable = table(modeFaceOrientationConfidence, minFaceOrientation, maxFaceOrientation, ...
    modeFaceDurationConfidence, minFaceDuration, maxFaceDuration, ...
    modeObjectOrientationConfidence, minObjectOrientation, maxObjectOrientation, ...
    modeObjectDurationConfidence, minObjectDuration, maxObjectDuration, ...
    'VariableNames', {'modeFaceOrientation', 'minFaceOrientation', 'maxFaceOrientation', ...
                      'modeFaceDuration', 'minFaceDuration', 'maxFaceDuration', ...
                      'modeObjectOrientation', 'minObjectOrientation', 'maxObjectOrientation', ...
                      'modeObjectDuration', 'minObjectDuration', 'maxObjectDuration'});


% confidence post surprise - first control 

facePostOrientationConfidence = [];
facePostDurationConfidence = [];
objectPostOrientationConfidence = [];
objectPostDurationConfidence = [];

for i = 1:numel(facePost)

    currentPostFaceTrial = facePost{i};
    currentPostObjectTrial = objectPost{i};
     
    % get the confidence ratings for mode 

        currentPostOrientationFace = currentPostFaceTrial.orientationConfidence(1);
        currentPostDurationFace = currentPostFaceTrial.durationConfidence(1);

        facePostOrientationConfidence(i) = currentPostOrientationFace;
        facePostDurationConfidence(i)= currentPostDurationFace;


        currentPostOrientationObject = currentPostObjectTrial.orientationConfidence(1);
        currentPostDurationObject = currentPostObjectTrial.durationConfidence(1);

        objectPostOrientationConfidence(i) = currentPostOrientationObject;
        objectPostDurationConfidence(i) =  currentPostDurationObject;

     
end

modePostFaceOrientationConfidence = mode(facePostOrientationConfidence);
minPostFaceOrientation = min(facePostOrientationConfidence);
maxPostFaceOrientation = max(facePostOrientationConfidence);

modePostFaceDurationConfidence = mode(facePostDurationConfidence);
minPostFaceDuration = min(facePostDurationConfidence);
maxPostFaceDuration = max(facePostDurationConfidence);


modePostObjectOrientationConfidence = mode(objectPostOrientationConfidence);
minPostObjectOrientation = min(objectPostOrientationConfidence);
maxPostObjectOrientation = max(objectPostOrientationConfidence);


modePostObjectDurationConfidence = mode(objectPostDurationConfidence);
minPostObjectDuration = min(objectPostDurationConfidence);
maxPostObjectDuration= max(objectPostDurationConfidence);

modePostConfidenceTable = table(modePostFaceOrientationConfidence, minPostFaceOrientation, maxPostFaceOrientation, ...
    modePostFaceDurationConfidence, minPostFaceDuration, maxPostFaceDuration, ...
    modePostObjectOrientationConfidence, minPostObjectOrientation, maxPostObjectOrientation, ...
    modePostObjectDurationConfidence, minPostObjectDuration, maxPostObjectDuration, ...
    'VariableNames', {'modeFaceOrientation', 'minFaceOrientation', 'maxFaceOrientation', ...
                      'modeFaceDuration', 'minFaceDuration', 'maxFaceDuration', ...
                      'modeObjectOrientation', 'minObjectOrientation', 'maxObjectOrientation', ...
                      'modeObjectDuration', 'minObjectDuration', 'maxObjectDuration'});


% mind wandering responses

tabulate(mindWanderingFace);
tabulate(mindWanderingObject);

% save confidence tables 
modeConfidenceTableFile = 'pilot1ModeConfidenceTable';
save(fullfile(processedDataIrrelevant,modeConfidenceTableFile),'modeConfidenceTable');

modePostConfidenceTableFile = 'pilot1ModePostConfidenceTable';
save(fullfile(processedDataIrrelevant,modePostConfidenceTableFile),'modePostConfidenceTable');



