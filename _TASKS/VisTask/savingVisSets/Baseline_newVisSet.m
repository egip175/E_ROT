%% Baseline to save a new set for a protocol

% This script gives info on how to define the parameters for a new set. You
% can either set all the parameters here and run the script, or use this as
% a guideline and use the function saveMemSet instead.

% This will create the subfolder "nameProtocol" in the "protocol" folder and 
% save a new set file named "nameProtocol_set(numSet)"
% The parameters here are meant to be a guideline on the syntax. They can
% be changed with no trouble as long as the new ones also follow the correct
% syntax. Please don't delete everything so this can be a pratical example.

nameProtocol='mem_block2'; % Name of the folder relative to the protocol.
                        % It can be an already existing folder as well as a
                        % new one. [string/character]
                        
numSet=2;   % Name of new set. NB: if the set exists already, it will be 
            % overwrtitten. [single double]

% % target position:

% %           3
% %       4      2
% %     5          1
% %    6            12
% %     7          11
% %       8     10
% %          9

seqTargets = [3 4 8 2 1 7 5 6; ...
              1 6 5 8 3 0 0 0]; 
                  % Order of appearance of the targets. 
                  % It must be a matrix of numSequences x 8 elements, with        
                  % numbers from 1 to 8. If a sequences has less than 8
                  % targets activating, fill the rest of the vector with
                  % 0s.

                    
diamTargets = 40;     % diameters of the target in mm.  
                        % If this is a single number, the diameter will be
                        % the same for all the targets. If it's a vector,
                        % it must be of the same length of numTargets.
                        %  [single/vector double]

rTargets = 100;  % targets distance from the center of the screen in mm
                        % [single double]
                        

centerDim = 20;     % diameter in mm of the center point of focus. [single double]                        
                        
numSecs = 600;     % msecs a target appears for [single double]

interval= 1000;     % interval between sequences (sec) [single double]

colorTime = 5;     % time the color wheel appears for (sec) [single double]

colorSeq = 4; % which color wheel will be displayed (see folder colorSequences)


% --------------------  DO NOT EDIT BELOW THIS ----------------------------


saveVisSet(nameProtocol,numSet,diamTargets,rTargets,centerDim,numSecs,...
    interval,colorTime,seqTargets)





