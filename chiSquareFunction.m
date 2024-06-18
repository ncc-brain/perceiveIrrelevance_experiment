
function [fisherExtract,chiResults] = chiSquareFunction(group1,group2,group1Name,group2Name)

% this function receives 2 contingency tables as input and conducts chi square of
% independence. As output it returns chi square and critical value together
% with the text stating significance of the results. It also returns
% ficherExtract results


% contingency table 

categoryNames = {'wrong', 'correct'}; 

group1 = categorical(group1, [0, 1], categoryNames);
group2 = categorical(group2,[0, 1], categoryNames);

[contTable, chi2, pValue, labels] = crosstab(group1, group2);



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



end