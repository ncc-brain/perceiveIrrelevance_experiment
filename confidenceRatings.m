
%this script is for checking the confidence ratings given for probes and
%compares whether there is a relation between confidence rating and
%accuracy

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataOnline)
addpath(genpath(processedDataOnline)); 

%load the data 

load("criticalTable.mat");
load('postTable.mat');


%% confidence surprise 

faceRows = strcmp(criticalTable.groupName, 'face');
objectRows = strcmp(criticalTable.groupName,'object');

faceOrientationAccuracy = criticalTable.orientationPerformance(faceRows);
faceDurationAccuracy = criticalTable.durationPerformance(faceRows);

objectOrientationAccuracy = criticalTable.orientationPerformance(objectRows);
objectDurationAccuracy = criticalTable.durationPerformance(objectRows);

faceOrientationConf = criticalTable.orientationConfidence(faceRows);
faceDurationConf = criticalTable.durationConfidence(faceRows);

objectOrientationConf= criticalTable.orientationConfidence(objectRows);
objectDurationConf= criticalTable.durationConfidence(objectRows);

% confidence tabulate 

faceOrientation = tabulate(faceOrientationConf);
faceDuration = tabulate(faceDurationConf);
objectOrientation = tabulate(objectOrientationConf);
objectDuration = tabulate(objectDurationConf);

% get only the percentages for the confidence 

faceOrientationPercentage = faceOrientation(:,3)';
faceDurationPercentage = faceDuration(:,3)';
objectOrientationPercentage = objectOrientation(:,3)';
objectDurationPercentage = objectDuration(:,3)';

confidenceCounts = [faceOrientationPercentage;faceDurationPercentage;objectOrientationPercentage;objectDurationPercentage];

%critical confidence tables 

criticalConfidence = table(faceOrientationAccuracy,faceOrientationConf,faceDurationAccuracy,faceDurationConf,objectOrientationAccuracy,objectOrientationConf,...
    objectDurationAccuracy,objectDurationConf,'VariableNames',...
    {'faceOrientationPerf','faceOrientationConf','faceDurationPerf','faceDurationConf','objectOrientationPerf','objectOrientationConf','objectDurationPerf','objectDurationConf' ...
    });

%% plot confidence surprise

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

participantID = criticalTable.ParticipantID;

facePostOrientationConfidence =[];
facePostDurationConfidence = [];
objectPostOrientationConfidence =[];
objectPostDurationConfidence=[];

facePostOrientationPerf =[];
facePostDurationPerf =[];
objectPostOrientationPerf =[];
objecPostDurationPerf =[];

postHighConfidenceOrientation ={};
postLowConfidenceOrientation = {};

postHighConfidenceDuration ={};
postLowConfidenceDuration = {};


for i= 1: numel(participantID)

    currentParticipant = participantID(i); %get the subject number
    
    participantData = postTable(postTable.ParticipantID == currentParticipant,:);
    
    firstControl = participantData(1,:); %get the first control data
    
    % seperate confidence ratings for each condition
    
    if strcmp(firstControl.groupName, 'face') 
        
        facePostOrientationConfidence(end+1) = firstControl.orientationConfidence;
        facePostDurationConfidence(end+1)= firstControl.durationConfidence;
        
        facePostOrientationPerf(end+1)= firstControl.orientationAccuracy;
        facePostDurationPerf(end+1)= firstControl.durationAccuracy;
    
    elseif strcmp(firstControl.groupName,'object')

        objectPostOrientationConfidence(end+1) = firstControl.orientationConfidence;
        objectPostDurationConfidence(end+1)=firstControl.durationConfidence;

        objectPostOrientationPerf(end+1) = firstControl.orientationAccuracy;
        objecPostDurationPerf(end+1)= firstControl.durationAccuracy;    
    end

    % confidence and accuracy data 
    
   if firstControl.orientationConfidence >= 4 % get orientation ratings
      
      postHighConfidenceOrientation{end+1} = firstControl.orientationAccuracy;

   elseif firstControl.orientationConfidence <=2 
        
      postLowConfidenceOrientation{end+1} = firstControl.orientationAccuracy;
   end

   if firstControl.durationConfidence >=4 %get duration ratings 
      
      postHighConfidenceDuration{end+1} = firstControl.durationAccuracy;

   elseif firstControl.durationConfidence <=2 
      
      postLowConfidenceDuration{end+1} = firstControl.durationAccuracy;
   end


end

postOrientationConfidence = [facePostOrientationConfidence,objectPostOrientationConfidence];
postDurationConfidence = [facePostDurationConfidence,objectPostDurationConfidence];


%% seperate performance & confidence file 
postFaceOrientationPerf = facePostOrientationPerf';
postFaceDurationPerf = facePostDurationPerf';

postObjectOrientationPerf = objectPostOrientationPerf';
postObjectDurationPerf = objecPostDurationPerf';

postFaceOrientationConf= facePostOrientationConfidence';
postFaceDurationConf= facePostDurationConfidence';

postObjectOrientationConf=objectPostOrientationConfidence';
postObjectDurationConf= objectPostDurationConfidence';


%confidenceTable 

postConfidenceTable = table(postFaceOrientationPerf,postFaceOrientationConf,postFaceDurationPerf,postFaceDurationConf,...
  postObjectOrientationPerf,postObjectOrientationConf,postObjectDurationPerf,postObjectDurationConf,'VariableNames',{'postFaceOrientationPerf','postFaceOrientationConf','postFaceDurationPerf','postFaceDurationConf',...
  'postObjectOrientationPerf','postObjectOrientationConf','postObjectDurationPerf','postObjectDurationConf'});
%%

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

%% plot post confidence
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



%% confidence and performance allignment 

%accuracy values grouped by confidence  

%high confidence = 4,5 
%low confidence = 1,2

highConfidenceOrientation= {};      
highConfidenceDuration= {};

lowConfidenceOrientation= {};
lowConfidenceDuration={};


for i = 1:height(criticalTable)

    currentSubject = criticalTable(i,:);

   if currentSubject.orientationConfidence >= 4 % get orientation ratings
      
      highConfidenceOrientation{end+1} = currentSubject.orientationPerformance;

   elseif currentSubject.orientationConfidence <=2 
        
      lowConfidenceOrientation{end+1} = currentSubject.orientationPerformance;
   end

   if currentSubject.durationConfidence >=4 %get duration ratings 
      
      highConfidenceDuration{end+1} = currentSubject.durationPerformance;

   elseif currentSubject.durationConfidence <=2 
      
      lowConfidenceDuration{end+1} = currentSubject.durationPerformance;
   end

end

highOrientation = (sum(cell2mat(highConfidenceOrientation))/ numel(highConfidenceOrientation))*100;
lowOrientation = (sum(cell2mat(lowConfidenceOrientation))/ numel(lowConfidenceOrientation))*100;

highDuration = (sum(cell2mat(highConfidenceDuration))/ numel(highConfidenceDuration))*100;
lowDuration = (sum(cell2mat(lowConfidenceDuration))/ numel(lowConfidenceDuration))*100;

nrOfParticipants = [numel(highConfidenceOrientation),numel(lowConfidenceOrientation);numel(highConfidenceDuration),numel(lowConfidenceDuration)];

barGroup = [highOrientation,lowOrientation;highDuration,lowDuration]; %accuracy

%% figure 

figure;

confidenceAccuracyBar = bar(barGroup,'FaceColor','flat');

%add colors 

for i = 1:size(barGroup,2)

    confidenceAccuracyBar(1).CData(i,:)= highConfidence; %first bar is high confidence
    confidenceAccuracyBar(2).CData(i,:) = lowConfidence; %second bar is low confidence

end

%add text 

ylabel(' % Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probes','FontWeight','bold','FontSize', 14);
title('Surprise Group Probe Accuracy in Confidence Groups','FontSize', 15);

ylim([0 100]);
yticks([0 20 40 60 80 100]);
yline(50, '--k');
 
ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

legend('High Confidence','Low Confidence','Location','north');

% add no data text to the no data points 

for i = 1:size(confidenceAccuracyBar, 2) % Iterate over groups    
 
    for j = 1:size(confidenceAccuracyBar, 2) % Iterate over bars

        xtip = confidenceAccuracyBar(j).XEndPoints(i);
        ytip = 0;

        if nrOfParticipants(i, j) == 0 % if there is no participant in given group     
            
            ytip = ytip + 7;
 
           text(xtip, ytip, '- No Data', 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        else % if there are participants in the group, add their number
                       
           text(xtip, ytip + 7, ['N=' num2str(nrOfParticipants(i, j))],'HorizontalAlignment', 'center', 'VerticalAlignment', 'top','FontSize',10,'FontWeight','bold');
           
        end
        
    end
end

hold off;

%% first control probe & confidence match 

%get the numbers

highPostOrientation = (sum(cell2mat(postHighConfidenceOrientation))/ numel(postHighConfidenceOrientation))*100;
lowPostOrientation = (sum(cell2mat(postLowConfidenceOrientation))/ numel(postLowConfidenceOrientation))*100;

highPostDuration = (sum(cell2mat(postHighConfidenceDuration))/ numel(postHighConfidenceDuration))*100;
lowPostDuration = (sum(cell2mat(postLowConfidenceDuration))/ numel(postLowConfidenceDuration))*100;

postNrOfParticipants = [numel(postHighConfidenceOrientation),numel(postLowConfidenceOrientation);numel(postHighConfidenceDuration),numel(postLowConfidenceDuration)];

postBarGroup = [highPostOrientation,lowPostOrientation ;highPostDuration,lowPostDuration ]; %accuracy post 

% plot 

figure;

postConfidenceAccuracyBar = bar(postBarGroup,'FaceColor','flat');

%add colors 

for i = 1:size(postBarGroup,2)

    postConfidenceAccuracyBar(1).CData(i,:)= highConfidence; %first bar is high confidence
    postConfidenceAccuracyBar(2).CData(i,:) = lowConfidence; %second bar is low confidence

end

%add text 

ylabel(' % Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Probes','FontWeight','bold','FontSize', 14);
title('First Control Probe Accuracy in Confidence Groups','FontSize', 15);

ylim([0 100]);
yticks([0 20 40 60 80 100]);
yline(50, '--k');
 
ax = gca; % Get the current axes
ax.XTickLabel = {'Orientation', 'Duration'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Arial'; % Set the font name (change 'Arial' to your desired font)

legend('High Confidence','Low Confidence','Location','north');

% add no data text to the no data points 

for i = 1:size(postConfidenceAccuracyBar, 2) % Iterate over groups    
 
    for j = 1:size(postConfidenceAccuracyBar, 2) % Iterate over bars

        xtip = postConfidenceAccuracyBar(j).XEndPoints(i);
        ytip = 0;

        if postNrOfParticipants(i, j) == 0 % if there is no participant in given group     
            
            ytip = ytip + 7;
 
           text(xtip, ytip, '- No Data', 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        else % if there are participants in the group, add their number
                       
           text(xtip, ytip + 7, ['N=' num2str(postNrOfParticipants(i, j))],'HorizontalAlignment', 'center', 'VerticalAlignment', 'top','FontSize',10,'FontWeight','bold');
           
        end
        
    end
end

hold off;




%% Tabulates

% count confidence

surpriseOrientationConfidence = array2table(tabulate(criticalTable.orientationConfidence),"VariableNames",{'value','count','percent'});
surpriseDurationConfidence = array2table(tabulate(criticalTable.durationConfidence),"VariableNames",{'value','count','percent'});

PostOrientationConfidence = array2table(tabulate(postOrientationConfidence),"VariableNames",{'value','count','percent'});
PostDurationConfidence = array2table(tabulate(postDurationConfidence),"VariableNames",{'value','count','percent'});

% mind wandering responses


mindWanderingFace = criticalTable.mindwandering(faceRows);
mindWanderingObject = criticalTable.mindwandering(objectRows);

mindWanderingFace = array2table(tabulate(mindWanderingFace),"VariableNames",{'value','count','percent'});
mindWanderingObject = array2table(tabulate(mindWanderingObject),"VariableNames",{'value','count','percent'});



%save confidence and mind wandering 

confidenceMindWanderingPilot1 = struct();

confidenceMindWanderingPilot1.surpriseOrientationConfidence = surpriseOrientationConfidence;
confidenceMindWanderingPilot1.surpriseDurationConfidence = surpriseDurationConfidence;
confidenceMindWanderingPilot1.postOrientationConfidence = PostOrientationConfidence;
confidenceMindWanderingPilot1.postDurationConfidence = PostDurationConfidence;
confidenceMindWanderingPilot1.mindWanderingFace = mindWanderingFace;
confidenceMindWanderingPilot1.mindWanderingObject = mindWanderingObject;

%% save files

%confidence files 

criticalConfFileName = 'criticalConfidenceTableOnline.mat';
save(fullfile(processedDataOnline,criticalConfFileName),'criticalConfidence');

postConfFileName = 'postConfidenceTableOnline.mat';
save(fullfile(processedDataOnline,postConfFileName),'postConfidenceTable');

%mindWanderingFile
tabulateFile = 'confidenceMindWanderingPilot1Online.mat';
save(fullfile(processedDataOnline,tabulateFile),'confidenceMindWanderingPilot1');


