
function [contTable,chiResults,fisherExtract,McNemResult] = statsFunction(group1,group2,label1,label2,tailNr,mcNemar)

% this function receives 2 groups you want to compare as input, generates contingency table, conducts chi square of
% independence. As output it returns chi square and critical value together
% with the text stating significance of the results. It also returns
% ficherExtract results
% for tail number, add 1 for right-tailed fisher's exact test and add 2 for
% two-tailed fisher's exact test
% mcNemar == 1, means you want to conduct mcNemar test
% label 1 : one you expect to be higher (if you have directional hypothesis


% contingency table 

accuracyLabels = {'correct', 'wrong'}; 
groupNames = {'group1','group2'};

IV = categorical(group1,{label1,label2},groupNames);
DV = categorical(group2,[1, 0], accuracyLabels);


%conTable = [x,y];
[contTable, chi2, pValue] = crosstab(IV, DV);

% calculate critical chi 

alpha = 0.05;
df = 1; % nr of groups - 1 

criticalChi = chi2inv((1-alpha),df); % p is percentile, 1 is df

% compare the criticalChi with chi2 

if chi2 > criticalChi

    disp('chi result : groups are significantly different');
else
    disp('chi result : groups are not significanly different-chi');

end

% create the table 

chiResults = table(chi2,criticalChi,pValue,'VariableNames',{'chisquare','criticalChi','pvalue'});

%fisher's exact test 

%check whether there are zeros in the table 
    
    if any(contTable(:) == 0)
        disp('Zeros found in the table, adjusting counts.'); % add constant to avoid zeros - haldane-anscombe correction
        contTable = contTable + 1;
    end

    if tailNr == 1

    [h,p,stats] = fishertest(contTable,'Tail','right','Alpha',0.05);
    
    elseif tailNr == 2

    [h,p,stats] = fishertest(contTable,'Tail','both','Alpha',0.05);
    end
oddsRatio = stats.OddsRatio;
confInterval = stats.ConfidenceInterval;

if h == 1
    
    disp('Fisher Result : groups are significantly different');

elseif h == 0 
    
    disp('Fisher Result : groups are not significantly different');

end
fisherExtract = table(h,p,oddsRatio,confInterval(1),confInterval(2),'VariableNames',{'h','p','oddsRatio','lowerLimit','upperLimit'});

if mcNemar == 1 

% make contTable useful for the function 

% a = correct in both tests
% b = correct in the second wrong in the first
% c = correct in the first, incorrect in the second
% d = incorrect in both 

controlCorrect = contTable(1,1);
controlIncorrect = contTable(1,2);
criticalCorrect = contTable(2,1);
criticalIncorrect = contTable(2,2);

a = min(controlCorrect,criticalCorrect); %correct in both (get the minumum of corrects)
b = max((criticalCorrect-controlCorrect),0); % correct in the second, wrong in the first
c= max((controlCorrect - criticalCorrect),0); % correct in the first and wrong in the second, if negative turns zero
d = min(controlIncorrect,criticalIncorrect); % number that wrong in both

vector = [a,b,c,d];

%mcnemar(vector,alpha);
%McNemarextest(vector,2,alpha);

[midpValue] = mcNemEce(vector,alpha);


McNemResult = {vector,midpValue};



end

end