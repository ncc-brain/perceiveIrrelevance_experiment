
function[BinomialTable] = binomialFunction(totalProbes,correctProbes,group)

% this function gets nr of probes and nr of correct probes and calculates
% binofit and binocdf, returns BinomialTable. 

%  totalProbes : total data set for given category - nr of times given
%  probe is asked
%  correctProbes : total correct responses for the given probe
%  group : category you conduct the binomial test, should be string (e.g.
%  'face' or 'orientation' 


alpha = 0.05;
chanceLevel = 0.5; 

%binofit (calculates proportion of success & confidence intervals) 

[phat, pci] = binofit(correctProbes,totalProbes , alpha);


%binocdf (returns p value for hypothesis testing)

PValue = 1-binocdf(correctProbes-1,totalProbes,chanceLevel); 

BinomialTable = table([phat; pci(1); pci(2);PValue], 'VariableNames', {group}, 'RowNames', {'phat', 'LowerBound', 'UpperBound','PValue'});

end