

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

%load binomial tables for P values 

load("binomialTables.mat");

%decide chance level 
ChanceLevel = 0.5;
PValue = 0.05;

%Accuracy plot Values

%object surprise
objectOrientationAccuracy = critical.TotalCorrectObjectOrientation/critical.Total1ProbeObject;
objectDurationAccuracy = critical.TotalCorrectObjectDuration/critical.Total1ProbeObject;

objectOrientationP = binomialTables.criticalObjectOrientation(4);
objectDurationP = binomialTables.criticalObjectDuration(4);

objectAccuracy = [objectOrientationAccuracy,objectDurationAccuracy];
objectAccuracyP = [objectOrientationP,objectDurationP];

lowerBoundObjectOrientation = binomialTables.criticalObjectOrientation(2);
upperBoundObjectOrientation = binomialTables.criticalObjectOrientation(3);

lowerBoundObjectDuration = binomialTables.criticalObjectDuration(2);
upperBoundObjectDuration = binomialTables.criticalObjectDuration(3);

ObjectConfidenceIntervals = [lowerBoundObjectOrientation,upperBoundObjectOrientation;lowerBoundObjectDuration,upperBoundObjectDuration];

lowerBoundObject = objectAccuracy - ObjectConfidenceIntervals(:, 1)'; %length of the lower errorbar 
upperBoundObject = ObjectConfidenceIntervals(:, 2)' - objectAccuracy;% lenght of the upper errorbar 

%face surprise

faceOrientationAccuracy = critical.TotalCorrectFaceOrientation/critical.Total1ProbeFace;
faceDurationAccuracy = critical.TotalCorrectFaceDuration/critical.Total1ProbeFace;

faceOrientationP = binomialTables.criticalFaceOrientation(4);
faceDurationP = binomialTables.criticalFaceDuration(4);

faceAccuracy = [faceOrientationAccuracy,faceDurationAccuracy];
faceAccuracyP = [faceOrientationP,faceDurationP];

%total accuracy surprise 

totalOrientationAccuracy = critical.totalCorrectOrientation/critical.Nr1IrrelevantProbe;
totalDurationAccuracy = critical.totalCorrectDuration/critical.Nr1IrrelevantProbe;

totalOrientationP = binomialTables.criticalOrientation(4);
totalDurationP = binomialTables.criticalDuration(4);

totalAccuracy = [totalOrientationAccuracy,totalDurationAccuracy];
totalAccuracyP = [totalOrientationP,totalDurationP];


%object post first control 

objectPostOrientationAccuracy = post.TotalPostCorrectOrientationObject(1)/post.Total1PostProbeObject(1);
objectPostDurationAccuracy = post.TotalPostCorrectDurationObject(1)/post.Total1PostProbeObject(1);

objectPostOrientationP = binomialTables.postObjectOrientation1(4);
objectPostDurationP = binomialTables.postObjectDuration1(4);

objectPostAccuracy = [objectPostOrientationAccuracy,objectPostDurationAccuracy];
objectPostAccuracyP = [objectPostOrientationP,objectPostDurationP];


%face post first control 

facePostOrientationAccuracy = post.TotalPostCorrectOrientationFace(1)/post.Total1PostProbeFace(1);
facePostDurationAccuracy = post.TotalPostCorrectDurationFace(1)/post.Total1PostProbeFace(1);

facePostOrientationP = binomialTables.postFaceOrientation1(4);
facePostDurationP = binomialTables.postFaceDuration1(4);

facePostAccuracy = [facePostOrientationAccuracy,facePostDurationAccuracy];
facePostAccuracyP = [facePostOrientationP,facePostDurationP];


%combined all first control 
totalPostOrientationAccuracy = post.totalCorrectOrientation(1)/post.Nr1IrrelevantProbe(1);
totalPostDurationAccuracy = post.totalCorrectDuration(1)/post.Nr1IrrelevantProbe(1);

totalPostOrientationP = binomialTables.postOrientation1(4);
totalPostDurationP = binomialTables.postDuration1(4);

totalPostAccuracy = [totalPostOrientationAccuracy,totalPostDurationAccuracy];
totalPostAccuracyP = [totalPostOrientationP,totalPostDurationP];

% pilots 

%object surprise


numBars = numel(objectAccuracyP);

figure;

bar(objectAccuracy,'FaceColor',objectColour);
ylim([0 1]);
ylabel('Accuracy','FontWeight','bold');
xlabel('Probe','FontWeight','bold');
xticklabels({'Orientation','Duration'});
title('Object Surprise Trial Probe Accuracy');

hold on;

errorbar(1:numBars,objectAccuracy,lowerBoundObject, upperBoundObject, 'k', 'LineStyle', 'none', 'LineWidth', 1);

yline(ChanceLevel, '--k', 'Chance Level');

%Add asterisks for significant values

yticks([0, 0.5, 1]);

for i = 1:numel(objectAccuracy)

    % check orientation P value 

    currentProbe = objectAccuracy(i);
    currentP = objectAccuracyP(i);

    if currentP < PValue
       text(i, objectAccuracy(i) + 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    
    end
   

end

hold off;

%face surprise 

figure;

bar(faceAccuracy,'FaceColor',faceColor);
ylim([0 1]);
ylabel('Accuracy','FontWeight','bold');
xlabel('Probe','FontWeight','bold');
xticklabels({'Orientation','Duration'});
title('Face Surprise Trial Probe Accuracy');

hold on;
yline(ChanceLevel, '--k', 'Chance Level');

%Add asterisks for significant values

yticks([0, 0.5, 1]);

for i = 1:numel(faceAccuracy)

    % check orientation P value 

    currentProbe = faceAccuracy(i);
    currentP = faceAccuracyP(i);

    if currentP < PValue
       text(i, faceAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    
    end
   

end

hold off;

% combined accuracy plot 

figure;

bar(totalAccuracy,'FaceColor',CombinedColor);
ylim([0 1]);
ylabel('Accuracy','FontWeight','bold');
xlabel('Probe','FontWeight','bold');
xticklabels({'Orientation','Duration'});
title('Combined Surprise Trial Probe Accuracy');

hold on;
yline(ChanceLevel, '--k', 'Chance Level');

%Add asterisks for significant values

yticks([0, 0.5, 1]);

for i = 1:numel(totalAccuracy)

    % check orientation P value 

    currentProbe = totalAccuracy(i);
    currentP = totalAccuracyP(i);

    if currentP < PValue
       text(i, totalAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    
    end
   

end

hold off;


%object post
figure;

bar(objectPostAccuracy,'FaceColor',objectColour);
ylim([0 1]);
ylabel('Accuracy','FontWeight','bold');
xlabel('Probe','FontWeight','bold');
xticklabels({'Orientation','Duration'});
title('Object First Control Trial Probe Accuracy');

hold on;
yline(ChanceLevel, '--k', 'Chance Level');

%Add asterisks for significant values

yticks([0, 0.5, 1]);

for i = 1:numel(objectPostAccuracy)

    % check orientation P value 

    currentProbe = objectPostAccuracy(i);
    currentP = objectPostAccuracyP(i);

    if currentP < PValue
       text(i, objectPostAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    
    end
   

end

hold off;



%face post

figure;

bar(facePostAccuracy,'FaceColor',faceColor);
ylim([0 1]);
ylabel('Accuracy','FontWeight','bold');
xlabel('Probe','FontWeight','bold');
xticklabels({'Orientation','Duration'});
title('Face First Control Trial Probe Accuracy');

hold on;
yline(ChanceLevel, '--k', 'Chance Level');

%Add asterisks for significant values

yticks([0, 0.5, 1]);

for i = 1:numel(facePostAccuracy)

    % check orientation P value 

    currentProbe = facePostAccuracy(i);
    currentP = facePostAccuracyP(i);

    if currentP < PValue
       text(i, facePostAccuracy(i)  - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    
    end
   

end

hold off;

%combined post


figure;

bar(totalPostAccuracy,'FaceColor',CombinedColor);
ylim([0 1]);
ylabel('Accuracy','FontWeight','bold');
xlabel('Probe','FontWeight','bold');
xticklabels({'Orientation','Duration'});
title('Combined First Control Trial Probe Accuracy');

hold on;
yline(ChanceLevel, '--k', 'Chance Level');

%Add asterisks for significant values

yticks([0, 0.5, 1]);

for i = 1:numel(totalPostAccuracy)

    % check orientation P value 

    currentProbe = totalPostAccuracy(i);
    currentP = totalPostAccuracyP(i);

    if currentP < PValue
       text(i, totalPostAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    
    end
   

end

hold off;







