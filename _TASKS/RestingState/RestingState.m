% MOTOR TASK

% sequences are matrixes
% multiple parameters, deploys standalone to get cursor data, data get
% saved as a .MAT file with variables data, targetxdistance/targetydistance

% function isSetFinished=MotorTask4(numTargets,numMov,diamTargets_mm,rTargets_mm,numSecs,interval_ms,rot,cursorVisible,cursorVisibleWindow,sequenceTargets,dirTargets,dataPath)
function RestingState(restTime)
%-----
sca;
clc;

if nargin == 0
    restTime = 30;
end


%--------------------  debug controls
small=0;    % if 1, small window
hide=0; % if 1, hides mouse

% To convert the parameters from cm to pixels, the measurments of the
% display are necessary. The
% program can detect them by itself, but depending on the display they may
% not be accurate. If you notice the targets being shaped as ovals, you may
% want to input manually the width and height paramenters as the correct
% measurment of the display. Otherwise, leave them as 0.

% width=640;
% height=395;

width=0;
height=0;


% % Start EEG acquisition
    
    NetStation('StartRecording');
    NetStation('Synchronize');
    disp('Starting NETStation...')
    pause(1)
%------------------------- 

% parameters
dimPix = 10;
lineWidthPix = 4;
centerCross=[-dimPix,dimPix,0,0;0,0,-dimPix,dimPix];

% % ------- SETUP PSYCH ------

PsychDefaultSetup(2);
%skip sincronization tests
Screen('Preference','SkipSyncTests', 1);
rc = PsychGPUControl('FullScreenWindowDisablesCompositor',1);

% General Settings
screens = Screen('Screens');
screenNumber = max(screens);  % second screen if there's one
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
if hide==1
HideCursor(screenNumber)
end

if small==1
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 500 375]);
else
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
end

% m.Data(len+4)=window;

[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

if width == 0
[width,height]= Screen('DisplaySize', screenNumber);  
end

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(window);

Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
Screen('Flip', window);
pause(restTime)


sca;



end







