


function[RTpreSurpriseTable]= behavioralPerformanceFunction(preSurpriseStruct,group)

% this function takes the struct files for face and object and calculates
% the behavioral performance for each subject (cell file in struct), add RT
% and returns a table that has all the information + it displays the
% subjects numbers who couldnt pass the exclusion criteria

    
numberTargets = 6;
numberNonTargets = 36;

numberHits = 0; % nr of times participants pressed space when it is target
numberFalseAlarms = 0; % nr of times participants pressed space when it is not target

rtHit = []; % rt hit
rtFalseAlarm = []; %rt false alarm
hitsTable = []; % everything about hits;
falseAlarmTable = []; %everything about false alarm 
hitIndex = 1;
falseAlarmIndex = 1;
ParticipantID = [];

%get the cell files from the struct based on the type 

if strcmp(group,'face') % face cells

% reach the struct data 

    faceCell = struct2cell(preSurpriseStruct);
    faceCells = faceCell{1};
    RTpreSurpriseTable = cell(numel(faceCells), 3);

    
    for i = 1:numel(faceCells)
       
        currentTable = faceCells{1,i}; % get the first cell
        ParticipantID = currentTable.ParticipantID(1);
        
         numberHits = 0;
         numberFalseAlarms = 0;
         hitsTable = [];
         falseAlarmTable = [];
        
    for j= 1:height(currentTable)     
     
          if ~isnan(currentTable.reactionTime(j)) % if there is space press, there is a number in RT
         
                if strcmp(currentTable.conditionFace{j},'target') %if participants presses space when it was target
              
                    numberHits = numberHits + 1; % if it is a target then it is a hit

                    % accurate RT calculations

                      if strcmp(currentTable.durationFace{j},'short') && currentTable.reactionTime(j) <= 500
              
                              rtHit(hitIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
           
                        elseif strcmp(currentTable.durationFace{j},'short') && currentTable.reactionTime(j) > 500

                              rtHit(hitIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
                        elseif strcmp(currentTable.durationFace{j},'long') && currentTable.reactionTime(j) <= 1500 %pressed in the stim frame

                              rtHit(hitIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
                        elseif strcmp(currentTable.durationFace{j},'long') && currentTable.reactionTime(j) > 1500 %pressed in the empty frame 
                              rtHit(hitIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
                      end

              hitsTable = [hitsTable;table(currentTable.Trial_Nr(j),{currentTable.durationFace(j)},{currentTable.orientationFaceTarget(j)},rtHit(hitIndex),...
                 'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
              hitIndex = hitIndex + 1;
             
                else
               numberFalseAlarms = numberFalseAlarms +1;
               
             
                    if strcmp(currentTable.durationFace{j},'short') && currentTable.reactionTime(j) <= 500
              
                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
           
                   elseif strcmp(currentTable.durationFace{j},'short') && currentTable.reactionTime(j) > 500

                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
                   elseif strcmp(currentTable.durationFace{j},'long') && currentTable.reactionTime(j) <= 1500

                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
                   elseif strcmp(currentTable.durationFace{j},'long') && currentTable.reactionTime(j) > 1500
                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
                    end

            falseAlarmTable = [falseAlarmTable;table(currentTable.Trial_Nr(j),{currentTable.durationFace(j)},{currentTable.orientationFace(j)},rtFalseAlarm(falseAlarmIndex),...
                 'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
            falseAlarmIndex = falseAlarmIndex + 1;
            
                end  

          end
    end
            RTpreSurpriseTable{i,1} = hitsTable;
            RTpreSurpriseTable{i,2} = falseAlarmTable;
            RTpreSurpriseTable{i,3} = ParticipantID;

        if numberHits/numberTargets >= 0.80 && numberFalseAlarms/numberNonTargets <= 0.20
         disp(['Participant ' ,num2str(ParticipantID), ' passed']);
        else
         disp(['Participant ' ,num2str(ParticipantID), ' failed']);
        end
    
    end   


elseif strcmp(group,'object') % object cells 


    objectCell = struct2cell(preSurpriseStruct);
    objectCells = objectCell{1};
    RTpreSurpriseTable = cell(numel(objectCells), 3);

  
    for i = 1:numel(objectCells)
     
     currentTable = objectCells{1,i}; % get the first cell
     ParticipantID = currentTable.ParticipantID(1);

         numberHits = 0;
         numberFalseAlarms = 0;
         hitsTable = [];
         falseAlarmTable = [];
        

        for j= 1: height(currentTable)
               
     
          if ~isnan(currentTable.reactionTime(j)) % if there is space press, there is a number in RT
         
                if strcmp(currentTable.conditionObject{j},'target') %if participants presses space when it was target
              
                    numberHits = numberHits + 1; % if it is a target then it is a hit

                    % accurate RT calculations

                      if strcmp(currentTable.durationObject{j},'short') && currentTable.reactionTime(j) <= 500
              
                              rtHit(hitIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
           
                        elseif strcmp(currentTable.durationObject{j},'short') && currentTable.reactionTime(j) > 500

                              rtHit(hitIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
                        elseif strcmp(currentTable.durationObject{j},'long') && currentTable.reactionTime(j) <= 1500 %pressed in the stim frame

                              rtHit(hitIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
                        elseif strcmp(currentTable.durationObject{j},'long') && currentTable.reactionTime(j) > 1500 %pressed in the empty frame 
                              rtHit(hitIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
                      end

              hitsTable = [hitsTable;table(currentTable.Trial_Nr(j),{currentTable.durationObject(j)},{currentTable.orientationObjectTarget(j)},rtHit(hitIndex),...
                  'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
         
              hitIndex = hitIndex + 1;
              
           else
               numberFalseAlarms = numberFalseAlarms +1;
               
             
                    if strcmp(currentTable.durationObject{j},'short') && currentTable.reactionTime(j) <= 500
              
                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
           
                   elseif strcmp(currentTable.durationObject{j},'short') && currentTable.reactionTime(j) > 500

                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
                   elseif strcmp(currentTable.durationObject{j},'long') && currentTable.reactionTime(j) <= 1500

                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j)- currentTable.stimulusOnset(j);
                   elseif strcmp(currentTable.durationObject{j},'long') && currentTable.reactionTime(j) > 1500
                            rtFalseAlarm(falseAlarmIndex) = currentTable.reactionTime(j) - currentTable.emptyFramefixationOnset(j);
           end

            falseAlarmTable = [falseAlarmTable;table(currentTable.Trial_Nr(j),{currentTable.durationObject(j)},{currentTable.orientationObject(j)},rtFalseAlarm(falseAlarmIndex),...
                 'VariableNames',{'TrialNr','stimulusDuration','stimulusOrientation','reactionTime'})];
            falseAlarmIndex = falseAlarmIndex + 1;
          
        
                end  
          end

        end

            RTpreSurpriseTable{i,1} = hitsTable;
            RTpreSurpriseTable{i,2} = falseAlarmTable;
            RTpreSurpriseTable{i,3} = ParticipantID;

        if numberHits/numberTargets >= 0.80 && numberFalseAlarms/numberNonTargets <= 0.20
            disp(['Participant ', num2str(ParticipantID), ' passed']);
        else
            disp(['Participant ', num2str(ParticipantID), ' failed']);
        end
    
    end

     

end

end

      