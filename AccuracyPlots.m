
% this script plots accuracy bars 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

% load binomial table for accuracy values & p values 

load("binomialTables.mat");

binom = binomialTables;

%set chance level & p value 

ChanceLevel = 0.5;
PValue = 0.05;

%Accuracy plot Values

%object surprise

objectAccuracy = [binom.criticalObjectOrientation(1),binom.criticalObjectDuration(1)]; % first value is the accuracy 
objectPvalues = [binom.criticalObjectOrientation(4),binom.criticalObjectDuration(4)]; %forth value is the P value 

%confidence intervals for error bars 

%lowerBoundObjectOrientation = binom.criticalObjectOrientation(2);
%upperBoundObjectOrientation = binom.criticalObjectOrientation(3);
%lowerBoundObjectDuration = binom.criticalObjectDuration(2);
%upperBoundObjectDuration = binom.criticalObjectDuration(3);

%ObjectConfidenceIntervals = [lowerBoundObjectOrientation,upperBoundObjectOrientation;lowerBoundObjectDuration,upperBoundObjectDuration];

%face surprise

faceAccuracy = [binom.criticalFaceOrientation(1),binom.criticalFaceDuration(1)];
facePvalues = [binom.criticalFaceOrientation(4),binom.criticalFaceDuration(4)];

%lowerBoundFaceOrientation = binom.criticalFaceOrientation(2);
%upperBoundFaceOrientation = binom.criticalFaceOrientation(3);
%lowerBoundFaceDuration = binom.criticalFaceDuration(2);
%upperBoundFaceDuration = binom.criticalFaceDuration(3);

%FaceConfidenceIntervals = [lowerBoundFaceOrientation,upperBoundFaceOrientation;lowerBoundFaceDuration,upperBoundFaceDuration];

% surprise trial plot 

BarAccuracy = [objectAccuracy; faceAccuracy]';
BarColors = [repmat(objectColor, 2, 1); repmat(faceColor, 2, 1)];

fig = figure; % figure for the subplots 

AccuracyPlot = bar(BarAccuracy, 'grouped');

hold on;

AccuracyPlot(1).FaceColor = objectColor; 
AccuracyPlot(2).FaceColor = faceColor;

% set the length for the error bars 

%lowerBoundObject = objectAccuracy - ObjectConfidenceIntervals(:, 1)'; % error bar lengths 
%upperBoundObject = ObjectConfidenceIntervals(:, 2)' - objectAccuracy;

%lowerBoundFace = faceAccuracy - FaceConfidenceIntervals(:, 1)';
%upperBoundFace = FaceConfidenceIntervals(:, 2)' - faceAccuracy;

%errorbar([1-0.15, 2-0.15], objectAccuracy, lowerBoundObject, upperBoundObject, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for object 
%errorbar([1+0.15, 2+0.15], faceAccuracy, lowerBoundFace, upperBoundFace, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for face


yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);
ylim([0,1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('Surprise Trial Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; 

% add asterisks for significant values 

Astoffset = 0.2; % asterisks ofset to decide the placement of it 


for i = 1:numel(objectAccuracy) % number of values are same for the object and face
    % object P value 
    
    if objectPvalues(i) < PValue
        text(i-0.35 - Astoffset, objectAccuracy(i) -0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    % face p-value
    if facePvalues(i) < PValue
        text(i+0.35 - Astoffset, faceAccuracy(i)-0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Object', 'Face', 'Location', 'northeast', 'Position', [0.81, 0.86, 0.05, 0.05]);

hold off;
%% Post-surprise bars 

%object post (first control)

objectPostAccuracy = [binom.postObjectOrientation1(1),binom.postObjectDuration1(1)];
objectPostPvalues = [binom.postObjectOrientation1(4),binom.postObjectDuration1(4)];

%PostlowerBoundObjectOrientation = binom.postObjectOrientation1(2);
%PostupperBoundObjectOrientation = binom.postObjectOrientation1(3);
%PostlowerBoundObjectDuration = binom.postObjectDuration1(2);
%PostupperBoundObjectDuration = binom.postObjectDuration1(3);

%PostObjectConfidenceIntervals = [PostlowerBoundObjectOrientation,PostupperBoundObjectOrientation;PostlowerBoundObjectDuration,PostupperBoundObjectDuration];

%face post (first control)

facePostAccuracy = [binom.postFaceOrientation1(1),binom.postFaceDuration1(1)];
facePostPvalues = [binom.postFaceOrientation1(4),binom.postFaceDuration1(4)];

%PostlowerBoundFaceOrientation = binom.postFaceOrientation1(2);
%PostupperBoundFaceOrientation = binom.postFaceOrientation1(3);
%PostlowerBoundFaceDuration = binom.postFaceDuration1(2);
%PostupperBoundFaceDuration = binom.postFaceDuration1(3);

%PostFaceConfidenceIntervals = [PostlowerBoundFaceOrientation,PostupperBoundFaceOrientation;PostlowerBoundFaceDuration,PostupperBoundFaceDuration];

%plot the post-surprise bars 

PostBarAccuracy = [objectPostAccuracy; facePostAccuracy]';
BarColors = [repmat(objectColor, 2, 1); repmat(faceColor, 2, 1)];

figure; % figure for the subplots 

PostAccuracyPlot = bar(PostBarAccuracy, 'grouped');

hold on;

PostAccuracyPlot(1).FaceColor = objectColor; 
PostAccuracyPlot(2).FaceColor = faceColor;

% set the length for the error bars 

%PostlowerBoundObject = objectPostAccuracy - PostObjectConfidenceIntervals(:, 1)'; % error bar lengths 
%PostupperBoundObject = PostObjectConfidenceIntervals(:, 2)' - objectPostAccuracy;

%PostlowerBoundFace = facePostAccuracy - PostFaceConfidenceIntervals(:, 1)';
%PostupperBoundFace = PostFaceConfidenceIntervals(:, 2)' - facePostAccuracy;

%errorbar([1-0.15, 2-0.15], objectPostAccuracy, PostlowerBoundObject, PostupperBoundObject, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for object 
%errorbar([1+0.15, 2+0.15], facePostAccuracy, PostlowerBoundFace,PostupperBoundFace, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for face


yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);


ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('First Control Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name 


% add asterisks for significant values 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(objectPostAccuracy) 
    
    if objectPostPvalues(i) < PValue
        text(i-0.05 - Astoffset,  objectPostAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    % face p-value
    if facePostPvalues(i) < PValue
        text(i+0.25 - Astoffset, facePostAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Object', 'Face', 'Location', 'northeast', 'Position', [0.81, 0.86, 0.05, 0.05]);


hold off;


%% combined accuracy 

combinedSurprise = [binom.criticalOrientation(1),binom.criticalDuration(1)];
combinedControl = [binom.postOrientation1(1),binom.postDuration1(1)];

surprisePvalues = [binom.criticalOrientation(4),binom.criticalDuration(4)];
controlPvalues =[binom.postOrientation1(4),binom.postDuration1(4)];


% get the confidence intervals 

% lowerBoundOrientation = binom.criticalOrientation(2);
% upperBoundOrientation = binom.criticalOrientation(3);
% lowerBoundDuration = binom.criticalDuration(2);
% upperBoundDuration = binom.criticalDuration(3);

%TotalConfidenceIntervals = [lowerBoundOrientation,upperBoundOrientation;lowerBoundDuration,upperBoundDuration];

% postLowerBoundOrientation = binom.postOrientation1(2);
% postUpperBoundOrientation = binom.postOrientation1(3);
% postLowerBoundDuration = binom.postDuration1(2);
% postUpperBoundDuration = binom.postDuration1(3);

%postTotalConfidenceIntervals = [postLowerBoundOrientation,postUpperBoundOrientation;postLowerBoundDuration,postUpperBoundDuration];


BarCombinedAccuracy = [combinedSurprise;combinedControl]';
surpriseColors = [orientationColor;durationColor];
postColors = [postOrientation;postDuration];

figure; 

AccuracyCombinedPlot = bar(BarCombinedAccuracy,'grouped','FaceColor','flat');

hold on;

%set the colors 

    for j = 1:size(BarCombinedAccuracy,1)

        AccuracyCombinedPlot(1).CData(j,:)= surpriseColors(j,:); %orientation side
       
        AccuracyCombinedPlot(2).CData(j,:)= postColors(j,:); %duration side
  
    end


% set the length of the error bars 


% lowerBoundSurpriseL = combinedSurprise - TotalConfidenceIntervals(:, 1)'; 
% upperBoundsupriseL = TotalConfidenceIntervals(:, 2)' - combinedSurprise;

% lowerBoundPostL = combinedControl - postTotalConfidenceIntervals(:, 1)';
% upperBoundPostL = postTotalConfidenceIntervals(:, 2)' - combinedControl;


%errorbar([1-0.15, 2-0.15], combinedSurprise,lowerBoundSurpriseL,upperBoundsupriseL, 'k', 'LineStyle', 'none', 'LineWidth', 1); % surprise
%errorbar([1+0.15, 2+0.15], combinedControl, lowerBoundPostL,upperBoundPostL, 'k', 'LineStyle', 'none', 'LineWidth', 1);


yline(ChanceLevel, '--k'); % add the line to the chance level 
ylim([0 1])
yticks([0 0.5 1]);


ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('Surprise and First Control Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

% add asterisks for significant values 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 

for i = 1:numel(combinedSurprise) 
    
    if surprisePvalues(i) < PValue
        text(i-0.05 - Astoffset,  combinedSurprise(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    % face p-value
    if controlPvalues(i) < PValue
        text(i+0.25 - Astoffset, combinedControl(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

% add legends 

legendColors = [orientationColor;postOrientation;durationColor;postDuration];
legendLabels = {'Surprise Orientation','Post Orientation','Surprise Duration','Post Duration'};

% add the legend colors 

legends = []; % generate an empty legend 

for i = 1:size(legendColors,1)

currentLegend = plot(nan,nan,'color',legendColors(i,:),'LineWidth',5);

legends = [legends,currentLegend];

end

legend(legends, {'Surprise Orientation','Post Orientation','Surprise Duration','Post Duration'});


hold off;

%% Order effect accuracy plots 

% load order effect data 

load('orderEffect.mat');

accuracyOrientation = [(sum(orderEffect.orientationFirst)/height(orderEffect));(sum(orderEffect.orientationSecond)/height(orderEffect))];
accuracyDuration = [(sum(orderEffect.durationFirst)/height(orderEffect));(sum(orderEffect.durationSecond)/height(orderEffect))];

%plot orientation order effect 

figure,

orientationPlot = bar(accuracyOrientation,'FaceColor','flat');

orientationPlot.CData(1,:) = orientationFirstColor; 
orientationPlot.CData(2,:)= durationFirstColor;

yline(ChanceLevel, '--k'); % add the line to the chance level 
ylim([0 1])
yticks([0 0.5 1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('Surprise Trial Orientation Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation First', 'Orientation Second'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)


Astoffset = 0.1; % asterisks ofset to decide the placement of it 

for i = 1:numel(combinedSurprise) 
    
    if surprisePvalues(i) < PValue
        text(i-0.05 - Astoffset,  combinedSurprise(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    % face p-value
    if controlPvalues(i) < PValue
        text(i+0.25 - Astoffset, combinedControl(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

