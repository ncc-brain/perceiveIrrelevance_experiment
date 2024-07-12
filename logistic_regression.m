% Load the critical table:
load('P:\2023-0383-PerceiveIrrelevance\03data\perceivedIrrelevance\derivatives\criticalTable.mat')

%% Format the table:
y = zeros(height(criticalTable) * 2, 1);
cate = cell(height(criticalTable) * 2, 1);
probe = cell(height(criticalTable) * 2, 1);
subject = cell(height(criticalTable) * 2, 1);
ctr = 1;
for i = 1:height(criticalTable)
    y(ctr) = criticalTable.orientationPerformance(i);
    y(ctr + 1) = criticalTable.durationPerformance(i);
    cate{ctr} = criticalTable.groupName{i};
    cate{ctr + 1} = criticalTable.groupName{i};
    probe{ctr} = 'a-orientation';
    probe{ctr + 1} = 'b-duration';
    subject{ctr} = sprintf('sub-%d', i);
    subject{ctr + 1} = sprintf('sub-%d', i);
    ctr = ctr + 2;
end
log_reg_tbl = table(y, cate, probe, subject, 'VariableNames', {'y', 'cate', 'probe', 'subject'});
% Convert to categorical:
log_reg_tbl.cate = categorical(log_reg_tbl.cate);
log_reg_tbl.probe = categorical(log_reg_tbl.probe);
log_reg_tbl.subject = categorical(log_reg_tbl.subject);

%% Fit GLM:
glme = fitglme(log_reg_tbl,"y~cate * probe+(probe|subject)",Distribution="Binomial");
[~,~,statsFixed] = fixedEffects(glme)
anova(glme)
