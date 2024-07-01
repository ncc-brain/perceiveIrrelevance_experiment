

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





% check the performance in accuracy 

% orientation asked first 

orientationFirst = [orientationFirstCriticalFace,orientationFirstCriticalObject];

correctOrientationOF = 0; % count correct orientation
correctDurationOF = 0; % count correct duration 
OrientationOF = []; %accuracy in orientation when orientation probed first
DurationOF = [];

for i = 1:numel(orientationFirst)

    currentTrial = orientationFirst{i};
    
    if currentTrial.orientationPerformance == 1
        correctOrientationOF = correctOrientationOF +1;
    end

    if currentTrial.durationPerformance == 1
        correctDurationOF = correctDurationOF + 1;
    end

       OrientationOF(i) = currentTrial.orientationPerformance; % orientation performance when orientation probed first
       DurationOF(i) = currentTrial.durationPerformance; % duration performance when orientation probed first 

end


% duration asked first

durationFirst = [durationFirstCriticalFace,durationFirstCriticalObject]; %critical trials when duration probed first 

correctOrientationDF = 0; % count correct orientation
correctDurationDF = 0; % count correct duration 
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

     OrientationDF(i) = currentTrial.orientationPerformance; % orientation performance when duration probed first
     DurationDF(i) = currentTrial.durationPerformance; % duration performance when duration probed first

end


% plot accuracy for order 

ChanceLevel = 0.5;
PValue = 0.05;

%get accuracy values for each condition

OrientationAccuracyOF = correctOrientationOF/numel(OrientationOF); % orientation accuracy with orientation probed first 
OrientationAccuracyDF = correctOrientationDF/numel(OrientationDF); % orientation accuracy with orientation probed second

DurationAccuracyOF = correctDurationOF/numel(DurationOF); % duration accuracy with duration probed first
DurationAccuracyDF = correctDurationDF/numel(DurationDF); % duration accuracy with duration probed first

% get the binomial values for each group 

Orientation_OF = binomialFunction(numel(OrientationOF),correctOrientationOF,'Orientation_OF');
Orientation_DF = binomialFunction(numel(OrientationDF),correctOrientationDF,'Orientation_DF');

Duration_OF = binomialFunction(numel(DurationOF),correctDurationOF,'Duration_OF');
Duration_DF = binomialFunction(numel(DurationDF),correctDurationDF,'Duration_DF');


%get the p values for each group

OrientationP_OF = Orientation_OF.Orientation_OF(4);
OrientationP_DF = Orientation_DF.Orientation_DF(4);

DurationP_OF = Duration_OF.Duration_OF(4);
DurationP_DF = Duration_DF.Duration_DF(4);

% get the error bars for each group 

% error bars for orientation 

lowerBound_Orientation_OF = Orientation_OF.Orientation_OF(2); % orientation first
upperBound_Orientation_OF = Orientation_OF.Orientation_OF(3);

lowerBound_Orientation_DF = Orientation_DF.Orientation_DF(2); % duration first
upperBound_Orientation_DF = Orientation_DF.Orientation_DF(3);



%error bars for duration 

lowerBound_Duration_OF = Duration_OF.Duration_OF(2);
upperBound_Duration_OF = Duration_OF.Duration_OF(3);

lowerBound_Duration_DF = Duration_DF.Duration_DF(2);
upperBound_Duration_DF = Duration_DF.Duration_DF(3);



OrientationFirstAccuracy = [OrientationAccuracyOF,DurationAccuracyOF]; % accuracy values
DurationFirstAccuracy = [OrientationAccuracyDF,DurationAccuracyDF];

OrientationFirstConfidence = [lowerBound_Orientation_OF,upperBound_Orientation_OF;lowerBound_Duration_OF,upperBound_Duration_OF]; % error bars 
DurationFirstConfidence = [lowerBound_Orientation_DF,upperBound_Orientation_DF;lowerBound_Duration_DF,upperBound_Duration_DF];

OrientationFirstP = [OrientationP_OF,DurationP_OF];
DurationFirstP = [OrientationP_DF,DurationP_DF];


OrderAccuracy = [OrientationFirstAccuracy; DurationFirstAccuracy]';
BarColors = [repmat(orientationFirstColor, 2, 1); repmat(durationFirstColor, 2, 1)];

figure; % figure for the subplots 

OrderPlot = bar(OrderAccuracy, 'grouped'); % plot the data 

hold on;

OrderPlot(1).FaceColor = orientationFirstColor; 
OrderPlot(2).FaceColor = durationFirstColor;

% set the error bar lengths 

lowerBoundOF = OrientationFirstAccuracy - OrientationFirstConfidence(:, 1)'; % lower bound for orientation first
upperBoundOF = OrientationFirstConfidence(:, 2)' - OrientationFirstAccuracy; % upper bound for orientation first 

lowerBoundDF = DurationFirstAccuracy - DurationFirstConfidence(:, 1)'; % lower bound for duration first
upperBoundDF = DurationFirstConfidence(:, 2)' - DurationFirstAccuracy; % upper bound for duration first 

errorbar([1-0.15, 2-0.15], OrientationFirstAccuracy, lowerBoundOF, upperBoundOF, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for orientation first 
errorbar([1+0.15, 2+0.15], DurationFirstAccuracy, lowerBoundDF, upperBoundDF, 'k', 'LineStyle', 'none', 'LineWidth', 1); %error bars for face

yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probe','FontWeight','bold','FontSize', 14);
title('Surprise Trial Probe Accuracy','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)


Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(OrientationFirstAccuracy) % number of values are same for orientation and duration are same 
    % object P value 
    
    if OrientationFirstP(i) < PValue
        text(i-0.01 - Astoffset, OrientationFirstAccuracy(i) + 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    % face p-value
    if DurationFirstP(i) < PValue
        text(i+0.40 - Astoffset, DurationFirstAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Orientation First', 'Duration First', 'Location', 'northeast', 'Position', [0.78, 0.94, 0.05, 0.05]);


hold off;


% check whether groups are different 

[fisherOF,chiOF]= chiSquareFunction(OrientationOF,OrientationDF); 

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





