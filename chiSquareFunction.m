
function [contTable,chiResults,fisherExtract] = chiSquareFunction(group1,group2)

% this function receives 2 groups you want to compare as input, generates contingency table, conducts chi square of
% independence. As output it returns chi square and critical value together
% with the text stating significance of the results. It also returns
% ficherExtract results


% contingency table 

categoryNames = {'wrong', 'correct'}; 
groupNames = {'face','object'};

group1 = categorical(group1, [0, 1], groupNames);
group2 = categorical(group2,[0, 1], categoryNames);

x=countcats(group1);
y=countcats(group2);

IV = categories (group1 & group2);
DV = accuracy ;

conTable = [x,y];
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

[h,p,stats] = fishertest(contTable,'Tail','both','Alpha',0.05);

oddsRatio = stats.OddsRatio;
confInterval = stats.ConfidenceInterval;

if h == 1
    
    disp('Fisher Result : groups are significantly different');

elseif h == 0 
    
    disp('Fisher Result : groups are not significantly different');

end
fisherExtract = table(h,p,oddsRatio,confInterval(1),confInterval(2),'VariableNames',{'h','p','oddsRatio','lowerLimit','upperLimit'});

end