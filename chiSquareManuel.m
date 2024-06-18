

% Here I calculate chi square manually 

% (chi2 function combined with crosstab does the same but I did not want
% to delete this ) 

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
