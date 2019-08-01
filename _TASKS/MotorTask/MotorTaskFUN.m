% MOTOR TASK

% sequences are matrixes
% multiple parameters, deploys standalone to get cursor data, data get
% saved as a .MAT file with variables data, targetxdistance/targetydistance

% function isSetFinished=MotorTask4(numTargets,numMov,diamTargets_mm,rTargets_mm,numSecs,interval_ms,rot,cursorVisible,cursorVisibleWindow,sequenceTargets,dirTargets,dataPath)
function [isSetFinished]=MotorTaskFUN(numTargets,numMov,diamTargets,rTargets,centerDim,...
    numSecs,interval,rot,cursorVisible,cursorVisibleWindow,cursorVisibleSpatial,...
    seqTargets,dirTargets,showCross,playSound,isTest,pauseAfter,pauseAfterTime,dataPath)
%-----
sca;
% clc;

% debug controls
small=0;    % if 1, small window
hide=1; % if 1, hides mouse

% To convert the parameters from cm to pixels, the measurments of the
% display are necessary. The
% program can detect them by itself, but depending on the display they may
% not be accurate. If you notice the targets being shaped as ovals, you may
% want to input manually the width and height paramenters as the correct
% measurment of the display. Otherwise, leave them as 0.

% width=630;
% height=385;

width=0;
height=0;
......................
     
nameIP='192.168.21.35'; 
port=55513;
event='MOT1'; % 4 letter char

%------------------------ SETTINGS PREDEFINITI  ------------------------

if nargin == 0
    
numTargets = 8; 
numMov= 1;
diamTargets = 20;
rTargets = 50 ; % targets extention - could be variable
centerDim = 10;
numSecs = 1000; % msecs a target appears for
interval = 2000; % interval between sequences in sec
rot = 20; % ang rotation applied to mouse trajectory
cursorVisible = true;   % visibility of cursor
cursorVisibleWindow = true; % visibility of cursor only in window
cursorVisibleSpatial = true;
seqTargets = [];%[1 2 3 4 5 6 7 8];
dirTargets = [];%[0 45 90 135 180 225 270 315];
dataPath=[];
playSound = false;
showCross=false;
isTest=0;
pauseAfter=false;
pauseAfterTime=0;

end
acquire=1;
if isnan(rot)
    rot=0;
end
%% Inizialization of mapped file

global window

% get current folder
p = mfilename('fullpath');
f=fileparts(p);

% for testing
%f='/Users/zingarella/Documents/MATLAB/MotTask_WIP'

% create the ref file
% I'm creating it in the /App folder cause it has the same path in every
% macOs. It's a .mat file long 200 characters, it'll be used to store info
% on the path and the target status
myData = uint8(1:200);
filename='/Applications/writingfile.mat';
filetmp = fopen(filename,'w');
fwrite(filetmp, myData,'uint8');
fclose(filetmp);
m = memmapfile(filename, 'Writable', true, 'Format', 'uint8');

% % alternative
% filename='/Applications/writingfile.mat';
% save(filename);
% m = memmapfile(filename, 'Writable', true, 'Format', 'uint8');

% save the path info to m
% this is where the standalone will save the zzz_data.mat
len = length(f);
m.Data(2)=len;
m.Data(3:len+2)=f;


%--------------------- definizione variabili ------------------------------

% m.Data(1) --> status (0: m ready / 1: break / 2: done-waiting)
% m.Data(2) --> path length (len)
% m.Data(3:len+2) --> path string
% m.Data(len+3) --> target status


% index target status to write on the m
t=double(m.Data(2))+3;

% resets status just in case
m.Data(1)=2;
status = m.Data(1);

%  target=0;
m.Data(t)=0;


rCursorWindow = 40; % cm
interval =((interval-numSecs)/1000);
pauseSecs=1; % pause before start 

% the default angles aren't the same of the usual goniometric reference,
% here I'm setting them to be
dirTargets = dirTargets + 90;

% the pause bottom in GUI controls stopping
global stopping;
stopping = false;
isSetFinished=1;


% if isempty(seqTargets)
%     seqTargets=(randperm(numTargets));
%      if numMov >1 
%          seqTargets=repmat(seqTargets,1,numMov);
%      end
% end 
%
% numTargets=4;
% numMov=4;
% seqTargets=[];

% randomize appeareance sequence if not specified
if isempty(seqTargets)
    seqTargets=nan(numMov,numTargets);
    seqTargets(1,1:numTargets)=(randperm(numTargets));
    for i=2:numMov
        seqTargets(i,:)=(randperm(numTargets));
        if seqTargets(i-1,numTargets)==seqTargets(i,1)
            disp('here');
            tmp=seqTargets(i,1);
            seqTargets(i,1)=seqTargets(i,numTargets);
            seqTargets(i,numTargets)=tmp;
        end
            
    end
        disp('Pseudorandom sequence generated');   
end 


if isempty(dataPath)
    dataPath='z_behavioralData.mat';
end 


%%%%%%%%%%%%%%%%%%%%%%
% -------- START GETDATA --------- 
preStart=GetSecs;
system('open -a GetCursorData');
% GetCursorData;
% %%%%%%%%%%%%%%%%%%%%%%

%---------------
% Sound Setup
%---------------
if playSound
    
    InitializePsychSound(1);
    nrchannels = 2;
    freq = 48000;
    repetitions = 1;
    beepLengthSecs = 0.2;
    startCue = 0;
    waitForDeviceStart = 1;

    pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);

    PsychPortAudio('Volume', pahandle, 0.5);

    myBeep = MakeBeep(500, beepLengthSecs, freq);

    PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);

end

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
grey = white/2;
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
ifi = Screen('GetFlipInterval', window);
% Set up alpha-blending for smooth (anti-aliased) lines
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

if width == 0
[width,height]= Screen('DisplaySize', screenNumber);  
end

waitframes = 1;

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(window);

%%%%%%%%%%%%%%%%%%%%%
textString='The task is about to start';
%tstring='\nPlace the cursor in the center of the screen';
Screen('TextSize', window, 60);
DrawFormattedText(window, [textString],...
    'center', 'center', black);

Screen('Flip', window);

SetMouse(xCenter, yCenter+100, window);



% % wait for GetCursorData to singal starting
while status ~= 0
    status = m.Data(1);
end 
tic
startTime=GetSecs;
info=['Starting after ',num2str(startTime-preStart),'s'];
disp(info)

% % Start EEG acquisition

if acquire == 1
    
    NetStation('StartRecording');
    NetStation('Synchronize');
    disp('Starting NETStation...')
    pause(1)
end


% % --- CALCOLI E DEFINIZIONE VARIABILI --------------

if isTest == 1 
    colorTargets = white;
else
    colorTargets = black;
end
colorTargetActivated = black;
colorTargetReached = grey;

% conversion in pixel

scaleFactorX= screenXpixels/width;
scaleFactorY=screenYpixels/height;

    diamTargetsX = scaleFactorX*diamTargets;
    diamTargetsY = scaleFactorY*diamTargets;

rCursorWindow = rCursorWindow*scaleFactorX; %pixel

if length(diamTargetsX)==1
    for i = 1:numTargets
        diamTargetsX(i) = diamTargetsX(1);
        diamTargetsY(i) = diamTargetsY(1);
    end
end

    baseRectTargets=ones(length(diamTargetsX),4);
    
for i = 1:length(diamTargetsX)
    baseRectTargets(i,:) = [0 0 diamTargetsX(i) diamTargetsY(i)];
end


allTargets = nan(4, numTargets); % matrice per le coordinate targets
c_x= nan(1, numTargets);
c_y= nan(1, numTargets);

% coordinate centri target
if length(rTargets)==1
    for i=1:numTargets
        rTargets(i)=rTargets(1);
    end
end 

if isempty(dirTargets) % unspecified direction -> space them evenly
        alfa = 360 / numTargets; % angolo distrubuzione targets
        % coordinate centri target
    for i = 1:numTargets
        c_x(i)= rTargets(i) * sind((i-1)*alfa);
        c_y(i)= rTargets(i) * cosd((i-1)*alfa);
        
        c_x(i)=scaleFactorX*c_x(i);
        c_y(i)=scaleFactorY*c_y(i);

        allTargets(:,i) = CenterRectOnPointd(baseRectTargets(i,:), xCenter+c_x(i), yCenter+c_y(i));
    end

else % if the user specified the directions
   
    for i = 1:numTargets

        c_x(i)= rTargets(i) * sind(dirTargets(i));
        c_y(i)= rTargets(i) * cosd(dirTargets(i));  
        
        c_x(i)=scaleFactorX*c_x(i);
        c_y(i)=scaleFactorY*c_y(i);

        allTargets(:,i) = CenterRectOnPointd(baseRectTargets(i,:), xCenter+c_x(i), yCenter+c_y(i));

    end
end 


dimPix = 10;
lineWidthPix = 4;
centerCross=[-dimPix,dimPix,0,0;0,0,-dimPix,dimPix];

centerRect = [0 0 scaleFactorX*centerDim scaleFactorY*centerDim];
% rect of central point
centerPoint = CenterRectOnPointd(centerRect, xCenter, yCenter); 

if showCross 
    % target cross
    ind=1;
    for i=1:4:numTargets*4
    targetCross(1,i) = c_x(ind)+dimPix;
    targetCross(1,i+1) =c_x(ind)-dimPix;
    targetCross(2,i) = c_y(ind);
    targetCross(2,i+1) = c_y(ind);

    targetCross(1,i+2) = c_x(ind);
    targetCross(1,i+3) =c_x(ind);
    targetCross(2,i+2) = c_y(ind)+dimPix;
    targetCross(2,i+3) = c_y(ind)-dimPix;

    ind=ind+1;
    end
end

rot=-rot; % angles go in the opposite direction, not sure why


%----------------------------- FIRST FLIP --------------------------------

% draw starting point in the center of the screen
Screen('FrameOval', window, black, centerPoint,4);

Screen('FrameOval', window, colorTargets,allTargets, 4);
% SetMouse(xCenter, yCenter, window);
% mouse
[x, y, buttons] = GetMouse(window);
Screen('DrawDots', window, [x y], 10, [1 0 0], [], 2);

% Flip to the screen
vbl  = Screen('Flip', window);


% ----------- Wait for user to position cursor in the center---------------
[x, y, buttons] = GetMouse(window);
inside = IsInRect(x, y, centerPoint);

 while inside == 0
     
    if stopping == true 
        inside = 1;
        isSetFinished=0;
        % break 
    else 
    
        [x, y] = GetMouse(window);
        inside = IsInRect(x, y, centerPoint);
        Screen('FrameOval', window, black, centerPoint,4);
        Screen('FrameOval', window, colorTargets,allTargets, 4);
        Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
        Screen('DrawDots', window, [x y], 10, [1 0 0], [], 2);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    
    end
    
 end
 
 
% pause for tot seconds
numFramesPause = round(pauseSecs/ifi); %number of frames to use for pause before start

for frame = 1:numFramesPause
    if stopping == true % KbCheck
        break
    end
    [x, y] = GetMouse(window);
    Screen('FrameOval', window, black, centerPoint,4);
    Screen('FrameOval', window, colorTargets,allTargets, 4);
    Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
    Screen('DrawDots', window, [x y], 10, [1 0 0], [], 2);
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

% flash 3 times to indicate start 

numFramesTask = round(numSecs/1000/ifi);
numFramesInt = round(interval/ifi);

    for i=1:3
        
        if KbCheck
            break
        end
    
        for frame = 1:numFramesTask
            [x, y] = GetMouse(window);
            Screen('FillOval', window, colorTargetActivated, centerPoint);
            Screen('FrameOval', window, colorTargets,allTargets, 4);
            Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
            Screen('DrawDots', window, [x y], 10, [1 0 0], [], 2);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end


        for frame = 1:numFramesInt
            [x, y] = GetMouse(window);
            Screen('FrameOval', window, black, centerPoint,4);
            Screen('FrameOval', window, colorTargets,allTargets, 4);
            Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
            Screen('DrawDots', window, [x y], 10, [1 0 0], [], 2);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        end

    end 


% =============================== TASK ====================================

% vars 
count = 0; % num targets reached
% [x1, y1] = GetMouse;
 
for z=1:numMov
 for index =1:numTargets
     
    drawnow
    [keyIsDown, secs, keyCode] = KbCheck;
    if stopping == true 
        isSetFinished=0;
        break       
    end 
     
    col=colorTargetActivated;
    % target = orderTargets(index);
    m.Data(t)=seqTargets(z,index);

    info=['Movement ',num2str(index+((z-1)*numTargets)),'(target ',num2str(seqTargets(z,index)),')'];
    disp(info)
    
     % Activate target
     
     if playSound
         PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
     end
     for i=1:numFramesTask

        [x, y] = GetMouse(window);

            x1 = (x-xCenter)*cosd(rot) - (y-yCenter)*sind(rot);
            y1 = (x-xCenter)*sind(rot) + (y-yCenter)*cosd(rot);

            % inside = IsInRect(x, y, allTargets(:,orderTargets(index)));
            inside = IsInRect(x1+xCenter, y1+yCenter, allTargets(:,seqTargets(z,index)));


            if inside == 1 && isequal(col,colorTargetActivated)==1
                col = colorTargetReached;
                count=count+1;
            end

        Screen('FrameOval', window, black, centerPoint,4);
        Screen('FrameOval', window, colorTargets,allTargets, 4);
        Screen('FillOval', window, col, allTargets(:,seqTargets(z,index)));
        Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
        if showCross
            Screen('DrawLines', window, targetCross,lineWidthPix, white, [xCenter yCenter], 2);
        end
        if cursorVisible==true || (cursorVisibleWindow == false && cursorVisibleSpatial==true && ...
                abs(x-xCenter) < rCursorWindow && abs(y-yCenter) < rCursorWindow)
            Screen('DrawDots', window, [x1+xCenter y1+yCenter], 10, [1 0 0], [], 2);
        end
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        
        if (i==1 && acquire == 1)   %if firstFlip send event
            NetStation('Event', event);
        end

     end


     % Deactivate target
     %   target=0;
      m.Data(t)=0;

     for i=1:numFramesInt

        [x, y] = GetMouse(window);

        x1 = (x-xCenter)*cosd(rot) - (y-yCenter)*sind(rot);
        y1 = (x-xCenter)*sind(rot) + (y-yCenter)*cosd(rot);

        Screen('FrameOval', window, black, centerPoint,4);
        Screen('FrameOval', window, colorTargets,allTargets, 4);
        Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
        if cursorVisible==true ||  (cursorVisibleSpatial==true && ...
                abs(x-xCenter) < rCursorWindow && abs(y-yCenter) < rCursorWindow)
            
            Screen('DrawDots', window, [x1+xCenter y1+yCenter], 10, [1 0 0], [], 2);
            
        elseif cursorVisibleWindow==true && cursorVisibleSpatial==false
            Screen('DrawDots', window, [x1+xCenter y1+yCenter], 10, [1 0 0], [], 2);
        end
  
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
     end 

 end 
end
 
% brief pause 
numFramesEnd = round(interval/ifi); 
for frame = 1:numFramesEnd
    [x, y] = GetMouse(window);
        x1 = (x-xCenter)*cosd(rot) - (y-yCenter)*sind(rot);
        y1 = (x-xCenter)*sind(rot) + (y-yCenter)*cosd(rot);
    Screen('FrameOval', window, black, centerPoint,4);
    Screen('FrameOval', window, colorTargets,allTargets, 4);
    Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
    if cursorVisible==true 
        Screen('DrawDots', window, [x1+xCenter y1+yCenter], 10, [1 0 0], [], 2);
    end
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
end

% % --------------------------- END TASK ---------------------------------


% stop acquiring data
m.Data(1)=1;

% % stop EEG
% if (acquire == 1) % && isSetFinished == 1    
%     NetStation('StopRecording');
%     NetStation('Disconnect')
% end

% Get targets appearance order --------------------------------------------

% coordinates center targets in cm
centerTargets_x = c_x*(width/screenXpixels)/10;  
centerTargets_y = (c_y*(height/screenYpixels)/10)*(-1); % y coordinates would be positive in wrong quarters

seqTargets=reshape(seqTargets',[1,numTargets*numMov]);

% targets center in order of appearance
for i=1:length(seqTargets)
    targetxdistance(i)=centerTargets_x(seqTargets(i));
    targetydistance(i)=centerTargets_y(seqTargets(i));
end

% ----------------------- Save the cursor data ----------------------------

% wait for GetCursorData to stop
while status ~= 2
    status = m.Data(1);
end 

% %
endTime=GetSecs;
timing=['Task lasted for ',num2str(endTime-startTime),'s'];
disp(timing)
%%

load(fullfile(f,'zzz_GetCursorData.mat'));
dataMat=data;

% construct the data matrix
data=(dataMat(~isnan(dataMat)));
data=reshape(data,[(length(data)/4),4])';   

% time in ms
data(1,:)=(data(1,:)-data(1,1))*1000;

% if there's more display connected, the two are considered as one big screen
if length(screens)>1 
    data(2,:)=(data(2,:)+screenXpixels);
end

% convert data to rotated cursor
if rot ~= 0   
    % rotation is applied on first target instance
    xc= find(data(4,:) ~=0);
    xc=xc(1);
    dataSize=size(data);

    for i=xc:dataSize(2)
        data(2,i)= ((data(2,i)-xCenter)*cosd(rot) - (data(3,i)-yCenter)*sind(rot))+xCenter;
        data(3,i)= ((data(2,i)-xCenter)*sind(rot) + (data(3,i)-yCenter)*cosd(rot))+yCenter;       
    end
end

% conversion to mm (marky seem to want mm)

data(2,:)=(data(2,:)-xCenter)*(width/screenXpixels);
data(3,:)=(data(3,:)-yCenter)*(height/screenYpixels)*(-1);   
 
save(dataPath,'data','targetxdistance','targetydistance');
delete(fullfile(f,'zzz_GetCursorData.mat'));
delete(filename);

% % print to file
% formatSpec = '%.f %.3f %.3f %.f\n';
% fileID = fopen(dataPath,'wt');
% fprintf(fileID,formatSpec,data);
% % fprintf(fileID,'done');
% fclose(fileID);

% delete('zzz_data.mat');


%--------------------------------------------------------------------------
% Construct final text string
textString = ['You correctly reached ' num2str(count)...
        ' out of ' num2str(length(seqTargets)) ' targets.'];
    if count > length(seqTargets)*(2/3)
        tstring = '\n\n Great job! Keep it up!';
    elseif count > length(seqTargets)*(2/5)
        tstring = '\n\n Good job! I am sure you can do even better!';
    else 
        tstring = '\n\n I am sure you will do better next time!';
    end
    disp(textString)
% Text output 
Screen('TextSize', window, 60);
DrawFormattedText(window, [textString tstring],...
    'center', 'center', black);

Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

% Wait for key stroke and clear the screen or pause.
    KbStrokeWait;

if ~pauseAfter

    sca;
    
else    % pause after the set
    
    Screen('DrawLines', window, centerCross,lineWidthPix, black, [xCenter yCenter], 2);
    Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    pause(pauseAfterTime)    
    sca
    
end


end







