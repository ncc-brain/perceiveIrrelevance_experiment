
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

confidentAccuracyOrientationFace = 0; % participants give high accuracy and performed well
confidentFailOrientationFace = 0; % participants give low accuracy and performed bad 

confidentAccuracyDurationFace = 0;
confidentFailDurationFace = 0;

confidentAccuracyOrientationObject = 0;
confidentFailOrientationObject = 0;

confidentAccuracyDurationObject = 0;
confidentFailDurationObject = 0;


for i = 1:numel(faceCritical)

    currentFaceTrial = faceCritical{i};
    currentObjectTrial = objectCritical{i};
     
    % get the confidence ratings 

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


% confidence tabulate 

faceOrientation = tabulate(faceOrientationConfidence);
faceDuration = tabulate(faceDurationConfidence);
objectOrientation = tabulate(objectOrientationConfidence);
objectDuration = tabulate(objectDurationConfidence);

% get only the percentages for the confidence 

faceOrientationPercentage = faceOrientation(:,3)';
faceDurationPercentage = faceDuration(:,3)';
objectOrientationPercentage = objectOrientation(:,3)';
objectDurationPercentage = objectDuration(:,3)';

confidenceCounts = [faceOrientationPercentage;faceDurationPercentage;objectOrientationPercentage;objectDurationPercentage];


figure;
bar(confidenceCounts,'stacked','BarWidth', 0.9);
colororder(confidenceColors );

xlabel('Probes','FontWeight','bold','FontSize',14)
ylabel('% of participants answered','FontWeight','bold','FontSize',14)
title('Surprise Trial Confidence Ratings','FontSize',16);
ylim([0 100]);

ax = gca;
ax.XTickLabel = {'Face Orientation', 'Face Duration', 'Object Orientation', 'Object Duration'};
ax.XTickLabelRotation = 45;  
%ax.FontWeight = 'bold';

legend('1', '2', '3', '4', '5', 'Location', 'BestOutside');

% confidence post surprise - first control 

facePostOrientationConfidence = [];
facePostDurationConfidence = [];
objectPostOrientationConfidence = [];
objectPostDurationConfidence = [];

confidentPostAccuracyOrientationFace = 0; % if participants gave higher ratings and they performed well
confidentPostFailOrientationFace = 0; % if participants gave lower ratings and they performed low. 

confidentPostAccuracyDurationFace = 0; 
confidentPostFailDurationFace = 0;

confidentPostAccuracyOrientationObject = 0;
confidentPostFailOrientationObject = 0;

confidentPostAccuracyDurationObject = 0;
confidentPostFailDurationObject = 0;

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


        % post confidence & performance accuracy 

        if currentPostOrientationFace >= 4 && currentPostFaceTrial.orientationAccuracy(1) == 1

           confidentPostAccuracyOrientationFace =  confidentPostAccuracyOrientationFace +1 ;

       elseif currentPostOrientationFace <= 2 && currentPostFaceTrial.orientationAccuracy(1) == 0

           confidentPostFailOrientationFace = confidentPostFailOrientationFace + 1; 

       end

       %duration face 

       if currentPostDurationFace >= 4 && currentPostFaceTrial.durationAccuracy(1) == 1

           confidentPostAccuracyDurationFace =  confidentPostAccuracyDurationFace +1 ;

       elseif currentPostDurationFace <= 2 && currentPostFaceTrial.durationAccuracy(1) == 0

           confidentPostFailDurationFace = confidentPostFailDurationFace + 1;
            

       end

       %orientation object 

       if currentPostOrientationObject >= 4 && currentPostObjectTrial.orientationAccuracy(1) == 1

           confidentPostAccuracyOrientationObject =  confidentPostAccuracyOrientationObject +1 ;

       elseif currentPostOrientationObject <= 2 && currentPostObjectTrial.orientationAccuracy(1) == 0

           confidentPostFailOrientationObject = confidentPostFailOrientationObject + 1; 

       end

       %duration object 
        
       if currentPostDurationObject >= 4 && currentPostObjectTrial.durationAccuracy(1) == 1

           confidentPostAccuracyDurationObject =  confidentPostAccuracyDurationObject +1 ;

       elseif currentPostDurationObject <= 2 && currentPostObjectTrial.durationAccuracy(1) == 0

           confidentPostFailDurationObject = confidentPostFailDurationObject + 1; 

       end

    
end

     
confidenceTable = table ()

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



%tabulate post 

facePostOrientation = tabulate(facePostOrientationConfidence);
facePostDuration = tabulate(facePostDurationConfidence);
objectPostOrientation = tabulate(objectPostOrientationConfidence);
objectPostDuration = tabulate(objectPostDurationConfidence);

% get only the percentages for the confidence 

facePostOrientationPercentage = facePostOrientation(:,3)';
facePostDurationPercentage = facePostDuration(:,3)';
objectPostOrientationPercentage = objectPostOrientation(:,3)';
objectPostDurationPercentage = objectPostDuration(:,3)';

confidencePostCounts = [facePostOrientationPercentage;facePostDurationPercentage;objectPostOrientationPercentage;objectPostDurationPercentage];


figure;
bar(confidencePostCounts,'stacked','BarWidth', 0.9);
colororder(confidenceColors );

xlabel('Probes','FontWeight','bold','FontSize',14)
ylabel('% of participants answered','FontWeight','bold','FontSize',14)
title('First Control Confidence Ratings','FontSize',16);
ylim([0 100]);

ax = gca;
ax.XTickLabel = {'Face Orientation', 'Face Duration', 'Object Orientation', 'Object Duration'};
ax.XTickLabelRotation = 45;  
%ax.FontWeight = 'bold';

legend('1', '2', '3', '4', '5', 'Location', 'BestOutside');



% mind wandering responses

tabulate(mindWanderingFace);
tabulate(mindWanderingObject);

% save confidence tables 
modeConfidenceTableFile = 'pilot1ModeConfidenceTable';
save(fullfile(processedDataIrrelevant,modeConfidenceTableFile),'modeConfidenceTable');

modePostConfidenceTableFile = 'pilot1ModePostConfidenceTable';
save(fullfile(processedDataIrrelevant,modePostConfidenceTableFile),'modePostConfidenceTable');



