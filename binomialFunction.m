
function [p] = binomialFunction(x, n, p0)

% this function does the hypothesis testing for the binomial test

% x : number of successful performance
% n : number of trials 
% p0 : chance level 

p = 2 * min(binocdf(x, n, p0), 1 - binocdf(x-1, n, p0));


end