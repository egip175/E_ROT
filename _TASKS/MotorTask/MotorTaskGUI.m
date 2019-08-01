function varargout = MotorTaskGUI(varargin)
% MOTORTASKGUI MATLAB code for MotorTaskGUI.fig
%      MOTORTASKGUI, by itself, creates a new MOTORTASKGUI or raises the existing
%      singleton*.
%
%      H = MOTORTASKGUI returns the handle to a new MOTORTASKGUI or the handle to
%      the existing singleton*.
%
%      MOTORTASKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORTASKGUI.M with the given input arguments.
%
%      MOTORTASKGUI('Property','Value',...) creates a new MOTORTASKGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotorTaskGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotorTaskGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to start (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotorTaskGUI

% Last Modified by GUIDE v2.5 31-Jul-2019 17:16:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotorTaskGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MotorTaskGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MotorTaskGUI is made visible.
function MotorTaskGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotorTaskGUI (see VARARGIN)

% Choose default command line output for MotorTaskGUI
handles.output = hObject;

handles.netStation.UserData = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotorTaskGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MotorTaskGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% define the filepath
filePath_Callback(handles.filePath, eventdata,handles);

dataPath= get(handles.filePath, 'String');

    numSet= str2double(get(handles.currentSet, 'String')); 
%     numIt = str2double(get(handles.numIterations, 'string'));

if isempty(dataPath)==0

% get the settings 
dirTargets = str2num(get(handles.dirTargets, 'string'));
numTargets = str2num(get(handles.numTargets, 'string'));    
numMov = str2num(get(handles.numMov, 'string'));    
diamTargets = str2num(get(handles.diamTargets, 'string'));
rTargets = str2num(get(handles.rTargets, 'string'));
centerDim=str2num(get(handles.centerDim, 'string'));
numSecs = str2double(get(handles.numSecs, 'string'));
interval = str2double(get(handles.interval, 'string'));
rot = str2double(get(handles.rot, 'string'));
cursorVisible = ~(get(handles.cursorVisible, 'value'));
cursorVisibleWindow = get(handles.cursorVisibleWindow, 'value');
cursorVisibleSpatial = get(handles.cursorVisibleSpatial, 'value');
seqTargets = str2num(get(handles.seqTargets, 'string'));
showCross=get(handles.showCross, 'value');
playSound=get(handles.playSound, 'value');
pauseAfter=get(handles.pauseAfter, 'value');
pauseAfterTime=str2num(get(handles.pauseAfterTime, 'string'));
isTest=get(handles.isTest, 'value');

dataPath= get(handles.filePath, 'String');
% set(handles.data, 'value', true );
% data_Callback(handles.data, eventdata,handles);

if exist(dataPath, 'file') == 2
    q='The set you selected has been launched already for this subject. By proceeding, the data will be overwritten. Do you want to proceed?';
    answer = questdlg(q,'WARNING: Data already exists', ...
	'Proceed','Cancel','Cancel');
else
    answer='Proceed';
end

if strcmp(answer,'Proceed')
    
    % if it's the first set of the block, start the EEG acquisition
    if numSet==1
            set(handles.eegStatus,'value',1);
            eegStatus_Callback(handles.eegStatus, eventdata,handles);
    end
        
    
    if isempty(numTargets)==1
        
        isSetFinished=MotorTaskFUN;

    else         
        isSetFinished=MotorTaskFUN(numTargets,numMov,diamTargets,rTargets,...
            centerDim,numSecs,interval,rot,cursorVisible,cursorVisibleWindow,...
            cursorVisibleSpatial,seqTargets,dirTargets,showCross,playSound,...
            isTest,pauseAfter,pauseAfterTime,dataPath);
    end 
        
    if isSetFinished==1 && get(handles.training, 'value')==0
        currentSet_ButtonDownFcn(handles.currentSet, eventdata,handles);

    elseif get(handles.training, 'value')==0
        %rename the set
        oldPath=get(handles.filePath,'string');
        newPath=[oldPath(1:length(oldPath)-4),'_INTERRUPTED.mat'];

        movefile(oldPath,newPath);
    end
    
    % if it was the last set of the block, stop the EEG
    % MOVED TO STOP CALLBACK
%     if numSet == numIt
%         set(handles.eegStatus,'value',0);
%         eegStatus_Callback(handles.eegStatus, eventdata,handles);        
%     end
end

% pyschtoobox may give out an error if the space is not cleared
clear all
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.data, 'value', false);

% f = msgbox('Protocol completed');

q='Clear the settings or Stay on current protocol?';
    answer = questdlg(q,'PROTOCOL COMPLETED', ...
	'Clear','Stay','Clear');

if strcmp(answer,'Clear')
    
    % set to first fake protocol
    set(handles.protocols, 'value',1)
    protocols_Callback(handles.protocols, eventdata,handles);

end

% if it was acquiring, stop eeg
if (get(handles.eegStatus,'value'))
    set(handles.eegStatus,'value',0);
    eegStatus_Callback(handles.eegStatus, eventdata,handles);
end



% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopping
stopping = true;

% --- Executes on selection change in protocols.
function protocols_Callback(hObject, eventdata, handles)
% hObject    handle to protocols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns protocols contents as cell array
%        contents{get(hObject,'Value')} returns selected item from protocols

str = get(hObject, 'String');
val = get(hObject,'Value');

 numProtocol=str{val}; % gets protocol name
 
    if strcmp(str{val},'Select Protocol')==1
        
    set(handles.numTargets, 'string','');
    set(handles.numMov, 'string','');
    set(handles.diamTargets, 'string','');
    set(handles.rTargets, 'string','');
    set(handles.centerDim, 'string','');
    set(handles.numSecs, 'string','');
    set(handles.interval, 'string','');
    set(handles.rot, 'string','');
    set(handles.cursorVisible, 'value',false);
    set(handles.cursorVisibleWindow, 'value', false);
    set(handles.cursorVisibleSpatial, 'value', false);
    set(handles.showCross, 'value', false);
    set(handles.dirTargets, 'string','');
    set(handles.seqTargets, 'string','');
    set(handles.showCross, 'value',false);
    set(handles.playSound, 'value',false);
    set(handles.pauseAfter, 'value',false);
    set(handles.isTest, 'value',false);
    set(handles.pauseAfterTime, 'string','');
    
    
    set(handles.currentSet, 'string','');
    set(handles.filePath, 'string','');
    set(handles.numIterations, 'string','');
    
    
    else

        numSet = 1; % if you select protocol again, the set....resets :)

        % defining the strings so i can use fullfile in case it gets used in different OS
        theblock = numProtocol; % this should be called nameProtocol really
        
        nameSet_Callback(handles.nameSet, eventdata, handles)
        theset=get(handles.nameSet,'string');

        set(handles.currentSet, 'string', num2str(numSet)); 
        
        p = mfilename('fullpath');
        f=fileparts(p);

        protocolPath = fullfile(f,'protocols',theblock,theset);

        a=dir(fullfile(f,'protocols',theblock,'*.mat'));
        out=size(a,1);
        set(handles.numIterations, 'string', out); % set the # of iterations to the # of set files in the block

    % Set current data to the selected data set.
        load(protocolPath)

        set(handles.numTargets, 'string',numTargets);
        set(handles.numMov, 'string',numMov);
        set(handles.diamTargets, 'string',num2str(diamTargets));
        set(handles.rTargets, 'string',num2str(rTargets));
        set(handles.centerDim, 'string',num2str(centerDim));
        set(handles.numSecs, 'string',numSecs);
        set(handles.interval, 'string',interval);
        set(handles.rot, 'string',rot);
        set(handles.cursorVisible, 'value',~(cursorVisible));
        set(handles.cursorVisibleWindow, 'value', cursorVisibleWindow);
        set(handles.cursorVisibleSpatial, 'value', cursorVisibleSpatial);
        set(handles.showCross, 'value',showCross);
        set(handles.playSound, 'value',playSound);
        set(handles.dirTargets, 'string',num2str(dirTargets));
        set(handles.seqTargets, 'string',num2str(seqTargets));
        set(handles.pauseAfter, 'value',pauseAfter);
        set(handles.isTest, 'value',isTest);
        set(handles.pauseAfterTime, 'string',num2str(pauseAfterTime));


    end
% Save the handles structure.
guidata(hObject,handles)



function filePath_Callback(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filePath as text
%        str2double(get(hObject,'String')) returns contents of filePath as a double

    subjName= get(handles.subjName,'string');
    nameSet_Callback(handles.nameSet, eventdata, handles)
    theset=get(handles.nameSet,'string');

    if (get(handles.training, 'value'))==0
        str = get(handles.protocols, 'String');
        val = get(handles.protocols,'Value');
        %numProtocol = (str{val}(length(str{val})));
        numProtocol = str{val};
        
        % if it doesn't exist, create the directory for the block
        if ~exist(fullfile(subjName,[subjName,'_',numProtocol]),'dir' )
           mkdir(subjName,[subjName,'_',numProtocol])
        end

        path=fullfile(subjName,[subjName,'_',numProtocol],[subjName,'_',theset]);
    
    else %if it's training
        
%         % if it doesn't exist, create the directory for the block
%         if ~exist(fullfile(subjName,[subjName,'_','training']),'dir' )   
%             mkdir(subjName,[subjName,'_','training']);
%         end  
        
        % let the user choose the name        
        [file,savePath] = uiputfile(fullfile(subjName,[subjName,'_training'],[subjName,'_TrainingSet.mat']));
       
        if file == 0
            path ='';
        else
            path=strcat(savePath,file); 
        end
        
    end 
    
    set(hObject, 'string',path);



% --- Executes during object creation, after setting all properties.
function protocols_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% get contents of folder 'protocol'
p = mfilename('fullpath');
f=fileparts(p);
pathFolder = fullfile(f,'protocols');        
info = dir(pathFolder);
len=size(info);
protNames{1} = 'Select Protocol';
% for i=4:len
%     protNames{i-2}=info(i).name;
% end

ind=2;
for i=1:len
    if strcmp(info(i).name(1),'.')==0
        protNames{ind}=info(i).name;
        ind=ind+1;
    end
end
 % set values as the names of the folders
 set(hObject,'string',protNames);



function rTargets_Callback(hObject, eventdata, handles)
% hObject    handle to rTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rTargets as text
%        str2double(get(hObject,'String')) returns contents of rTargets as a double
set(handles.protocols,'Value',1);


% --- Executes during object creation, after setting all properties.
function rTargets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diamTargets_Callback(hObject, eventdata, handles)
% hObject    handle to diamTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diamTargets as text
%        str2double(get(hObject,'String')) returns contents of diamTargets as a double


% --- Executes during object creation, after setting all properties.
function diamTargets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diamTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cursorVisibleWindow.
function cursorVisibleWindow_Callback(hObject, eventdata, handles)
% hObject    handle to cursorVisibleWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cursorVisibleWindow


% --- Executes on button press in cursorVisible.
function cursorVisible_Callback(hObject, eventdata, handles)
% hObject    handle to cursorVisible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cursorVisible



function numSecs_Callback(hObject, eventdata, handles)
% hObject    handle to numSecs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numSecs as text
%        str2double(get(hObject,'String')) returns contents of numSecs as a double


% --- Executes during object creation, after setting all properties.
function numSecs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numSecs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rot_Callback(hObject, eventdata, handles)
% hObject    handle to rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot as text
%        str2double(get(hObject,'String')) returns contents of rot as a double


% --- Executes during object creation, after setting all properties.
function rot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subjName_Callback(hObject, eventdata, handles)
% hObject    handle to subjName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjName as text
%        str2double(get(hObject,'String')) returns contents of subjName as a double


% --- Executes during object creation, after setting all properties.
function subjName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subjAge_Callback(hObject, eventdata, handles)
% hObject    handle to subjAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjAge as text
%        str2double(get(hObject,'String')) returns contents of subjAge as a double


% --- Executes during object creation, after setting all properties.
function subjAge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subjSex_Callback(hObject, eventdata, handles)
% hObject    handle to subjSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjSex as text
%        str2double(get(hObject,'String')) returns contents of subjSex as a double


% --- Executes during object creation, after setting all properties.
function subjSex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjSex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function filePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numTargets_Callback(hObject, eventdata, handles)
% hObject    handle to numTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numTargets as text
%        str2double(get(hObject,'String')) returns contents of numTargets as a double



% --- Executes during object creation, after setting all properties.
function numTargets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interval_Callback(hObject, eventdata, handles)
% hObject    handle to interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interval as text
%        str2double(get(hObject,'String')) returns contents of interval as a double


% --- Executes during object creation, after setting all properties.
function interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numIterations_Callback(hObject, eventdata, handles)
% hObject    handle to numIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numIterations as text
%        str2double(get(hObject,'String')) returns contents of numIterations as a double


% --- Executes during object creation, after setting all properties.
function numIterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numIterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over currentSet.
function currentSet_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to currentSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 

 numSet = str2double(get(hObject, 'string'));
 numIt = str2double(get(handles.numIterations, 'string'));

 
if (numSet < numIt)

    str = get(handles.protocols, 'String');
    val = get(handles.protocols,'Value');

    numProtocol = str{val};

    set(hObject,'string', num2str(numSet+1)); % get the new set in the iteration
    numSet = get(hObject, 'string');

    theset=[numProtocol,'_set', num2str(numSet)];
    protocolPath = fullfile('protocols',numProtocol,[theset,'.mat']);


    load(protocolPath)
    
    
    set(handles.numTargets, 'string',num2str(numTargets));
    set(handles.numMov, 'string',num2str(numMov));
    set(handles.diamTargets, 'string',num2str(diamTargets));
    set(handles.rTargets, 'string',num2str(rTargets));
    set(handles.centerDim, 'string',num2str(centerDim));
    set(handles.numSecs, 'string',numSecs);
    set(handles.interval, 'string',interval);
    set(handles.rot, 'string',rot);
    set(handles.cursorVisible, 'value',~cursorVisible);
    set(handles.cursorVisibleWindow, 'value', cursorVisibleWindow);
    set(handles.cursorVisibleSpatial, 'value', cursorVisibleSpatial);
    set(handles.showCross, 'value',showCross);
    set(handles.playSound, 'value',playSound);
    set(handles.dirTargets, 'string',num2str(dirTargets));
    set(handles.seqTargets, 'string',num2str(seqTargets));
    set(handles.pauseAfter, 'value',pauseAfter);
    set(handles.isTest, 'value',isTest);
    set(handles.pauseAfterTime, 'string',num2str(pauseAfterTime));
    
    drawnow
else 
    stop_Callback(handles.stop, eventdata,handles);
end 



function numMov_Callback(hObject, eventdata, handles)
% hObject    handle to numMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numMov as text
%        str2double(get(hObject,'String')) returns contents of numMov as a double


% --- Executes during object creation, after setting all properties.
function numMov_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in isSetFinished.
function isSetFinished_Callback(hObject, eventdata, handles)
% hObject    handle to isSetFinished (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isSetFinished



% --- Executes during object creation, after setting all properties.
function currentSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in training.
function training_Callback(hObject, eventdata, handles)
% hObject    handle to training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of training

if get(hObject,'Value')== true
    
    set(handles.currentSet,'string','1')
    set(handles.numIterations,'string','1')
    
    set(handles.dirTargets,'Enable','on')
    set(handles.seqTargets,'Enable','on')
    set(handles.numTargets,'Enable','on')
    set(handles.diamTargets,'Enable','on')
    set(handles.numMov,'Enable','on')
    set(handles.rTargets,'Enable','on')
    set(handles.centerDim, 'Enable','on');
    set(handles.numSecs,'Enable','on')
    set(handles.interval, 'Enable','on');
    set(handles.rot, 'Enable','on');
    set(handles.cursorVisible, 'Enable','on');
    set(handles.cursorVisibleWindow, 'Enable','on');
    set(handles.cursorVisibleSpatial, 'Enable','on');
    set(handles.showCross, 'Enable','on');
    set(handles.playSound,'Enable','on');
	set(handles.pauseAfter, 'Enable','on');
    set(handles.isTest, 'Enable','on');
    set(handles.pauseAfterTime, 'Enable','on');
    
    set(handles.protocols, 'Enable','off');
    
    set(handles.saveSet, 'visible','on')
    set(handles.loadSet, 'visible','on')
    set(handles.setNum, 'visible','on')
    set(handles.protName, 'visible','on')

else 
    
    set(handles.currentSet,'string','')
    set(handles.numIterations,'string','')
    
    set(handles.dirTargets,'Enable','off')
    set(handles.seqTargets,'Enable','off')
    set(handles.numTargets,'Enable','off')
    set(handles.diamTargets,'Enable','off')
    set(handles.numMov,'Enable','off')
    set(handles.rTargets,'Enable','off')
    set(handles.centerDim, 'Enable','off');
    set(handles.numSecs,'Enable','off')
    set(handles.interval, 'Enable','off');
    set(handles.rot, 'Enable','off');
    set(handles.cursorVisible, 'Enable','off');
    set(handles.showCross, 'Enable', 'off');
    set(handles.playSound, 'Enable', 'off');    
    set(handles.cursorVisibleWindow, 'Enable','off');
    set(handles.cursorVisibleSpatial, 'Enable','off');
    set(handles.pauseAfter, 'Enable','off');
    set(handles.pauseAfterTime, 'Enable','off');
    set(handles.isTest, 'Enable','off');
    
    set(handles.protocols, 'Enable','on');
%    set(handles.protocols, 'value',1)
    
    set(handles.saveSet, 'visible','off')
    set(handles.loadSet, 'visible','off')
    set(handles.setNum, 'visible','off')
    set(handles.protName, 'visible','off')
    
    % set to first fake protocol
    set(handles.protocols, 'value',1)
    protocols_Callback(handles.protocols, eventdata,handles);
    
end 

% --- Executes on button press in data.
function data_Callback(hObject, eventdata, handles)
% hObject    handle to data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of data
 [filename, pathname]=uigetfile(('*.txt'),'Select File');


function dirTargets_Callback(hObject, eventdata, handles)
% hObject    handle to dirTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dirTargets as text
%        str2double(get(hObject,'String')) returns contents of dirTargets as a double


% --- Executes during object creation, after setting all properties.
function dirTargets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dirTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function seqTargets_Callback(hObject, eventdata, handles)
% hObject    handle to seqTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seqTargets as text
%        str2double(get(hObject,'String')) returns contents of seqTargets as a double


% --- Executes during object creation, after setting all properties.
function seqTargets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seqTargets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in saveSet.
function saveSet_Callback(hObject, eventdata, handles)
% hObject    handle to saveSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% prompt = {'Save as:'};
% dlgtitle = 'Save current settings';
% dims = [1 35];
% definput = {fullfile('protocols','training','TrainingSet')};
% a = inputdlg(prompt,dlgtitle,dims,definput);

    p = mfilename('fullpath');
    f=fileparts(p);
    
    numSet=get(handles.setNum,'string');
    nameProtocol=get(handles.protName,'string');

protPath=fullfile(f,'protocols',nameProtocol);
    if ~exist(protPath, 'dir')
       mkdir(protPath)
    end
       
[file,path] = uiputfile(fullfile(protPath,[nameProtocol,'_set',numSet,'.mat']));
if file ~=0
    
    % savePath=strcat(path,file(1:length(file)-4));
    savePath=strcat(path,file);

        dirTargets = str2num(get(handles.dirTargets, 'string'));
        numTargets = str2num(get(handles.numTargets, 'string'));    
        numMov = str2num(get(handles.numMov, 'string'));    
        diamTargets = str2num(get(handles.diamTargets, 'string'));
        rTargets = str2num(get(handles.rTargets, 'string'));
        centerDim = str2num(get(handles.centerDim, 'string'));
        numSecs = str2double(get(handles.numSecs, 'string'));
        interval = str2double(get(handles.interval, 'string'));
        rot = str2double(get(handles.rot, 'string'));
        cursorVisible = ~(get(handles.cursorVisible, 'value'));
        cursorVisibleWindow = get(handles.cursorVisibleWindow, 'value');
        cursorVisibleSpatial = get(handles.cursorVisibleSpatial, 'value');
        showCross=get(handles.showCross,'value');
        playSound=get(handles.playSound, 'value');
        pauseAfter=get(handles.pauseAfter, 'value');
        pauseAfterTime=str2num(get(handles.pauseAfterTime, 'string'));
        isTest=get(handles.isTest, 'value');

        seqTargets = str2num(get(handles.seqTargets, 'string'));

        save(savePath,'nameProtocol','numSet','numTargets','numMov','diamTargets','rTargets','centerDim',...
    'numSecs','interval','rot','cursorVisible','cursorVisibleWindow','cursorVisibleSpatial','seqTargets',...
    'dirTargets','showCross','playSound','isTest','pauseAfter','pauseAfterTime')  
        protocols_CreateFcn(handles.protocols, eventdata,handles);
        addpath(genpath('_TASKS'));
        drawnow

end


% --- Executes on button press in loadSet.
function loadSet_Callback(hObject, eventdata, handles)
% hObject    handle to loadSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    p = mfilename('fullpath');
    f=fileparts(p);
    
[filename, pathname]=uigetfile(fullfile(f,'protocols','*.mat'),'Select File');


if filename ~=0

    loadPath = strcat(pathname, filename);
    load(loadPath);

    set(handles.numTargets, 'string',numTargets);
    set(handles.numMov, 'string',numMov);
    set(handles.diamTargets, 'string',num2str(diamTargets));
    set(handles.rTargets, 'string',num2str(rTargets));
    set(handles.centerDim, 'string',num2str(centerDim));
    set(handles.numSecs, 'string',numSecs);
    set(handles.interval, 'string',interval);
    set(handles.rot, 'string',rot);
    set(handles.cursorVisible, 'value',(~cursorVisible));
    set(handles.cursorVisibleWindow, 'value', cursorVisibleWindow); 
    set(handles.cursorVisibleSpatial, 'value', cursorVisibleSpatial);
    set(handles.showCross, 'value',showCross);
    set(handles.playSound, 'value',playSound);
    set(handles.dirTargets, 'string',num2str(dirTargets));
    set(handles.seqTargets, 'string',num2str(seqTargets));
    set(handles.pauseAfter, 'value',pauseAfter);
    set(handles.isTest, 'value',isTest);
    set(handles.pauseAfterTime, 'string',num2str(pauseAfterTime));
    
    set(handles.numIterations, 'string', 1); 
    set(handles.currentSet, 'string', 1); 
end

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 numSet = str2double(get(handles.currentSet, 'string'));
 numIt = str2double(get(handles.numIterations, 'string'));

 
if (numSet < numIt)

    str = get(handles.protocols, 'String');
    val = get(handles.protocols,'Value');

    numProtocol = str{val};

    set(handles.currentSet,'string', num2str(numSet+1)); % get the new set in the iteration
    numSet = get(handles.currentSet, 'string');

%     theset=[numProtocol,'_set', num2str(numSet)];
    nameSet_Callback(handles.nameSet, eventdata, handles)
    theset=get(handles.nameSet,'string');
    
    protocolPath = fullfile('protocols',numProtocol,theset);


    load(protocolPath)
    
    
    set(handles.numTargets, 'string',num2str(numTargets));
    set(handles.numMov, 'string',num2str(numMov));
    set(handles.diamTargets, 'string',num2str(diamTargets));
    set(handles.rTargets, 'string',num2str(rTargets));
    set(handles.centerDim, 'string',num2str(centerDim));
    set(handles.numSecs, 'string',numSecs);
    set(handles.interval, 'string',interval);
    set(handles.rot, 'string',rot);
    set(handles.cursorVisible, 'value',(~cursorVisible));
    set(handles.cursorVisibleWindow, 'value', cursorVisibleWindow);
    set(handles.cursorVisibleSpatial, 'value', cursorVisibleSpatial);
    set(handles.showCross, 'value',showCross);
    set(handles.playSound, 'value',playSound);
    set(handles.dirTargets, 'string',num2str(dirTargets));
    set(handles.seqTargets, 'string',num2str(seqTargets));
    set(handles.pauseAfter, 'value',pauseAfter);
    set(handles.isTest, 'value',isTest);
    set(handles.pauseAfterTime, 'string',num2str(pauseAfterTime));
    
    drawnow
end


% --- Executes on button press in prev.
function prev_Callback(hObject, eventdata, handles)
% hObject    handle to prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 numSet = str2double(get(handles.currentSet, 'string'));
 numIt = str2double(get(handles.numIterations, 'string'));

 
if (numSet > 1)

    str = get(handles.protocols, 'String');
    val = get(handles.protocols,'Value');

    numProtocol = str{val};

    set(handles.currentSet,'string', num2str(numSet-1)); % get the new set in the iteration
    numSet = get(handles.currentSet, 'string');

    nameSet_Callback(handles.nameSet, eventdata, handles)
        theset=get(handles.nameSet,'string');
        
    protocolPath = fullfile('protocols',numProtocol,theset);


    load(protocolPath)
    
    
    set(handles.numTargets, 'string',num2str(numTargets));
    set(handles.numMov, 'string',num2str(numMov));
    set(handles.diamTargets, 'string',num2str(diamTargets));
    set(handles.rTargets, 'string',num2str(rTargets));
    set(handles.centerDim, 'string',num2str(centerDim));
    set(handles.centerDim, 'string',num2str(centerDim));
    set(handles.numSecs, 'string',numSecs);
    set(handles.interval, 'string',interval);
    set(handles.rot, 'string',rot);
    set(handles.cursorVisible, 'value',(~cursorVisible));
    set(handles.cursorVisibleWindow, 'value', cursorVisibleWindow);
    set(handles.cursorVisibleSpatial, 'value', cursorVisibleSpatial);
    set(handles.showCross, 'value',showCross);
    set(handles.playSound, 'value',playSound);
    set(handles.dirTargets, 'string',num2str(dirTargets));
    set(handles.seqTargets, 'string',num2str(seqTargets));
    set(handles.pauseAfter, 'value',pauseAfter);
    set(handles.isTest, 'value',isTest);
    set(handles.pauseAfterTime, 'string',num2str(pauseAfterTime));
    
    drawnow
end



function centerDim_Callback(hObject, eventdata, handles)
% hObject    handle to centerDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of centerDim as text
%        str2double(get(hObject,'String')) returns contents of centerDim as a double


% --- Executes during object creation, after setting all properties.
function centerDim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to centerDim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showCross.
function showCross_Callback(hObject, eventdata, handles)
% hObject    handle to showCross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showCross


% --- Executes on button press in playSound.
function playSound_Callback(hObject, eventdata, handles)
% hObject    handle to playSound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of playSound



function protName_Callback(hObject, eventdata, handles)
% hObject    handle to protName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of protName as text
%        str2double(get(hObject,'String')) returns contents of protName as a double


% --- Executes during object creation, after setting all properties.
function protName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function setNum_Callback(hObject, eventdata, handles)
% hObject    handle to setNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setNum as text
%        str2double(get(hObject,'String')) returns contents of setNum as a double


% --- Executes during object creation, after setting all properties.
function setNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cursorVisibleSpatial.
function cursorVisibleSpatial_Callback(hObject, eventdata, handles)
% hObject    handle to cursorVisibleSpatial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cursorVisibleSpatial


% --- Executes on button press in isTest.
function isTest_Callback(hObject, eventdata, handles)
% hObject    handle to isTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isTest


% --- Executes on button press in pauseAfter.
function pauseAfter_Callback(hObject, eventdata, handles)
% hObject    handle to pauseAfter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseAfter



function pauseAfterTime_Callback(hObject, eventdata, handles)
% hObject    handle to pauseAfterTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pauseAfterTime as text
%        str2double(get(hObject,'String')) returns contents of pauseAfterTime as a double


% --- Executes during object creation, after setting all properties.
function pauseAfterTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pauseAfterTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in eegStatus.
function eegStatus_Callback(hObject, eventdata, handles)
% hObject    handle to eegStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eegStatus

param = hObject.UserData;
isAquiring=handles.netStation.UserData;

if isempty(param) 
    nameIP='192.168.21.35'; 
    port='55513';
else 
    nameIP=(param{1});
    port=(param{2});
end


acquisition=get(hObject,'Value');

if acquisition

    q=['Press Ok to confirm starting the acquisition, Cancel not to start the acquisition,'...
            'Edit to change the IP and port parameters.'];
    answer = questdlg(q,'Starting EEG aquisition', ...
                            'Ok','Cancel','Edit','Cancel');
    if strcmp(answer,'Ok')
        set(hObject,'String','Aquiring EEG data');
        if isAquiring == 0 % if it's the first time it's connecting to NetStation
            handles.netStation.UserData = 1;
            [status,errormsg]=NetStation('Connect',nameIP,str2double(port));
            guidata(hObject, handles);

            disp('Connecting to NETStation...')
        end
        
    elseif strcmp(answer,'Edit')
        prompt = {'IP address:','Port name:'};
        dlgtitle = 'Input';
        dims = [1 35];
        definput = {nameIP,port};
        newParam = inputdlg(prompt,dlgtitle,dims,definput);
        hObject.UserData = newParam;
%         set(hObject,'Value',~acquisition);
        eegStatus_Callback(hObject, eventdata, handles)
    elseif strcmp(answer,'Cancel')
        set(hObject,'Value',~acquisition);
    end

else
    q=['Press Ok to confirm stopping the acquisition, Cancel to keep acquiring data.'];
    answer = questdlg(q,'Stopping EEG aquisition', ...
                            'Ok','Cancel','Cancel');
    if strcmp(answer,'Ok')
    set(hObject,'String','Not acquiring EEG');
    NetStation('StopRecording');
    %NetStation('Disconnect')
    disp('Stopping NETStation...')
    else
        set(hObject,'Value',~acquisition);
    end
end


% --- Executes on button press in nameSet.
function nameSet_Callback(hObject, eventdata, handles)
% hObject    handle to nameSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(handles.protocols, 'String');
val = get(handles.protocols,'Value');

numSet= get(handles.currentSet, 'String'); 
task='MotorTask';
block=str{val}; % gets protocol name

pathFolder=fullfile('_TASKS',task,'protocols',block);

    info = dir(pathFolder);
    
    if length(info)>0
    
    for i=1:length(info)
    k = strfind(info(i).name,['set',num2str(numSet)]);
        if ~isempty(k)
            setName=info(i).name;
            break
        end
    end
    else
        setName='.mat';
    end
   
set(hObject,'String',setName)
