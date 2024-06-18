

% this script is to test the effect of order on the accuracy of the results

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

load('facePostSurprise.mat');
load('objectPostSurprise.mat');
load('faceCritical.mat');
load('objectCritical.mat');

facePost = facePostSurpriseTrials;
objectPost = objectPostSurpriseTrials;

faceCritical = faceCriticalTrial;
objectCritical = objectCriticalTrial;

%get the probe order (only saved for the post-surprise but it is same as
%critical) 

subOrientationFirstFace = {}; % subjects orientation asked first
subDurationFirstFace = {};

subOrientationFirstObject = {};
subDurationFirstObject = {};

for i = 1:numel(facePost)

   currentFaceSubject = facePost{i};
   currentObjectSubject = objectPost{i};

   if strcmp(currentFaceSubject.probeOrder,'orientationFirsr')
       subOrientationFirstFace{end+1} = currentFaceSubject.ParticipantID(1);

   elseif strcmp(currentFaceSubject.probeOrder,'durationFirst')
       subDurationFirstFace{end+1} = currentFaceSubject.ParticipantID(1);

   end

   if strcmp(currentObjectSubject.probeOrder,'orientationFirst')
       subOrientationFirstObject{end+1} = currentObjectSubject.ParticipantID(1);

   elseif strcmp(currentObjectSubject.probeOrder,'durationFirst')
       subDurationFirstObject{end+1} = currentObjectSubject.ParticipantID(1);

   end
 
end

% find order for critical trials

orientationFirstCriticalFace= {};
durationFirstCriticalFace = {}; 

orientationFirstCriticalObject= {};
durationFirstCriticalObject = {}; 



for j = 1:numel(faceCritical)
    
    currentFaceCritical = faceCritical{j};
    currentObjectCritical = objectCritical{j};

    %  critical data orientation probed first 
    if  any(cellfun(@(x) isequal(x, currentFaceCritical.ParticipantID), subOrientationFirstFace))
        orientationFirstCriticalFace{end+1} = currentFaceCritical;
    end
    
    % critical data duration probed first
    if  any(cellfun(@(x) isequal(x, currentFaceCritical.ParticipantID), subDurationFirstFace))
        durationFirstCriticalFace{end+1} = currentFaceCritical;
    end

     if  any(cellfun(@(x) isequal(x, currentObjectCritical.ParticipantID), subOrientationFirstObject))
        orientationFirstCriticalObject{end+1} = currentObjectCritical;
    end
    
    % critical data duration probed first
    if  any(cellfun(@(x) isequal(x, currentObjectCritical.ParticipantID), subDurationFirstObject))
        durationFirstCriticalObject{end+1} = currentObjectCritical;
    end
end

% check the performance in accuracy 

% orientation asked first 

orientationFirst = [orientationFirstCriticalFace,orientationFirstCriticalObject];

correctOrientationOF = 0;
correctDurationOF = 0; 
OrientationOF = [];
DurationOF = [];

for i = 1:numel(orientationFirst)

    currentTrial = orientationFirst{i};
    
    if currentTrial.orientationPerformance == 1
        correctOrientationOF = correctOrientationOF +1;
    end

    if currentTrial.durationPerformance == 1
        correctDurationOF = correctDurationOF + 1;
    end

       OrientationOF(i) = currentTrial.orientationPerformance;
       DurationOF(i) = currentTrial.durationPerformance; 

end


% duration asked first

durationFirst = [durationFirstCriticalFace,durationFirstCriticalObject];

correctOrientationDF = 0;
correctDurationDF = 0; 
OrientationDF = [];
DurationDF = [];

for i = 1:numel(durationFirst)

    currentTrial = durationFirst{i};
    
    if currentTrial.orientationPerformance == 1
        correctOrientationDF = correctOrientationDF +1;
    end

    if currentTrial.durationPerformance == 1
        correctDurationDF = correctDurationDF + 1;
    end

     OrientationDF(i) = currentTrial.orientationPerformance;
     DurationDF(i) = currentTrial.durationPerformance; 

end


% check whether groups are different 

[fisherOF,chiOF]= chiSquareFunction(OrientationDF,OrientationDF); 

[fisherDF,chiDF] = chiSquareFunction(DurationDF,DurationOF);

%save the results 

pilot1OrderOFFisherFile = 'pilot1OrderOFFisher';
save(fullfile(processedDataIrrelevant,pilot1OrderOFFisherFile),'fisherOF');

pilot1OrderOFChiFile = 'pilot1OrderOFChi';
save(fullfile(processedDataIrrelevant,pilot1OrderOFChiFile),'chiOF');

pilot1OrderDFFisherFile = 'pilot1OrderDFFisher';
save(fullfile(processedDataIrrelevant,pilot1OrderDFFisherFile),'fisherDF');

pilot1OrderDFChiFile = 'pilot1OrderDFChi';
save(fullfile(processedDataIrrelevant,pilot1OrderDFChiFile),'chiDF');





