
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
load('facePostSurprise.mat');
load('objectPostSurprise.mat');

load('criticalAccuracyTable.mat');
load('PostAccuracyTable.mat');

faceCritical = faceCriticalTrial;
objectCritical = objectCriticalTrial;

facePost = facePostSurpriseTrials;
objectPost= objectPostSurpriseTrials;

criticalPerf = CriticalAccuracyTable;
postPerf = PostAccuracyTable;

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
%%

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
%%
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

%%
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

%%
% plot confidence and performance

% get performance for correct and incorrect 

totalFace = criticalPerf.Total1ProbeFace;

correctFaceOrientation = criticalPerf.TotalCorrectFaceOrientation;
falseFaceOrientation = totalFace - correctFaceOrientation;

correctFaceDuration = criticalPerf.TotalCorrectFaceDuration;
falseFaceDuration = totalFace-correctFaceDuration;

% group the values for face orientation and duration 

faceOrientation = [correctFaceOrientation,falseFaceOrientation,confidentAccuracyOrientationFace,confidentFailOrientationFace];
faceDuration =  [correctFaceDuration,falseFaceDuration,confidentAccuracyDurationFace,confidentFailDurationFace];

plotDataFace = [faceOrientation;faceDuration];

percentageDataFace = (plotDataFace/totalFace) * 100;

faceOrientationColors = [orientationColor;falseOrientation;highConfidence;lowConfidence];
faceDurationColors =[durationColor;falseDuration;highConfidence;lowConfidence];

figure;

faceConfidenceBar = bar(percentageDataFace,'grouped','FaceColor','flat');

hold on;
% I access each bars seperately since I want to give them individual colors

for i = 1: size(plotDataFace,1) % go through the groups

    for  j = 1:size(plotDataFace,2) % go through the bars

        if i == 1   % group orientation

            faceConfidenceBar(j).CData(i,:)= faceOrientationColors(j,:);

        elseif i ==2

            faceConfidenceBar(j).CData(i,:)= faceDurationColors(j,:);
        end

    end

end

ylabel('% of participants responsed','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probes','FontWeight','bold','FontSize', 14);
title('Surprise Face Group Probe Performance and Confidence Comparison','FontSize', 15);

yticks([0 20 40 60 80 100]);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

legendColors = [orientationColor;falseOrientation;durationColor;falseDuration;highConfidence;lowConfidence];
legendLabels = {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'};

% add the legend colors 

legends = []; % generate an empty legend 

for i = 1:size(legendColors,1)

currentLegend = plot(nan,nan,'color',legendColors(i,:),'LineWidth',5);

legends = [legends,currentLegend];

end

legend(legends, {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'})

% add the text to no data points 


for i = 1:size(percentageDataFace, 1) % Iterate over groups
    for j = 1:size(percentageDataFace, 2) % Iterate over bars
        if percentageDataFace(i, j) == 0 % get the values that are 0 (empty bars)

            xtip = faceConfidenceBar(j).XEndPoints(i);
            ytip = faceConfidenceBar(j).YEndPoints(i);

            ytip = ytip + 7;

           text(xtip, ytip, '- No Data', 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

        end
    end
end


hold off;

%% object confidence plot 

totalObject = criticalPerf.Total1ProbeObject;

correctObjectOrientation = criticalPerf.TotalCorrectObjectOrientation;
falseObjectOrientation = totalObject - correctObjectOrientation;

correctObjectDuration = criticalPerf.TotalCorrectObjectDuration;
falseObjectDuration = totalObject-correctObjectDuration;

% group the values for face orientation and duration 

objectOrientation = [correctObjectOrientation,falseObjectOrientation,confidentAccuracyOrientationObject,confidentFailOrientationObject];
objectDuration =  [correctObjectDuration,falseObjectDuration,confidentAccuracyDurationObject,confidentFailDurationObject];

plotDataObject = [objectOrientation;objectDuration];

percentageDataObject = (plotDataObject/totalObject) * 100; % turn them into percentages

objectOrientationColors = [orientationColor;falseOrientation;highConfidence;lowConfidence];
objectDurationColors =[durationColor;falseDuration;highConfidence;lowConfidence];

figure;

objectConfidenceBar = bar(percentageDataObject,'grouped','FaceColor','flat');

hold on;
% I access each bars seperately since I want to give them individual colors

for i = 1: size(plotDataObject,1) % go through the groups

    for  j = 1:size(plotDataObject,2) % go through the bars

        if i == 1   % group orientation

            objectConfidenceBar(j).CData(i,:)= objectOrientationColors(j,:);

        elseif i ==2

            objectConfidenceBar(j).CData(i,:)= objectDurationColors(j,:);
        end

    end

end

ylabel('% of participants responsed','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probes','FontWeight','bold','FontSize', 14);
title('Surprise Object Group Probe Performance and Confidence Comparison','FontSize', 15);

ylim([0 100]);
yticks([0 20 40 60 80 100]);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

legendColors = [orientationColor;falseOrientation;durationColor;falseDuration;highConfidence;lowConfidence];
legendLabels = {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'};

% add the legend colors 

legends = []; % generate an empty legend 

for i = 1:size(legendColors,1)

currentLegend = plot(nan,nan,'color',legendColors(i,:),'LineWidth',5);

legends = [legends,currentLegend];

end

legend(legends, {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'})

% add the text to no data points 


for i = 1:size(percentageDataObject, 1) % Iterate over groups
    for j = 1:size(percentageDataObject, 2) % Iterate over bars
        if percentageDataObject(i, j) == 0 % get the values that are 0 (empty bars)

            xtip = objectConfidenceBar(j).XEndPoints(i);
            ytip = objectConfidenceBar(j).YEndPoints(i);

            ytip = ytip + 7;

           text(xtip, ytip, '- No Data', 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

        end
    end
end


hold off;


%% first control confidence alignment 


totalPostFace = postPerf.Total1PostProbeFace(1);

correctPostFaceOrientation = postPerf.TotalPostCorrectOrientationFace(1);
falsePostFaceOrientation = totalPostFace - correctPostFaceOrientation;

correctPostFaceDuration = postPerf.TotalPostCorrectDurationFace(1);
falsePostFaceDuration = totalPostFace-correctPostFaceDuration;

% group the values for face orientation and duration 

facePostOrientation = [correctPostFaceOrientation,falsePostFaceOrientation,confidentPostAccuracyOrientationFace,confidentPostFailOrientationFace];
facePostDuration =  [correctPostFaceDuration,falsePostFaceDuration,confidentPostAccuracyDurationFace,confidentPostFailDurationFace];

plotDataPostFace = [facePostOrientation;facePostDuration];

percentageDataPostFace = (plotDataPostFace/totalPostFace) * 100; % turn them into percentages

OrientationColors = [orientationColor;falseOrientation;highConfidence;lowConfidence];
DurationColors =[durationColor;falseDuration;highConfidence;lowConfidence];


figure;

postFaceConfidenceBar = bar(percentageDataPostFace,'grouped','FaceColor','flat');

hold on;
% I access each bars seperately since I want to give them individual colors

for i = 1: size(plotDataPostFace,1) % go through the groups

    for  j = 1:size(plotDataPostFace,2) % go through the bars

        if i == 1   % group orientation

            postFaceConfidenceBar(j).CData(i,:)= OrientationColors(j,:);

        elseif i ==2

            postFaceConfidenceBar(j).CData(i,:)= DurationColors(j,:);
        end

    end

end

ylabel('% of participants responsed','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probes','FontWeight','bold','FontSize', 14);
title('First Control Face Group Probe Performance and Confidence Comparison','FontSize', 15);

ylim([0 100]);
yticks([0 20 40 60 80 100]);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

legendColors = [orientationColor;falseOrientation;durationColor;falseDuration;highConfidence;lowConfidence];
legendLabels = {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'};

% add the legend colors 

legends = []; % generate an empty legend 

for i = 1:size(legendColors,1)

currentLegend = plot(nan,nan,'color',legendColors(i,:),'LineWidth',5);

legends = [legends,currentLegend];

end

legend(legends, {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'})

% add the text to no data points 


for i = 1:size(percentageDataPostFace, 1) % Iterate over groups
    for j = 1:size(percentageDataPostFace, 2) % Iterate over bars
        if percentageDataPostFace(i, j) == 0 % get the values that are 0 (empty bars)

            xtip = postFaceConfidenceBar(j).XEndPoints(i);
            ytip = postFaceConfidenceBar(j).YEndPoints(i);

            ytip = ytip + 7;

           text(xtip, ytip, '- No Data', 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

        end
    end
end


hold off;

%% post object 

totalPostObject = postPerf.Total1PostProbeObject(1);

correctPostObjectOrientation = postPerf.TotalPostCorrectOrientationObject(1);
falsePostObjectOrientation = totalPostObject - correctPostObjectOrientation;

correctPostObjectDuration = postPerf.TotalPostCorrectDurationObject(1);
falsePostObjectDuration = totalPostObject-correctPostObjectDuration;

% group the values for face orientation and duration 

objectPostOrientation = [correctPostObjectOrientation,falsePostObjectOrientation,confidentPostAccuracyOrientationObject,confidentPostFailOrientationObject];
objectPostDuration =  [correctPostObjectDuration,falsePostObjectDuration,confidentPostAccuracyDurationObject,confidentPostFailDurationObject];

plotDataPostObject = [objectPostOrientation;objectPostDuration];

percentageDataPostObject = (plotDataPostObject/totalPostObject) * 100; % turn them into percentages

OrientationColors = [orientationColor;falseOrientation;highConfidence;lowConfidence];
DurationColors =[durationColor;falseDuration;highConfidence;lowConfidence];


figure;

postObjectConfidenceBar = bar(percentageDataPostObject,'grouped','FaceColor','flat');

hold on;
% I access each bars seperately since I want to give them individual colors

for i = 1: size(plotDataPostObject,1) % go through the groups

    for  j = 1:size(plotDataPostObject,2) % go through the bars

        if i == 1   % group orientation

            postObjectConfidenceBar(j).CData(i,:)= OrientationColors(j,:);

        elseif i ==2

            postObjectConfidenceBar(j).CData(i,:)= DurationColors(j,:);
        end

    end

end

ylabel('% of participants responsed','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probes','FontWeight','bold','FontSize', 14);
title('First Control Object Group Probe Performance and Confidence Comparison','FontSize', 15);

ylim([0 100]);
yticks([0 20 40 60 80 100]);

ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

legendColors = [orientationColor;falseOrientation;durationColor;falseDuration;highConfidence;lowConfidence];
legendLabels = {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'};

% add the legend colors 

legends = []; % generate an empty legend 

for i = 1:size(legendColors,1)

currentLegend = plot(nan,nan,'color',legendColors(i,:),'LineWidth',5);

legends = [legends,currentLegend];

end

legend(legends, {'Correct Orientation','False Orientation','Correct Duration','False Duration','High Confidence','Low Confidence'})

% add the text to no data points 


for i = 1:size(percentageDataPostObject, 1) % Iterate over groups
    for j = 1:size(percentageDataPostObject, 2) % Iterate over bars
        if percentageDataPostObject(i, j) == 0 % get the values that are 0 (empty bars)

            xtip = postObjectConfidenceBar(j).XEndPoints(i);
            ytip = postObjectConfidenceBar(j).YEndPoints(i);

            ytip = ytip + 7;

           text(xtip, ytip, '- No Data', 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');

        end
    end
end


hold off;


% mind wandering responses

tabulate(mindWanderingFace);
tabulate(mindWanderingObject);

% save confidence tables 
modeConfidenceTableFile = 'pilot1ModeConfidenceTable';
save(fullfile(processedDataIrrelevant,modeConfidenceTableFile),'modeConfidenceTable');

modePostConfidenceTableFile = 'pilot1ModePostConfidenceTable';
save(fullfile(processedDataIrrelevant,modePostConfidenceTableFile),'modePostConfidenceTable');



