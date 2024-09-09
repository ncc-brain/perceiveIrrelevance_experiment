
%this script is for checking the congruency effect on the first control
%orientation and duration performances  

clear
clc
addpath('./')
configIrrelevant;

cd(processedDataComb);
addpath(genpath(processedDataComb)); 

load("congruencyControl.mat"); 
load('postAccuracyTable.mat');
load("binomialTables.mat");
load('criticalTable.mat')


% first receive match the 


%congruent Face Group 

%sum performance for control 

faceOrientationCongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'face')));  
faceDurationCongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'face')));  

%sum performance for critical 

faceOrientationCritical = criticalTable.orientationPerformance(strcmp(criticalTable.groupName,'face'));
faceDurationCritical = criticalTable.durationPerformance(strcmp(criticalTable.groupName,'face'));

%Incongruent Face Group 


%congruent Object Group 


%Incongruent Object Group 



% face and congruecy (seperate control performance by congruency)



faceOrientationIncongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'face')));  
faceDurationIncongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'face')));  


%object and congruency (seperate control performance by congruency)

objectOrientationCongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'object')));  
objectDurationCongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'object')));  

objectOrientationIncongruent = sum(congruencyTable.orientationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'object')));  
objectDurationIncongruent = sum(congruencyTable.durationAccuracy(congruencyTable.congruency==0 & strcmp(congruencyTable.group,'object')));  

%congruencyBinomial 

congruentSum = numel(congruencyTable.orientationAccuracy(congruencyTable.congruency==1 & strcmp(congruencyTable.group,'face')));
% congruentSum is equal to incongruent sum and same for faces and objects

%face orientation
binoCongruentFaceOrientation = binomialFunction(congruentSum,faceOrientationCongruent,'faceOrientationCongruent');
binoIncongruentFaceOrientation = binomialFunction(congruentSum,faceOrientationIncongruent,'faceOrientationInCongruent');

%object orientation
binoCongruentObjectOrientation = binomialFunction(congruentSum,objectOrientationCongruent,'objectOrientationCongruent');
binoInCongruentObjectOrientation = binomialFunction(congruentSum,objectOrientationIncongruent,'objectOrientationInCongruent');

%face duration 
binoCongruentFaceDuration = binomialFunction(congruentSum,faceDurationCongruent,'faceDurationCongruent');
binoInCongruentFaceDuration = binomialFunction(congruentSum,faceDurationIncongruent,'faceDurationInCongruent');

%object duration 
binoCongruentObjectDuration = binomialFunction(congruentSum,objectDurationCongruent,'objectDurationCongruent');
binoInCongruentObjectDuration = binomialFunction(congruentSum,objectOrientationIncongruent,'objectDurationInCongruent');

% congruency Table 

congruencyTable = [binomialTables(:,'criticalFaceOrientation'),binoCongruentFaceOrientation,binoIncongruentFaceOrientation,binomialTables(:,'criticalFaceDuration'),binoCongruentFaceDuration,binoInCongruentFaceDuration,...
   binomialTables(:,'criticalObjectOrientation'),binoCongruentObjectOrientation,binoInCongruentObjectOrientation,binomialTables(:,'criticalObjectDuration'),binoCongruentObjectDuration,binoInCongruentObjectDuration];

%save the congruenyTable

congruencyTableFile = 'congruencyTable.mat';
save(fullfile(processedDataComb,congruencyTableFile),'congruencyTable');


% get the performance in critical trial by congruency




congruencyCritical = table((1:72)',congruencyTable.congruency,criticalTable.orientationPerformance,criticalTable.durationPerformance,criticalTable.groupName,'VariableNames',{'participant Nr','congruency','orientation','duration','groupName'});



%plot the binomials 

ChanceLevel = 0.5;
PValue = 0.05;

%face group Orientation

faceOrientationAccuracy = [congruencyTable.criticalFaceOrientation(1),congruencyTable.faceOrientationCongruent(1),congruencyTable.faceOrientationInCongruent(1)]; % first value is the accuracy 
faceOrientationPValue = [congruencyTable.criticalFaceOrientation(4),congruencyTable.faceOrientationCongruent(4),congruencyTable.faceOrientationInCongruent(4)]; %forth value is the P value 

%object group Orientation

objectOrientationAccuracy = [congruencyTable.criticalObjectOrientation(1),congruencyTable.objectOrientationCongruent(1),congruencyTable.objectOrientationInCongruent(1)]; % first value is the accuracy 
objectOrientationPValue = [congruencyTable.criticalObjectOrientation(4),congruencyTable.objectOrientationCongruent(4),congruencyTable.objectOrientationInCongruent(4)]; %forth value is the P value 


%face group duration 

faceDurationAccuracy = [congruencyTable.criticalFaceDuration(1),congruencyTable.faceDurationCongruent(1),congruencyTable.faceDurationInCongruent(1)];
faceDurationPValue = [congruencyTable.criticalFaceDuration(4),congruencyTable.faceDurationCongruent(4),congruencyTable.faceDurationInCongruent(4)];

%object group duration

objectDurationAccuracy =[congruencyTable.criticalObjectDuration(1),congruencyTable.objectDurationCongruent(1),congruencyTable.objectDurationInCongruent(1)];
objectDurationPValue = [congruencyTable.criticalObjectDuration(4),congruencyTable.objectDurationCongruent(4),congruencyTable.objectDurationInCongruent(4)];

% face orientation bar

figure;

faceBars = bar(faceOrientationAccuracy,'FaceColor','flat'); % plot the facebars

barColors = [criticalColor;congruentColor;incongruentColor];

faceBars.CData = barColors; % add the colors for the color code

hold on;

yline(ChanceLevel, '--k'); % add the line to the chance level 
ylim([0 1]);
yticks([0, 0.5, 1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Trial Category','FontWeight','bold','FontSize', 14);
title('Face Orientation Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Critical', 'Congruent Control', 'Incongruent Control'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; % Set the font name 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 

%add the starts for the statistical testing

for i = 1:numel(faceOrientationAccuracy) 
    
    if faceOrientationPValue(i) < PValue
        text(i-0.05 - Astoffset,  faceOrientationAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

hold off;


% object orientation bar


figure;

objectBars = bar(objectOrientationAccuracy,'FaceColor','flat'); % plot the facebars

objectBars.CData = barColors; % add the colors for the color code

hold on;

yline(ChanceLevel, '--k'); % add the line to the chance level 
ylim([0 1]);
yticks([0, 0.5, 1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Trial Category','FontWeight','bold','FontSize', 14);
title('Object Orientation Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Critical', 'Congruent Control', 'Incongruent Control'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; % Set the font name 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 

%add the starts for the statistical testing

for i = 1:numel(objectOrientationAccuracy) 
    
    if objectOrientationPValue(i) < PValue
        text(i-0.05 - Astoffset,  objectOrientationAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

hold off;

% duration bars

%face

figure;

faceDurationBars = bar(faceDurationAccuracy,'FaceColor','flat'); % plot the facebars

barColors = [criticalColor;congruentColor;incongruentColor];

faceDurationBars.CData = barColors; % add the colors for the color code

hold on;

yline(ChanceLevel, '--k'); % add the line to the chance level 
ylim([0 1]);
yticks([0, 0.5, 1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Trial Category','FontWeight','bold','FontSize', 14);
title('Face Duration Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Critical', 'Congruent Control', 'Incongruent Control'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; % Set the font name 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 

%add the starts for the statistical testing

for i = 1:numel(faceDurationAccuracy) 
    
    if faceDurationPValue(i) < PValue
        text(i-0.05 - Astoffset,  faceDurationAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

hold off;


%object 


figure;

objectDurationBars = bar(objectDurationAccuracy,'FaceColor','flat'); % plot the facebars

objectDurationBars.CData = barColors; % add the colors for the color code

hold on;

yline(ChanceLevel, '--k'); % add the line to the chance level 
ylim([0 1]);
yticks([0, 0.5, 1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Trial Category','FontWeight','bold','FontSize', 14);
title('Object Duration Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Critical', 'Congruent Control', 'Incongruent Control'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; % Set the font name 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 

%add the starts for the statistical testing

for i = 1:numel(objectDurationAccuracy) 
    
    if objectDurationPValue(i) < PValue
        text(i-0.05 - Astoffset,  objectDurationAccuracy(i) - 0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

hold off;


%statistical testing 


%face comparisons (within participant performance)







