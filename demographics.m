
% this script is for demographics 

clear
clc
addpath('./')
configIrrelevant;

cd(rawDataOnline);
addpath(genpath(rawDataOnline)); 

% age & gender information 

subjectFolders = dir(rawDataOnline);
subjectFolders = subjectFolders([subjectFolders.isdir] & ~startsWith({subjectFolders.name}, '.'));

%get the age & gender information 

genderData = {};
ageData = [];

GenderMiss= {};
AgeMiss ={};

for i = 1:numel(subjectFolders)

    %reach the session data
    
    currentSubject = fullfile(rawDataOnline,subjectFolders(i).name);
    subjectFileContent = dir(currentSubject);
    subjectSessionFile = fullfile(currentSubject,'sessions.csv');
    sessionData = readtable(subjectSessionFile);

    %get gender data 

    if ~isnumeric(sessionData.SelectedGender)

        currentGender = sessionData.SelectedGender;
        genderData{i} = currentGender;
       

    else 
       GenderMiss= sprintf('Subject %d: Gender Data is missing\n', sessionData.Subject_Code(1));
    end

  %get age data 

  if ~isnan(sessionData.SelectedAge)
      currentAge = sessionData.SelectedAge;
      ageData(i) = currentAge;
  
  else 
      AgeMiss= sprintf('Subject %d: AgeData is missing\n', sessionData.Subject_Code(1));
  end
end

%%

%sub126 is missing --> add it manually to the end of the gender & age data 

%ageData = [ageData,31]; this line is for lab experiment 

%MissingGender = {'male'};

%genderData{end+1} = MissingGender;

genderData = cellfun(@(x) x{1}, genderData, 'UniformOutput', false);


%% 
%for the online experiment replace the age of 38 with 35 
for i = 1:numel(ageData)
    
    if ageData(i) == 38
        ageData(i) = 35;
    end
end

%% 


%%demographics 

%age

meanAge = mean(ageData);
medianAge = median(ageData);
sdAge = std(ageData);
youngestAge = min(ageData);
oldestAge = max(ageData);

%gender

countFemale = sum(strcmp(genderData,'female'));
countMale = sum(strcmp(genderData,'male'));

%tabulate(demographicsTable.Gender);


% combine age and gender

demographicsTable= table(genderData', ageData', 'VariableNames', {'Gender', 'Age'});

demographicsTableFile = 'demographicsTable.mat';
save(fullfile(processedDataLab,demographicsTableFile),'demographicsTable');

% Plots 

figure;

b= bar([countFemale,countMale],'FaceColor',DescriptiveGenderColour );
xlabel('Sex','FontWeight','bold','FontSize',14);
ylabel('Count','FontWeight','bold','FontSize',14);
xticklabels({'Female','Male'});
title('Sex Distribution','FontSize',16);
ylim([0,30]);
set(gca, 'YTick', 0:2:30);
%yticks= (0:2:30);

% add the numbers 
ytips = b.YData; % get the coordinates of the bar
labels = string(ytips);
text(1:length(ytips), ytips, labels, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', 'FontSize', 12); % Add labels

%plot age

figure;
histogram(ageData,'FaceColor',DescriptiveAgeColor);
xlabel('Age','FontWeight','bold','FontSize',14);
ylabel('Count','FontWeight','bold','Fontsize',14);
ylim([0 7]);
title('Age distribution','FontSize',16);





