% this function calculates the behavioral performance and decides which
% participant stays and which should be excluded 



numberHits = 0; % nr of times participants pressed space when it is target
numberFalseAlarms = 0; % nr of times participants pressed space when it is not target
rtHit = []; % rt hit
rtFalseAlarm = []; %rt false alarm
hitsTable = {}; % everything about hits
falseAlarmTable = {}; %everything about false alarm 
hitIndex = 1;
falseAlarmIndex = 1;


 numberTargets = sum(strcmp(preSurpriseTable.conditionFace,'target'));
         numberNonTargets = sum(~strcmp(preSurpriseTable.conditionFace,'target'));

        for k= 1: height(preSurpriseTable)
     
          if ~isnan(preSurpriseTable.reactionTime(k)) % if there is space press, there is a number in RT
         
                if strcmp(preSurpriseTable.conditionFace{k},'target') %if participants presses space when it was target
              
                    numberHits = numberHits + 1; % if it is a target then it is a hit

                    % accurate RT calculations

                      if strcmp(preSurpriseTable.durationFace{k},'short') && preSurpriseTable.reactionTime(k) <= 500
              
                              rtHit(hitIndex) = preSurpriseTable.reactionTime(k)- preSurpriseTable.stimulusOnset(k);
           
                        elseif strcmp(preSurpriseTable.durationFace{k},'short') && preSurpriseTable.reactionTime(k) > 500

                              rtHit(hitIndex) = preSurpriseTable.reactionTime(k) - preSurpriseTable.emptyFramefixationOnset(k);
                        elseif strcmp(preSurpriseTable.durationFace{k},'long') && preSurpriseTable.reactionTime(k) <= 1500 %pressed in the stim frame

                              rtHit(hitIndex) = preSurpriseTable.reactionTime(k)- preSurpriseTable.stimulusOnset(k);
                        elseif strcmp(preSurpriseTable.durationFace{k},'long') && preSurpriseTable.reactionTime(k) > 1500 %pressed in the empty frame 
                              rtHit(hitIndex) = preSurpriseTable.reactionTime(i) - preSurpriseTable.emptyFramefixationOnset(i);
                      end

              hitsTable = [hitsTable;table(preSurpriseTable.Trial_Nr(k),{preSurpriseTable.durationFace(k)},{preSurpriseTable.orientationFaceTarget(k)},rtHit(hitIndex),...
                  'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
              hitIndex = hitIndex + 1;
              
           else
               numberFalseAlarms = numberFalseAlarms +1;
               
             
                    if strcmp(preSurpriseTable.durationFace{k},'short') && preSurpriseTable.reactionTime(k) <= 500
              
                            rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(k)- preSurpriseTable.stimulusOnset(k);
           
                   elseif strcmp(preSurpriseTable.durationFace{k},'short') && preSurpriseTable.reactionTime(k) > 500

                            rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(k) - preSurpriseTable.emptyFramefixationOnset(k);
                   elseif strcmp(preSurpriseTable.durationFace{k},'long') && preSurpriseTable.reactionTime(k) <= 1500

                            rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(k)- preSurpriseTable.stimulusOnset(k);
                   elseif strcmp(preSurpriseTable.durationFace{k},'long') && preSurpriseTable.reactionTime(k) > 1500
                            rtFalseAlarm(falseAlarmIndex) = preSurpriseTable.reactionTime(k) - preSurpriseTable.emptyFramefixationOnset(k);
           end

            falseAlarmTable = [falseAlarmTable;table(preSurpriseTable.Trial_Nr(i),{preSurpriseTable.durationFace(i)},{preSurpriseTable.orientationFace(i)},rtFalseAlarm(falseAlarmIndex),...
                 'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
            falseAlarmIndex = falseAlarmIndex + 1;
           end  
          end

       end


        end



%behavioral performance check : min 80 percent hit rate & max 20 percent false alarm 

if numberHits/numberTargets >=.80 && numberFalseAlarms/numberNonTargets <=.20
    disp('participant passed');
else
    disp('participant failed');
end
