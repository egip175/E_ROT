

function isSetFinished=MemTaskFUN(seqTargets,diamTargets,rTargets,centerDim,numSecs,...
    interval,colorTime,colors,dataPath)
%-----
sca;
clc;

small=0;    % if 1, small window
hide=0; % if 1, hides mouse
acquire=1;  % if 1, it acquires

% To convert the parameters from cm to pixels, the measurments of the
% display are necessary. The
% program can detect them by itself, but depending on the display they may
% not be accurate. If you notice the targets being shaped as ovals, you may
% want to input manually the width and height paramenters as the correct
% measurment of the display. Otherwise, leave them as 0.
width=630;
height=385;

name='192.168.21.35'; 
port=55513;
event='MEM1'; % 4 letter char

%------------------------ SETTINGS PREDEFINITI  ------------------------


if nargin == 0
    
diamTargets = 50;
rTargets = 100 ; % targets extention - could be variable
centerDim = 20;
numSecs = 300; % msecs a target appears for
interval = 500; % interval between sequences in sec
colorTime = 2;
seqTargets = [1 2 3 4 5 6 7 8; 1 2 3 4 0 0 0 0];
colors=[1 0 0;0 1 0;0 0 1;1 1 0;1 0 1;0 1 1;1 0.5 0;0.5 0.5 0.5]'; 
dataPath='zzz_mem.mat';

end


%--------------------- definizione variabili ------------------------------

isSetFinished=1;
% this is the # of targets positions (same as the color wheel)
n=8;

interval =((interval-numSecs)/1000);
pauseSecs=1; % pause before start 

% the pause bottom in GUI controls stopping
global stopping;
stopping = false;


% if isempty(seqTargets)
%     seqTargets=(randperm(numTargets));
%      if numMov >1 
%          seqTargets=repmat(seqTargets,1,numMov);
%      end
% end 
%

[row,colum]=size(seqTargets);



% % ------- SETUP PSYCH ------

PsychDefaultSetup(2);
%skip sincronization tests
Screen('Preference','SkipSyncTests', 1);
rc = PsychGPUControl('FullScreenWindowDisablesCompositor',1);

% General Settings
screens = Screen('Screens');
screenNumber = max(screens);  % second screen if there's one
white = WhiteIndex(screenNumber);

% Setup the text type for the window
% Screen('TextFont', window, 'Ariel');
% Screen('TextSize', window, 20);

black = BlackIndex(screenNumber);
grey = white/2;
if hide==1
HideCursor(screenNumber)
end

if small==1
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white, [0 0 500 375]);
else
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);
end
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
ifi = Screen('GetFlipInterval', window);
% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
if width == 0
[width,height]= Screen('DisplaySize', screenNumber);  
end 
waitframes = 1;

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(window);


% % Start EEG acquisition

if acquire == 1
%     [status,errormsg]=NetStation('Connect',name,port);
    NetStation('Synchronize');
    NetStation('StartRecording');
    
end


% % --- CALCOLI E DEFINIZIONE VARIABILI --------------


colorTargets = black;
colorTargetActivated = black;
colorTargetReached = grey;

% conversion in pixel

scaleFactorX= screenXpixels/width;
scaleFactorY=screenYpixels/height;

    diamTargetsX = scaleFactorX*diamTargets;
    diamTargetsY = scaleFactorY*diamTargets;


if length(diamTargetsX)==1
    for i = 1:n
        diamTargetsX(i) = diamTargetsX(1);
        diamTargetsY(i) = diamTargetsY(1);
    end
end

    baseRectTargets=ones(length(diamTargetsX),4);
    
for i = 1:length(diamTargetsX)
    baseRectTargets(i,:) = [0 0 diamTargetsX(i) diamTargetsY(i)];
end


allTargets = nan(4, n); % matrice per le coordinate targets
c_x= nan(1, n);
c_y= nan(1, n);

% coordinate centri target
if length(rTargets)==1
    for i=1:n
        rTargets(i)=rTargets(1);
    end
end 

        alfa = 360 / n; % angolo distrubuzione targets
        % coordinate centri target
    for i = 1:n
        c_x(i)= rTargets(i) * sind((i-1)*alfa+135);
        c_y(i)= rTargets(i) * cosd((i-1)*alfa+135);
        
        c_x(i)=scaleFactorX*c_x(i);
        c_y(i)=scaleFactorX*c_y(i);

        allTargets(:,i) = CenterRectOnPointd(baseRectTargets(i,:), xCenter+c_x(i), yCenter+c_y(i));
    end



dimPix = 10;
lineWidthPix = 4;
centerCross=[-dimPix,dimPix,0,0;0,0,-dimPix,dimPix];

centerRect = [0 0 scaleFactorX*centerDim scaleFactorY*centerDim];
% rect of central point
centerPoint = CenterRectOnPointd(centerRect, xCenter, yCenter); 

numFramesTask = round(numSecs/1000/ifi);
numFramesInt = round(interval/ifi);


%----------------------------- FIRST FLIP --------------------------------


% Flip to the screen
vbl  = Screen('Flip', window);


% =============================== TASK ====================================

% vars 

for y=1:row
    
    drawnow
    a=find(seqTargets(y,:)==0);
    if isempty(a)
        seq=seqTargets(y,:);
    else
    seq=seqTargets(y,1:a(1)-1);
    end
    
    if stopping == true
        isSetFinished=0;
        break
    end 
    
    s=3;
    for i=1:3       
        textString = ' Try to focus.';
        tstring = ['\n\nThe new set begins in ',num2str(s)];
        % Text output 
        Screen('TextSize', window, 60);
        DrawFormattedText(window, [textString tstring],...
        'center', 'center', black);
         Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
         s=s-1;
         pause(1)
    end   
     
    % pause for tot seconds

    Screen('FrameOval', window, black, centerPoint,4);
    Screen('FrameOval', window, colorTargets,allTargets, 4);
    Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);

    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    pause(pauseSecs)

    l=length(seq);
    for index =1:l
        
        if stopping == true
        isSetFinished=0;
        break
        end 
     
        col=colorTargetActivated;

        info=['Movement ',num2str(index),'(target ',num2str(seq(index)),')'];
        disp(info)

         % Activate target
         for i=1:numFramesTask

            % Screen('FrameOval', window, black, centerPoint,4);
            % Screen('FrameOval', window, colorTargets,allTargets, 4);
            Screen('FillOval', window, col, allTargets(:,seq(index)));
            Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);

            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

            if (i==1 && acquire == 1)   %if firstFlip send event
                NetStation('Event', event);
            end

         end


         % Deactivate target

         for i=1:numFramesInt        

%             Screen('FrameOval', window, black, centerPoint,4);
%             Screen('FrameOval', window, colorTargets,allTargets, 4);
             Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);

            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
         end 

        drawnow
        [keyIsDown, secs, keyCode] = KbCheck;
        if stopping == true
            isSetFinished=0;
            break
        end 
    end 
     
    % Holding

    Screen('FrameOval', window, black, centerPoint,4);
    Screen('FrameOval', window, colorTargets,allTargets, 4);
    Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);

    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    pause(colorTime)
    
    
    % COLORS   

    numFramesColors = round(colorTime/ifi);

    for frame = 1:numFramesColors
    drawnow
    if stopping == true 
        isSetFinished=0;
        break
    end 

%         col=colors(:,(y-1)*numTargets+1:(y-1)*numTargets+numTargets);
        Screen('FillOval', window, colors,allTargets, max(diamTargets));
        Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
        Screen('FrameOval', window, colorTargets,allTargets, 2);

        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    end
        
 
end 

% % --------------------------- END TASK ---------------------------------

 
% % stop EEG
% if (acquire == 1)   
%     NetStation('StopRecording');
%     NetStation('Disconnect')
% end

% save something (tbd)
a=1;
save(dataPath,'a');

%--------------------------------------------------------------------------
% Construct final text string
textString = ['Well Done!'];

% Text output 
Screen('TextSize', window, 60);
DrawFormattedText(window, [textString],...
    'center', 'center', black);

Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);


% Clear the screen.
KbStrokeWait;
sca;
%%

end







