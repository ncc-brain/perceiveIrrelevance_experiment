
%This script is for ROC plots for confidence & accuracy relation 

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataComb);
addpath(genpath(processedDataComb)); 

% get the confidence and accuracy data  

load('criticalConfidenceTableComb.mat');
load('postConfidenceTableComb.mat');

% plot orientation 

faceOrientationAccuracy = criticalConfidence.faceOrientationPerf;
faceOrientationConf = criticalConfidence.faceOrientationConf;

objectOrientationAccuracy = criticalConfidence.objectOrientationPerf;
objectOrientationConf = criticalConfidence.objectOrientationConf;

[fpRate1, tpRate1, thresholds1, AUC1] = perfcurve(faceOrientationAccuracy, faceOrientationConf, 1);
[fpRate2, tpRate2, thresholds2, AUC2] = perfcurve(objectOrientationAccuracy, objectOrientationConf, 1);


% ROC curve orientation

figure;
plot(fpRate1, tpRate1, 'LineWidth', 3,'Color',faceColor);

hold on;

plot(fpRate2, tpRate2, 'LineWidth', 3,'Color',objectColor);

plot([0 1], [0 1], 'k--'); % Diagonal line (random classifier)


hold off;

% Label the axes and the plot
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title('Confidence & Accuracy Relation');
legend(sprintf('Face Orientation (AUC = %0.2f)', AUC1), sprintf('Object Orientation (AUC = %0.2f)', AUC2), 'Random Classifier', 'Location', 'Southeast');



%% post Curve

postFaceOrientationAccuracy = postConfidenceTable.postFaceOrientationPerf;
postFaceOrientationConf = postConfidenceTable.postFaceOrientationConf;

postObjectOrientationAccuracy = postConfidenceTable.postObjectOrientationPerf;
postObjectOrientationConf = postConfidenceTable.postObjectOrientationConf;

[fpRate1, tpRate1, thresholds1, AUC1] = perfcurve(postFaceOrientationAccuracy, postFaceOrientationConf, 1);
[fpRate2, tpRate2, thresholds2, AUC2] = perfcurve(postObjectOrientationAccuracy,postObjectOrientationConf, 1);

figure;
plot(fpRate1, tpRate1, 'LineWidth', 3,'Color',faceColor);

hold on;

plot(fpRate2, tpRate2, 'LineWidth', 3,'Color',objectColor);

plot([0 1], [0 1], 'k--'); % Diagonal line (random classifier)

thresholdsToAnnotate = [1, 2, 4, 5];
darkGreen = [0 0.5 0];

% Face Orientation Annotations
for i = 1:length(thresholds1)
    if ismember(round(thresholds1(i)), [1, 2])
        combinedThresholds1(1,:) = [fpRate1(i), tpRate1(i)];
    elseif ismember(round(thresholds1(i)), [4, 5])
        combinedThresholds1(2,:) = [fpRate1(i), tpRate1(i)];
    end
end

% Combine annotations for object orientation
for i = 1:length(thresholds2)
    if ismember(round(thresholds2(i)), [1, 2])
        combinedThresholds2(1,:) = [fpRate2(i), tpRate2(i)];
    elseif ismember(round(thresholds2(i)), [4, 5])
        combinedThresholds2(2,:) = [fpRate2(i), tpRate2(i)];
    end
end

% Add text annotations for combined thresholds
text(combinedThresholds1(1,1), combinedThresholds1(1,2), '1-2', 'FontSize', 8, 'Color', darkGreen, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(combinedThresholds1(2,1), combinedThresholds1(2,2), '4-5', 'FontSize', 8, 'Color', darkGreen, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(combinedThresholds2(1,1), combinedThresholds2(1,2), '1-2', 'FontSize', 8, 'Color', 'blue', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
text(combinedThresholds2(2,1), combinedThresholds2(2,2), '4-5', 'FontSize', 8, 'Color', 'blue', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');

hold off;


% Label the axes and the plot
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title('Confidence & Accuracy Relation in First Control');
legend(sprintf('Face Orientation (AUC = %0.2f)', AUC1), sprintf('Object Orientation (AUC = %0.2f)', AUC2), 'Random Classifier', 'Location', 'Southeast');
