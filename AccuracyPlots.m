

% accuracy plots 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

load('criticalAccuracyTable.mat');
load('PostAccuracyTable.mat');

critical = CriticalAccuracyTable;
post = PostAccuracyTable;
% object critical correct response plots 

figure;

bar([critical.TotalCorrectObjectOrientation, critical.TotalCorrectObjectDuration],'FaceColor',objectColour);
xlabel('Probe');
ylabel('Correct responses');
xticklabels({'Orientation','Duration'});
title('Object Surprise Trial Probe Accuracy');

ylim([0 12]);

% face  critical correct response plot table 

bar([critical.TotalCorrectFaceOrientation, critical.TotalCorrectFaceDuration],'FaceColor',faceColor);
xlabel('Probe');
ylabel('Correct responses');
xticklabels({'Orientation','Duration'});
title('Face Surprise Trial Probe Accuracy');

ylim([0 12]);

% object post-suprise correct response plots

figure;

bar([post.TotalPostCorrectOrientationObject(1), post.TotalPostCorrectDurationObject(1)],'FaceColor',objectColour);
xlabel('Probe');
ylabel('Correct responses');
xticklabels({'Orientation','Duration'});
title('Object First Control Probe Accuracy');

ylim([0 12]);

% face post-surprise correct response plots 

figure;

bar([post.TotalPostCorrectOrientationFace(1), post.TotalPostCorrectDurationFace(1)],'FaceColor',faceColor);
xlabel('Probe');
ylabel('Correct responses');
xticklabels({'Orientation','Duration'});
title('Face First Control Probe Accuracy');

ylim([0 12]);

% object accuracy plot 

AccuracyObjectOrientation = critical.TotalCorrectObjectOrientation/critical.Nr1IrrelevantProbe
AccuracyObjectDuration = 

