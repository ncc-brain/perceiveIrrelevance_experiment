

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



