

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

%face surprise

faceOrientationAccuracy = critical.TotalCorrectFaceOrientation/critical.Total1ProbeFace;
faceDurationAccuracy = critical.TotalCorrectFaceDuration/critical.Total1ProbeFace;

faceOrientationP = binomialTables.criticalFaceOrientation(4);
faceDurationP = binomialTables.criticalFaceDuration(4);

faceAccuracy = [faceOrientationAccuracy,faceDurationAccuracy];
faceAccuracyP = [faceOrientationP,faceDurationP];

lowerBoundFaceOrientation = binomialTables.criticalFaceOrientation(2);
upperBoundFaceOrientation = binomialTables.criticalFaceOrientation(3);

lowerBoundFaceDuration = binomialTables.criticalFaceDuration(2);
upperBoundFaceDuration = binomialTables.criticalFaceDuration(3);

FaceConfidenceIntervals = [lowerBoundFaceOrientation,upperBoundFaceOrientation;lowerBoundFaceDuration,upperBoundFaceDuration];

% surprise trial plot 

BarAccuracy = [objectAccuracy; faceAccuracy]';
BarColors = [repmat(objectColor, 2, 1); repmat(faceColor, 2, 1)];

figure; % figure for the subplots 

AccuracyPlot = bar(BarAccuracy, 'grouped');

hold on;

AccuracyPlot(1).FaceColor = objectColor; 
AccuracyPlot(2).FaceColor = faceColor;

% set the length for the error bars 

lowerBoundObject = objectAccuracy - ObjectConfidenceIntervals(:, 1)'; % error bar lengths 
upperBoundObject = ObjectConfidenceIntervals(:, 2)' - objectAccuracy;

lowerBoundFace = faceAccuracy - FaceConfidenceIntervals(:, 1)';
upperBoundFace = FaceConfidenceIntervals(:, 2)' - faceAccuracy;

errorbar([1-0.15, 2-0.15], objectAccuracy, lowerBoundObject, upperBoundObject, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for object 
errorbar([1+0.15, 2+0.15], faceAccuracy, lowerBoundFace, upperBoundFace, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for face


yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);


ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('Surprise Trial Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)


% add asterisks for significant values 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(objectAccuracy) % number of values are same for the object and face
    % object P value 
    
    if objectAccuracyP(i) < PValue
        text(i-0.40 - Astoffset, objectAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    % face p-value
    if faceAccuracyP(i) < PValue
        text(i+0.40 - Astoffset, faceAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Object', 'Face', 'Location', 'northeast', 'Position', [0.81, 0.86, 0.05, 0.05]);


hold off;

%% combined accuracy 


totalOrientationAccuracy = critical.totalCorrectOrientation/critical.Nr1IrrelevantProbe;
totalDurationAccuracy = critical.totalCorrectDuration/critical.Nr1IrrelevantProbe;

totalOrientationP = binomialTables.criticalOrientation(4);
totalDurationP = binomialTables.criticalDuration(4);


% get the confidence intervals 

lowerBoundOrientation = binomialTables.criticalOrientation(2);
upperBoundOrientation = binomialTables.criticalOrientation(3);

lowerBoundDuration = binomialTables.criticalDuration(2);
upperBoundDuration = binomialTables.criticalDuration(3);

TotalConfidenceIntervals = [lowerBoundOrientation,upperBoundOrientation;lowerBoundDuration,upperBoundDuration];

BarCombinedAccuracy = [totalOrientationAccuracy; totalDurationAccuracy];

figure; 

AccuracyCombinedPlot = bar(BarCombinedAccuracy);

hold on;

% set the colours 

AccuracyCombinedPlot.FaceColor = 'flat';
AccuracyCombinedPlot.CData(1,:) = orientationColor; 
AccuracyCombinedPlot.CData(2,:)= durationColor;

% set the length of the error bars 

lowerBoundOrientationL = totalOrientationAccuracy - TotalConfidenceIntervals(1, 1); 
upperBoundOrientationL = TotalConfidenceIntervals(1, 2) - totalOrientationAccuracy;

lowerBoundDurationL = totalDurationAccuracy - TotalConfidenceIntervals(2, 1);
upperBoundDurationL = TotalConfidenceIntervals(2, 2) - totalDurationAccuracy;


errorbar(1, totalOrientationAccuracy, lowerBoundOrientationL, upperBoundOrientationL, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for orientation
errorbar(2, totalDurationAccuracy, lowerBoundDurationL, upperBoundDurationL, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for duration


yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);


ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('Surprise Trial Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

% add asterisks for significant values 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 

    
    if totalOrientationP < PValue  % p value for combined orientation
        text(1+0.40 - Astoffset, totalOrientationAccuracy + 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    
    if totalDurationP < PValue % p value for combined duration
        text(2+0.40 - Astoffset, totalDurationAccuracy + 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end

hold off;

%% First Control face & object probes


%object post first control 

objectPostOrientationAccuracy = post.TotalPostCorrectOrientationObject(1)/post.Total1PostProbeObject(1);
objectPostDurationAccuracy = post.TotalPostCorrectDurationObject(1)/post.Total1PostProbeObject(1);

objectPostOrientationP = binomialTables.postObjectOrientation1(4);
objectPostDurationP = binomialTables.postObjectDuration1(4);

objectPostAccuracy = [objectPostOrientationAccuracy,objectPostDurationAccuracy];
objectPostAccuracyP = [objectPostOrientationP,objectPostDurationP];

PostlowerBoundObjectOrientation = binomialTables.postObjectOrientation1(2);
PostupperBoundObjectOrientation = binomialTables.postObjectOrientation1(3);

PostlowerBoundObjectDuration = binomialTables.postObjectDuration1(2);
PostupperBoundObjectDuration = binomialTables.postObjectDuration1(3);

PostObjectConfidenceIntervals = [PostlowerBoundObjectOrientation,PostupperBoundObjectOrientation;PostlowerBoundObjectDuration,PostupperBoundObjectDuration];

%face post first control 

facePostOrientationAccuracy = post.TotalPostCorrectOrientationFace(1)/post.Total1PostProbeFace(1);
facePostDurationAccuracy = post.TotalPostCorrectDurationFace(1)/post.Total1PostProbeFace(1);

facePostOrientationP = binomialTables.postFaceOrientation1(4);
facePostDurationP = binomialTables.postFaceDuration1(4);

facePostAccuracy = [facePostOrientationAccuracy,facePostDurationAccuracy];
facePostAccuracyP = [facePostOrientationP,facePostDurationP];

PostlowerBoundFaceOrientation = binomialTables.postFaceOrientation1(2);
PostupperBoundFaceOrientation = binomialTables.postFaceOrientation1(3);

PostlowerBoundFaceDuration = binomialTables.postFaceDuration1(2);
PostupperBoundFaceDuration = binomialTables.postFaceDuration1(3);

PostFaceConfidenceIntervals = [PostlowerBoundFaceOrientation,PostupperBoundFaceOrientation;PostlowerBoundFaceDuration,PostupperBoundFaceDuration];

% post plot 

PostBarAccuracy = [objectPostAccuracy; facePostAccuracy]';
BarColors = [repmat(objectColor, 2, 1); repmat(faceColor, 2, 1)];

figure; % figure for the subplots 

PostAccuracyPlot = bar(PostBarAccuracy, 'grouped');

hold on;

PostAccuracyPlot(1).FaceColor = objectColor; 
PostAccuracyPlot(2).FaceColor = faceColor;

% set the length for the error bars 

PostlowerBoundObject = objectPostAccuracy - PostObjectConfidenceIntervals(:, 1)'; % error bar lengths 
PostupperBoundObject = PostObjectConfidenceIntervals(:, 2)' - objectPostAccuracy;

PostlowerBoundFace = facePostAccuracy - PostFaceConfidenceIntervals(:, 1)';
PostupperBoundFace = PostFaceConfidenceIntervals(:, 2)' - facePostAccuracy;

errorbar([1-0.15, 2-0.15], objectPostAccuracy, PostlowerBoundObject, PostupperBoundObject, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for object 
errorbar([1+0.15, 2+0.15], facePostAccuracy, PostlowerBoundFace,PostupperBoundFace, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for face


yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);


ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('First Control Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)


% add asterisks for significant values 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(objectPostAccuracy) % number of values are same for the object and face
    % object P value 
    
    if objectPostAccuracyP(i) < PValue
        text(i-0.02 - Astoffset,  objectPostAccuracy(i) + 0.04, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    % face p-value
    if facePostAccuracyP(i) < PValue
        text(i+0.30 - Astoffset, facePostAccuracy(i) + 0.04, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Object', 'Face', 'Location', 'northeast', 'Position', [0.81, 0.86, 0.05, 0.05]);


hold off;

%% Post Combined 

totalPostOrientationAccuracy = post.totalCorrectOrientation(1)/post.Nr1IrrelevantProbe(1); % accuracy values 
totalPostDurationAccuracy = post.totalCorrectDuration(1)/post.Nr1IrrelevantProbe(1);

totalPostOrientationP = binomialTables.postOrientation1(4); % P values 
totalPostDurationP = binomialTables.postDuration1(4);


PostlowerBoundOrientation = binomialTables.postOrientation1(2);
PostupperBoundOrientation = binomialTables.postOrientation1(3);

PostlowerBoundDuration = binomialTables.postDuration1(2);
PostupperBoundDuration = binomialTables.postDuration1(3);

PostTotalConfidenceIntervals = [PostlowerBoundOrientation,PostupperBoundOrientation;PostlowerBoundDuration,PostupperBoundDuration];

PostCombined = [totalPostOrientationAccuracy;totalPostDurationAccuracy];

figure; 

PostCombinedPlot = bar(PostCombined);

hold on;

% set the colours 

PostCombinedPlot.FaceColor = 'flat';
PostCombinedPlot.CData(1,:) = orientationColor; 
PostCombinedPlot.CData(2,:)= durationColor;

% set the length of the error bars 

PostlowerBoundOrientationL = totalPostOrientationAccuracy - PostTotalConfidenceIntervals(1, 1); 
PostupperBoundOrientationL = PostTotalConfidenceIntervals(1, 2) - totalPostOrientationAccuracy;

PostlowerBoundDurationL = totalPostDurationAccuracy - PostTotalConfidenceIntervals(2, 1);
PostupperBoundDurationL = PostTotalConfidenceIntervals(2, 2) - totalPostDurationAccuracy;


errorbar(1, totalPostOrientationAccuracy, PostlowerBoundOrientationL, PostupperBoundOrientationL, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for orientation
errorbar(2, totalPostDurationAccuracy, PostlowerBoundDurationL, PostupperBoundDurationL, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for duration


yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);


ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('First Control Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

% add asterisks for significant values 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 

    
    if totalPostOrientationP < PValue  % p value for combined orientation
        text(1+0.40 - Astoffset, totalPostOrientationAccuracy + 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    
    if totalPostDurationP < PValue % p value for combined duration
        text(2+0.40 - Astoffset, totalPostDurationAccuracy + 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end

hold off;


%% Post All Combined 






