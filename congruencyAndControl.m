
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


% first combine the critical performance with control performance using
% participant ID 

critical = table(criticalTable.orientationPerformance,criticalTable.durationPerformance,criticalTable.ParticipantID,'VariableNames',{'orientationCritical','durationCritical','ParticipantID'});

congruencyCritical = innerjoin(critical,congruencyTable,'Keys','ParticipantID'); % combine the tables by matching the participant ID

%% performance seperated for each group and probe 
% congruent face

% sum performance for control 

faceOrientationCongruent = sum(congruencyCritical.orientationControlAccuracy(congruencyCritical.congruency==1 & strcmp(congruencyCritical.group,'face')));  
faceDurationCongruent = sum(congruencyCritical.durationControlAccuracy(congruencyCritical.congruency==1 & strcmp(congruencyCritical.group,'face')));  

% sum performance for critical 

faceOrientationCongruentCritical = sum(congruencyCritical.orientationCritical(congruencyCritical.congruency==1 & strcmp(congruencyCritical.group,'face')));
faceDurationCongruentCritical = sum(congruencyCritical.durationCritical(congruencyCritical.congruency == 1 & strcmp(congruencyCritical.group,'face')));

% incongruent face

% sum performance for control

faceOrientationInCongruent = sum(congruencyCritical.orientationControlAccuracy(congruencyCritical.congruency==0 & strcmp(congruencyCritical.group,'face')));  
faceDurationInCongruent = sum(congruencyCritical.durationControlAccuracy(congruencyCritical.congruency==0 & strcmp(congruencyCritical.group,'face')));  

% sum performance for critical 

faceOrientationInCongruentCritical = sum(congruencyCritical.orientationCritical(congruencyCritical.congruency==0 & strcmp(congruencyCritical.group,'face')));
faceDurationInCongruentCritical = sum(congruencyCritical.durationCritical(congruencyCritical.congruency == 0 & strcmp(congruencyCritical.group,'face')));

% congruent object

% sum performance for control 

objectOrientationCongruent = sum(congruencyCritical.orientationControlAccuracy(congruencyCritical.congruency==1 & strcmp(congruencyCritical.group,'object')));  
objectDurationCongruent = sum(congruencyCritical.durationControlAccuracy(congruencyCritical.congruency==1 & strcmp(congruencyCritical.group,'object')));  

% sum performance for critical 

objectOrientationCongruentCritical = sum(congruencyCritical.orientationCritical(congruencyCritical.congruency==1 & strcmp(congruencyCritical.group,'object')));
objectDurationCongruentCritical = sum(congruencyCritical.durationCritical(congruencyCritical.congruency == 1 & strcmp(congruencyCritical.group,'object')));

% Incongruent object 

objectOrientationInCongruent = sum(congruencyCritical.orientationControlAccuracy(congruencyCritical.congruency==0 & strcmp(congruencyCritical.group,'object')));  
objectDurationInCongruent = sum(congruencyCritical.durationControlAccuracy(congruencyCritical.congruency==0 & strcmp(congruencyCritical.group,'object')));  

% sum performance for critical 

objectOrientationInCongruentCritical = sum(congruencyCritical.orientationCritical(congruencyCritical.congruency==0 & strcmp(congruencyCritical.group,'object')));
objectDurationInCongruentCritical = sum(congruencyCritical.durationCritical(congruencyCritical.congruency == 0 & strcmp(congruencyCritical.group,'object')));

%% congruencyBinomial 

congruentSum = numel(congruencyCritical.orientationControlAccuracy(congruencyCritical.congruency==1 & strcmp(congruencyCritical.group,'face')));
% congruentSum is equal to incongruent sum and same for faces and objects

%face orientation
binoCongruentFaceOrientation = binomialFunction(congruentSum,faceOrientationCongruent,'faceOrientationCongruent');
binoInCongruentFaceOrientation = binomialFunction(congruentSum,faceOrientationInCongruent,'faceOrientationInCongruent');

binoCriticalCongruentFaceOrientation = binomialFunction(congruentSum,faceOrientationCongruentCritical,'faceOrientationCriticalCongruent');
binoCriticalInCongruentFaceOrientation = binomialFunction(congruentSum,faceOrientationInCongruentCritical,'faceOrientationCriticalInCongruent');

%object orientation
binoCongruentObjectOrientation = binomialFunction(congruentSum,objectOrientationCongruent,'objectOrientationCongruent');
binoInCongruentObjectOrientation = binomialFunction(congruentSum,objectOrientationInCongruent,'objectOrientationInCongruent');

binoCriticalCongruentObjectOrientation = binomialFunction(congruentSum,objectOrientationCongruentCritical,'objectOrientationCriticalCongruent');
binoCriticalInCongruentObjectOrientation = binomialFunction(congruentSum,objectOrientationInCongruentCritical,'objectOrientationCriticalInCongruent');

%face duration 
binoCongruentFaceDuration = binomialFunction(congruentSum,faceDurationCongruent,'faceDurationCongruent');
binoInCongruentFaceDuration = binomialFunction(congruentSum,faceDurationInCongruent,'faceDurationInCongruent');

binoCriticalCongruentFaceDuration = binomialFunction(congruentSum,faceDurationCongruentCritical,'faceDurationCriticalCongruent');
binoCriticalInCongruentFaceDuration = binomialFunction(congruentSum,faceDurationInCongruentCritical,'faceDurationCriticalInCongruent');

%object duration 
binoCongruentObjectDuration = binomialFunction(congruentSum,objectDurationCongruent,'objectDurationCongruent');
binoInCongruentObjectDuration = binomialFunction(congruentSum,objectDurationInCongruent,'objectDurationInCongruent');

binoCriticalCongruentObjectDuration = binomialFunction(congruentSum,objectDurationCongruentCritical,'objectDurationCriticalCongruent');
binoCriticalInCongruentObjectDuration = binomialFunction(congruentSum,objectDurationInCongruentCritical,'objectDurationCriticalInCongruent');

% congruency Table 

congruencyBinom = [binoCriticalCongruentFaceOrientation,binoCriticalInCongruentFaceOrientation,binoCongruentFaceOrientation,binoInCongruentFaceOrientation,binoCriticalCongruentFaceDuration,binoCriticalInCongruentFaceDuration,binoCongruentFaceDuration,binoInCongruentFaceDuration,...
   binoCriticalCongruentObjectOrientation,binoCriticalInCongruentObjectOrientation,binoCongruentObjectOrientation,binoInCongruentObjectOrientation,binoCriticalCongruentObjectDuration,binoCriticalInCongruentObjectDuration,binoCongruentObjectDuration,binoInCongruentObjectDuration];

%save the congruenyTable

congruencyBinomFile = 'congruencyBinom.mat';
save(fullfile(processedDataComb,congruencyBinomFile),'congruencyBinom');

%% face orientation plots

%plot the binomials 

ChanceLevel = 0.5;
PValue = 0.05;

% face congruent orientation  

faceCongruentAccuracy = [congruencyBinom.faceOrientationCriticalCongruent(1),congruencyBinom.faceOrientationCongruent(1)];
faceCongruentPValues = [congruencyBinom.faceOrientationCriticalCongruent(4),congruencyBinom.faceOrientationCongruent(4)];

% face incongruent orientation  

faceIncongruentAccuracy = [congruencyBinom.faceOrientationCriticalInCongruent(1),congruencyBinom.faceOrientationInCongruent(1)];
faceIncongruentPValues = [congruencyBinom.faceOrientationCriticalInCongruent(4),congruencyBinom.faceOrientationInCongruent(4)];

faceOrientationAccuracy = [faceCongruentAccuracy; faceIncongruentAccuracy];

BarColors = [repmat(congruentColor, 2, 1); repmat(incongruentColor, 2, 1)];

figure; % figure for the subplots 

faceOrientationPlot = bar(faceOrientationAccuracy, 'grouped');

hold on;

faceOrientationPlot(1).FaceColor = criticalColor; 
faceOrientationPlot(2).FaceColor = controlColor;

yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);
ylim([0,1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Congruency','FontWeight','bold','FontSize', 14);
title('Face Orientation Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Congruent', 'Incongruent'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(faceCongruentAccuracy) 

    if faceCongruentPValues(i) < PValue
        text(i-0.05 - Astoffset, faceCongruentAccuracy(i) -0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
   
    if faceIncongruentPValues(i) < PValue
        text(i+0.25 - Astoffset, faceIncongruentAccuracy(i)-0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Critical', 'First Control', 'Location', 'northeast', 'Position', [0.80, 0.85, 0.03, 0.05]);

hold off;


%% object orientation plots 

%plot the binomials 

ChanceLevel = 0.5;
PValue = 0.05;

% object congruent orientation  

objectCongruentAccuracy = [congruencyBinom.objectOrientationCriticalCongruent(1),congruencyBinom.objectOrientationCongruent(1)];
objectCongruentPValues = [congruencyBinom.objectOrientationCriticalCongruent(4),congruencyBinom.objectOrientationCongruent(4)];

% object incongruent orientation  

objectIncongruentAccuracy = [congruencyBinom.objectOrientationCriticalInCongruent(1),congruencyBinom.objectOrientationInCongruent(1)];
objectIncongruentPValues = [congruencyBinom.objectOrientationCriticalInCongruent(4),congruencyBinom.objectOrientationInCongruent(4)];

objectOrientationAccuracy = [objectCongruentAccuracy; objectIncongruentAccuracy];

BarColors = [repmat(congruentColor, 2, 1); repmat(incongruentColor, 2, 1)];

figure; % figure for the subplots 

objectOrientationPlot = bar(objectOrientationAccuracy, 'grouped');

hold on;

objectOrientationPlot(1).FaceColor = criticalColor; 
objectOrientationPlot(2).FaceColor = controlColor;

yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);
ylim([0,1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Congruency','FontWeight','bold','FontSize', 14);
title('Object Orientation Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Congruent', 'Incongruent'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(objectCongruentAccuracy) 
    
    if objectCongruentPValues(i) < PValue
        text(i-0.75 - Astoffset, objectCongruentAccuracy(i) -0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
    
    if objectIncongruentPValues(i) < PValue
        text(i+0.25 - Astoffset, objectIncongruentAccuracy(i)-0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Critical', 'First Control', 'Location', 'northwest', 'Position',[0.22, 0.85, 0.03, 0.05]);

hold off;


%% face duration 

%plot the binomials 

ChanceLevel = 0.5;
PValue = 0.05;

% face congruent duration 

faceCongruentDurationAccuracy = [congruencyBinom.faceDurationCriticalCongruent(1),congruencyBinom.faceDurationCongruent(1)];
faceCongruentDurationPValues = [congruencyBinom.faceDurationCriticalCongruent(4),congruencyBinom.faceDurationCongruent(4)];

% face incongruent duration 

faceIncongruentDurationAccuracy = [congruencyBinom.faceDurationCriticalInCongruent(1),congruencyBinom.faceDurationInCongruent(1)];
faceIncongruentDurationPValues = [congruencyBinom.faceDurationCriticalInCongruent(4),congruencyBinom.faceDurationInCongruent(4)];

faceDurationAccuracy = [faceCongruentDurationAccuracy; faceIncongruentDurationAccuracy];

BarColors = [repmat(congruentColor, 2, 1); repmat(incongruentColor, 2, 1)];

figure; % figure for the subplots 

faceDurationPlot = bar(faceDurationAccuracy, 'grouped');

hold on;

faceDurationPlot(1).FaceColor = criticalColor; 
faceDurationPlot(2).FaceColor = controlColor;

yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);
ylim([0,1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Congruency','FontWeight','bold','FontSize', 14);
title('Face Duration Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Congruent', 'Incongruent'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(faceCongruentDurationAccuracy) 
    
    if faceCongruentDurationPValues(i) < PValue
        text(i-0.05 - Astoffset, faceCongruentDurationAccuracy(i) -0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end

    if faceIncongruentDurationPValues(i) < PValue
        text(i+0.25 - Astoffset, faceIncongruentDurationAccuracy(i)-0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Critical', 'First Control', 'Location', 'northeast', 'Position', [0.80, 0.85, 0.03, 0.05]);

hold off;

%% object duration 

%plot the binomials 

ChanceLevel = 0.5;
PValue = 0.05;

% object congruent duration  

objectCongruentDurationAccuracy = [congruencyBinom.objectDurationCriticalCongruent(1),congruencyBinom.objectDurationCongruent(1)];
objectCongruentDurationPValues = [congruencyBinom.objectDurationCriticalCongruent(4),congruencyBinom.objectDurationCongruent(4)];

% object incongruent orientation 

objectIncongruentDurationAccuracy = [congruencyBinom.objectDurationCriticalInCongruent(1),congruencyBinom.objectDurationInCongruent(1)];
objectIncongruentDurationPValues = [congruencyBinom.objectDurationCriticalInCongruent(4),congruencyBinom.objectDurationInCongruent(4)];

objectDurationAccuracy = [objectCongruentDurationAccuracy; objectIncongruentDurationAccuracy];

BarColors = [repmat(congruentColor, 2, 1); repmat(incongruentColor, 2, 1)];

figure; % figure for the subplots 

objectDurationPlot = bar(objectDurationAccuracy, 'grouped');

hold on;

objectDurationPlot(1).FaceColor = criticalColor; 
objectDurationPlot(2).FaceColor = controlColor;

yline(ChanceLevel, '--k'); % add the line to the chance level 
yticks([0, 0.5, 1]);
ylim([0,1]);

ylabel('Accuracy','FontWeight','bold','FontSize', 14);  % add labels and titles
xlabel('Congruency','FontWeight','bold','FontSize', 14);
title('Object Duration Report Performance','FontSize', 16);

ax = gca; % Get the current axes
ax.XTickLabel = {'Congruent', 'Incongruent'}; % Set the xticklabels
ax.FontSize = 12; % Adjust the font size as needed
ax.FontName = 'Times New Roman'; 

Astoffset = 0.1; % asterisks ofset to decide the placement of it 


for i = 1:numel(objectCongruentDurationAccuracy) 
    
    if objectCongruentDurationPValues(i) < PValue
        text(i-0.05 - Astoffset, objectCongruentDurationAccuracy(i) -0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end

    if objectIncongruentDurationPValues(i) < PValue
        text(i+0.25 - Astoffset, objectIncongruentDurationAccuracy(i)-0.05, '*', 'FontSize', 25, 'HorizontalAlignment', 'center');
    end
end

legend('Critical', 'First Control', 'Location', 'northeast', 'Position', [0.22, 0.85, 0.03, 0.05]);

hold off;

%% stats 

% compare face congruent and face incongruent for orientation (whether
% performance changed or not) 
 
% congruentFaceOrientation 

congruentFaceOrientation = congruencyCritical(strcmp(congruencyCritical.group,'face') & congruencyCritical.congruency == 1,:);

orientationFaceCritical = table(congruentFaceOrientation.orientationCritical,repmat({'critical'},height(congruentFaceOrientation),1),'VariableNames',{'accuracy','trialName'});
orientationFaceControl = table(congruentFaceOrientation.orientationControlAccuracy,repmat({'control'},height(congruentFaceOrientation),1),'VariableNames',{'accuracy','trialName'});

orientationFaceCongruent = [orientationFaceCritical;orientationFaceControl];

[congFaceOrientation ,~ ,~ ,McNemCongFaceOrientation] = statsFunction(orientationFaceCongruent.trialName,orientationFaceCongruent.accuracy,'critical','control',2,1); % give the data ensuring b < c (if not b = c) and check whether b+c>10 for power 

%% incongruentFaceOrientation 

IncongruentFaceOrientation = congruencyCritical(strcmp(congruencyCritical.group,'face') & congruencyCritical.congruency == 0,:);

orientationFaceCriticalInc = table(IncongruentFaceOrientation.orientationCritical,repmat({'critical'},height(IncongruentFaceOrientation),1),'VariableNames',{'accuracy','trialName'});
orientationFaceControlInc = table(IncongruentFaceOrientation.orientationControlAccuracy,repmat({'control'},height(IncongruentFaceOrientation),1),'VariableNames',{'accuracy','trialName'});

orientationFaceInCongruent = [orientationFaceCriticalInc;orientationFaceControlInc];

[IncongFaceOrientation ,~ ,~ ,McNemInCongFaceOrientation] = statsFunction(orientationFaceInCongruent.trialName,orientationFaceInCongruent.accuracy,'critical','control',2,1);


%% congruent Object Orientation 


congruentObjectOrientation = congruencyCritical(strcmp(congruencyCritical.group,'object') & congruencyCritical.congruency == 1,:);

orientationObjectCritical = table(congruentObjectOrientation.orientationCritical,repmat({'critical'},height(congruentObjectOrientation),1),'VariableNames',{'accuracy','trialName'});
orientationObjectControl = table(congruentObjectOrientation.orientationControlAccuracy,repmat({'control'},height(congruentObjectOrientation),1),'VariableNames',{'accuracy','trialName'});

orientationObjectCongruent = [orientationObjectCritical;orientationObjectControl];

[congObjectOrientation ,~ ,~ ,McNemCongObjectOrientation] = statsFunction(orientationObjectCongruent.trialName,orientationObjectCongruent.accuracy,'control','critical',2,1);

%% Incongruent Object Orientation 

IncongruentObjectOrientation = congruencyCritical(strcmp(congruencyCritical.group,'object') & congruencyCritical.congruency == 0,:);

orientationObjectCriticalInc = table(IncongruentObjectOrientation.orientationCritical,repmat({'critical'},height(IncongruentObjectOrientation),1),'VariableNames',{'accuracy','trialName'});
orientationObjectControlInc = table(IncongruentObjectOrientation.orientationControlAccuracy,repmat({'control'},height(IncongruentObjectOrientation),1),'VariableNames',{'accuracy','trialName'});

orientationObjectInCongruent = [orientationObjectCriticalInc;orientationObjectControlInc];

[IncongObjectOrientation ,~ ,~ ,McNemInCongObjectOrientation] = statsFunction(orientationObjectInCongruent.trialName,orientationObjectInCongruent.accuracy,'control','critical',2,1);

%% congruent Face Duration

congruentFaceDuration = congruencyCritical(strcmp(congruencyCritical.group,'face') & congruencyCritical.congruency == 1,:);

durationFaceCritical = table(congruentFaceDuration.durationCritical,repmat({'critical'},height(congruentFaceDuration),1),'VariableNames',{'accuracy','trialName'});
durationFaceControl = table(congruentFaceDuration.durationControlAccuracy,repmat({'control'},height(congruentFaceDuration),1),'VariableNames',{'accuracy','trialName'});

durationFaceCongruent = [durationFaceCritical;durationFaceControl];

[congFaceDuration ,~ ,~ ,McNemCongFaceDuration] = statsFunction(durationFaceCongruent.trialName,durationFaceCongruent.accuracy,'control','critical',2,1); 

%% incongruent Face Duration 

IncongruentFaceDuration = congruencyCritical(strcmp(congruencyCritical.group,'face') & congruencyCritical.congruency == 0,:);

durationFaceCriticalInc = table(IncongruentFaceDuration.durationCritical,repmat({'critical'},height(IncongruentFaceDuration),1),'VariableNames',{'accuracy','trialName'});
durationFaceControlInc = table(IncongruentFaceDuration.durationControlAccuracy,repmat({'control'},height(IncongruentFaceDuration),1),'VariableNames',{'accuracy','trialName'});

durationFaceInCongruent = [durationFaceCriticalInc;durationFaceControlInc];

[IncongFaceDuration ,~ ,~ ,McNemInCongFaceDuration] = statsFunction(durationFaceInCongruent.trialName,durationFaceInCongruent.accuracy,'critical','control',2,1); 

%% congruent Object Duration 

congruentObjectDuration = congruencyCritical(strcmp(congruencyCritical.group,'object') & congruencyCritical.congruency == 1,:);

durationObjectCritical = table(congruentObjectDuration.durationCritical,repmat({'critical'},height(congruentObjectDuration),1),'VariableNames',{'accuracy','trialName'});
durationObjectControl = table(congruentObjectDuration.durationControlAccuracy,repmat({'control'},height(congruentObjectDuration),1),'VariableNames',{'accuracy','trialName'});

durationObjectCongruent = [durationObjectCritical;durationObjectControl];

[congObjectDuration ,~ ,~ ,McNemCongObjectDuration] = statsFunction(durationObjectCongruent.trialName,durationObjectCongruent.accuracy,'critical','control',2,1); 


%% Incongruent Object Duration 

IncongruentObjectDuration = congruencyCritical(strcmp(congruencyCritical.group,'object') & congruencyCritical.congruency == 0,:);

durationObjectCriticalInc = table(IncongruentObjectDuration.durationCritical,repmat({'critical'},height(IncongruentObjectDuration),1),'VariableNames',{'accuracy','trialName'});
durationObjectControlInc = table(IncongruentObjectDuration.durationControlAccuracy,repmat({'control'},height(IncongruentObjectDuration),1),'VariableNames',{'accuracy','trialName'});

durationObjectInCongruent = [durationObjectCriticalInc;durationObjectControlInc];

[IncongObjectDuration ,~ ,~ ,McNemInCongObjectDuration] = statsFunction(durationObjectInCongruent.trialName,durationObjectInCongruent.accuracy,'critical','control',2,1); 



