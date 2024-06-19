
% this script is for demographics 

clear
clc
addpath('./')
configIrrelevant;

cd(rawDataIrrelevant);
addpath(genpath(rawDataIrrelevant)); 

% age & gender information 

subjectFolders = dir(rawDataIrrelevant);
subjectFolders = subjectFolders([subjectFolders.isdir] & ~startsWith({subjectFolders.name}, '.'));

%get the age & gender information 

genderData = {};
ageData = [];

GenderMiss= {};
AgeMiss ={};

for i = 1:numel(subjectFolders)

    %reach the session data
    
    currentSubject = fullfile(rawDataIrrelevant,subjectFolders(i).name);
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



%sub126 is missing --> add it manually to the end of the gender & age data 

ageData = [ageData,31];

MissingGender = {'male'};

genderData{end+1} = MissingGender;

genderData = cellfun(@(x) x{1}, genderData, 'UniformOutput', false);


% demographics 

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
save(fullfile(processedDataIrrelevant,demographicsTableFile),'demographicsTable');

% Plots 

figure;

bar([countFemale,countMale],'FaceColor',DescriptiveGenderColour );
xlabel('Sex');
ylabel('Count');
xticklabels({'Female','Male'});
title('Sex Distribution');

%plot age

figure;
histogram(ageData,'FaceColor',DescriptiveAgeColor);
xlabel('Age');
ylabel('Count');
title('Age distribution');





