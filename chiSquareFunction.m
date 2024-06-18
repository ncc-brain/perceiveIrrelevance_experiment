
function [fisherExtract,chiResults] = chiSquareFunction(group1,group2)

% this function receives 2 contingency tables as input and conducts chi square of
% independence. As output it returns chi square and critical value together
% with the text stating significance of the results. It also returns
% ficherExtract results


% contingency table 

categoryNames = {'wrong', 'correct'}; 

group1 = categorical(group1, [0, 1], categoryNames);
group2 = categorical(group2,[0, 1], categoryNames);

[contTable, chi2, pValue] = crosstab(group1, group2);


% calculate critical chi 

alpha = 0.05;
df = 1; 

criticalChi = chi2inv((1-alpha),df); % p is percentile, 1 is df

% compare the criticalChi with chi2 

if chi2 > criticalChi

    disp('groups are significantly different')
else
    disp('groups are not significanly different')

end

% create the table 

chiResults = table(chi2,criticalChi,pValue,'VariableNames',{'chisquare','criticalChi','pvalue'});

%fisher's exact test 

[h,p,stats] = fishertest(contTable,"Tail","right","Alpha",0.05);

oddsRatio = stats.OddsRatio;
confInterval = stats.ConfidenceInterval;

fisherExtract = table(h,p,oddsRatio,confInterval(1),confInterval(2),'VariableNames',{'h','p','oddsRatio','lowerLimit','upperLimit'});

end