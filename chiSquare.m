
% in this script I will do 

% 1- create contingency tables for orientation & duration 

% 2- run chi square test for independence 


clear
clc
addpath('./')
configIrrelevant;

cd(processedDataIrrelevant)
addpath(genpath(processedDataIrrelevant)); 

faceCritical = load("faceCritical.mat");
faceCritical = faceCritical.faceCriticalTrial;

objectCritical = load('objectCritical.mat');
objectCritical = objectCritical.objectCriticalTrial;


%% Contingency tables 

orientationAllFace = [];
durationAllFace = [];
orientationAllObject =[];
durationAllObject = [];


for i = 1:numel(faceCritical) 

    currentCellFace = faceCritical{i};
    currentOrientationFace = currentCellFace.orientationPerformance;
    currentDurationFace = currentCellFace.durationPerformance;
    orientationAllFace(i) = currentOrientationFace;
    durationAllFace (i) = currentDurationFace;
    

end



for j = 1:numel(objectCritical)


    currentCell = objectCritical{j};
    currentOrientation = currentCell.orientationPerformance;
    currentDuration = currentCell.durationPerformance;
    orientationAllObject(j) = currentOrientation;
    durationAllObject(j) = currentDuration;
    
end

%generate contingency tables 

AllOrientation = [orientationAllFace,orientationAllObject];
AllDuration = [durationAllFace,durationAllObject];


categoryNames = {'wrong', 'correct'}; 


AllOrientation = categorical(AllOrientation, [0, 1], categoryNames);
AllDuration = categorical(AllDuration,[0, 1], categoryNames);

[contTable, ~, ~, labels] = crosstab(AllOrientation, AllDuration);

% Manually create unique row and column labels
orientationLabels = {'OrientationWrong', 'OrientationCorrect'};
durationLabels = {'DurationWrong', 'DurationCorrect'};

contingencyTable = array2table(contTable, 'VariableNames', durationLabels, 'RowNames', orientationLabels);

contingencyTableFile = 'contingencyTable.mat'; %save processed data
save(fullfile(processedDataIrrelevant,contingencyTableFile),'contingencyTable');


% chi square for independence

% null hypothsis : orientation and duration are not related
% h1 : orientation & duration are related. 

% step 1 

% calculate the expected frequencies 

totalObservation = sum(contTable(:));

rowTotal = [];
colTotal = [];
expectedTable = []; % expected values if two variables are unrelated. 


for i = 1:size(contTable,1)
    for j = 1:size(contTable,2) % contTable involves observed values. 
        rowTotal = sum(contTable(i, :));     % row r total
        colTotal = sum(contTable(:, j));     % Column c total
        expectedTable(i, j) = (rowTotal * colTotal) / totalObservation; % here I calculate the expected frequency if variables are unrelated
    end
end


% calculate chi square 

% X2 = ((observed-expected)/expected)2 

 cqiSquareFirstStep = [];

for i = 1:size(contTable,1)

     for j = 1:size(contTable,2)

         cqiSquareFirstStep(i,j) = ((contTable(i,j) - expectedTable(i,j))^2)/(expectedTable(i,j));

     end

end

cqiSquare = sum(cqiSquareFirstStep(:));

% critical chi square value ( df and alpha is necessery)

criticalChi = chi2inv((1-0.05),1); % p is percentile, 1 is df


if cqiSquare > criticalChi

    disp('groups are significantly different')
else
    disp('groups are not significanly different')

end

%Fischer's exact test 

[h,p,stats] = fishertest(contTable);
