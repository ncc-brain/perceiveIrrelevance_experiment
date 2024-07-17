
function [midPvalue] = mcNemEce(vector,alpha)
% this function computes one tailed mid-p McNemar test 
% source : The McNemar test for binary matched-pairs data (Fagerland et
% al., 2013) - additional material (How to calculate the McNemar mid-p
% test)

                    %Group 1
%                --------------
%                  A        I
%                --------------
%             A    a        b     
%   Group 2
%             I    c        d     
%                --------------
%                


% A = accurate 
% I = inaccurate 
% group 1 = group 2 

% table must be 2X2, joint outcome probabilities 
% a = correct in both groups
% b = correct in the second but wrong in the first
% c = correct in the first, wrong in the second 
% d = incorrect in both 
% vector = [a,b,c,d];

% start with exact conditional test 

% get the discordant pairs (mcNem test does not care about concordant
% pairs)

b = vector(2);
c = vector(3);

discordantTotal = b+c; 
p = 0.5; % one sided exact conditional p value is probability of at least b succeses out of
         % n (discordant total) binomial trials 

if b < c % this test assumes b being equal or lower than c
exactPvalue = 2*binocdf(b,discordantTotal,p); 

% this assumes b < c, if b = c , p returns 1

elseif b == c 

    exactPvalue = 1;

elseif b > c

    disp(' ERROR : change the order of the comparison groups');

end

midPvalue = exactPvalue-0.5*binopdf(b,discordantTotal,p);

% significance check 

if midPvalue < alpha
   
    disp('groups are significantly different - McNem');
    disp(midPvalue);

elseif midPvalue > alpha 

    disp('groups are not significantly different, _McNem');
    disp(midPvalue);
end


