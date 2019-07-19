%% Baseline to save a new set for a protocol

% This script gives info on how to define the parameters for a new set. You
% can either set all the parameters here and run the script, or use this as
% a guideline and use the function saveNewSet instead.

% This will create the subfolder "nameProtocol" in the "protocol" folder and 
% save a new set file named "nameProtocol_set(numSet)"
% The parameters here are meant to be a guideline on the syntax. They can
% be changed with no trouble as long as the new ones also follow the correct
% syntax. Please don't delete everything so this can be a pratical example.

nameProtocol='mot_block2'; % Name of the folder relative to the protocol.
                        % It can be an already existing folder as well as a
                        % new one. [string/character]
                        
numSet=3;   % Name of new set. NB: if the set exists already, it will be 
            % overwrtitten. [single double]


numTargets = 16;     % # targets on the screen (i.d number of positions a 
                    % target could be activated in) [single double]

numMov= 2;   % # movements associated with each target (i.d # of times each 
             % target gets activated) [single double] 
                    % NB: the total movements in the set will be
                    % numTargets*numMov
                    
diamTargets = 50;     % diameters of the target in mm.  
                        % If this is a single number, the diameter will be
                        % the same for all the targets. If it's a vector,
                        % it must be of the same length of numTargets.
                        %  [single/vector double]

rTargets = [100 100 100 100 100 100 100 100 200 200 200 200 200 200 200 200] ;  % targets distance from the center of the screen in mm
                        % If this is a single number, the extention will be
                        % the same for all the targets. If it's a vector,
                        % it must be of the same length of numTargets.
                        % [single/vector double]
                        
dirTargets = [0 45 90 135 180 225 270 315 0 45 90 135 180 225 270 315]; % targets position in deg. Single double.
                        % If this is left empty, the targets will be
                        % equidistant. [vector double]

centerDim = 20;     % diameter in mm of the center point of focus. [single double]                        
                        
numSecs = 600;     % msecs a target appears for [single double]

interval= 1000;     % interval between sequences (sec) [single double]

rot = 0;     % angular rotation from the center applied to mouse trajectory (deg)[single double]

cursorVisible = true;       % visibility of cursor [true/false]

cursorVisibleWindow = true; % visibility of cursor only in temporal window 
                            % (before target activation) [true/false]
                            
cursorVisibleSpatial = true; % visibility of cursor only nearby the center (3cm) 
                            %  [true/false]                            

% NB: Target #n is identified by the set of
% parameters specified in the #n position.
% eg. Say we specify the parameters in the following way: 
% numTargets = 4;
% diamTargets = [40 50 60 70];
% rTargets = [50 100 150 200] ;
% dirTargets = [0 90 120 180];
% Then Target 1 will be identified as the target with diam=40, r=50, dir=0
% and so on.

seqTargets = [3 4 1 2 5 8 6 7; ...
            2 1 5 8 6 3 7 4]; % Order of appearance of the targets. If specified,
                  % it must be a matrix with (numMov x numTargets) elements, with        
                  % numbers from 1 to numTargets. If left empty, the
                  % order of appearance will be pseudorandom.
                  % [matrix double]
                  
showCross = false; % whether or not to show a cross on the center of the 
                   % targets when they activate [true/false]
                   
playSound = false; % whether or not to play a tone when the targets activate [true/false]

isTest=0; % weather it's a test or a task. in tasks, the configuration of the targets
            % is definite and their position is known to the subject

pauseAfter=false; % weather or not there's a pause immediately after the set, with
                    % a blank screen and the center cross visible

pauseAfterTime=0; % pause time in seconds


                 

% % --------------------  DO NOT EDIT BELOW THIS ----------------------------

saveMotSet(nameProtocol,numSet,numTargets,numMov,diamTargets,rTargets,centerDim,numSecs,...
    interval,rot,cursorVisible,cursorVisibleWindow,cursorVisibleSpatial,seqTargets,...
    dirTargets,showCross,playSound,isTest,pauseAfter,pauseAfterTime)

% mkdir('protocols',nameProtocol)
% protocolPath=fullfile('protocols',nameProtocol,[nameProtocol,'_set' num2str(numSet)]);
% 
% if exist([protocolPath,'.mat'], 'file') == 2
%     q='The set you are creating already exists. By proceeding, the set will be overwritten. Do you want to proceed?';
%     answer = questdlg(q,'WARNING: Set already exists', ...
%     'Proceed','Cancel','Cancel');
% else
%     answer='Proceed';
% end
% if strcmp(answer,'Proceed')
%         clear answer
%         save(protocolPath)  
%         disp('Set created')
% else
%     disp('Set NOT created')
% end





