function varargout = expGUI(varargin)
%EXPGUI MATLAB code file for expGUI.fig
%      EXPGUI, by itself, creates a new EXPGUI or raises the existing
%      singleton*.
%
%      H = EXPGUI returns the handle to a new EXPGUI or the handle to
%      the existing singleton*.
%
%      EXPGUI('Property','Value',...) creates a new EXPGUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to expGUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      EXPGUI('CALLBACK') and EXPGUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in EXPGUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help expGUI

% Last Modified by GUIDE v2.5 24-Jul-2019 09:56:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @expGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @expGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before expGUI is made visible.
function expGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for expGUI
handles.output = hObject;

handles.netStation.UserData = 0;

% Update handles structure
guidata(hObject, handles);

addpath(genpath('_TASKS'));

% UIWAIT makes expGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = expGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in timeline.
function timeline_Callback(hObject, eventdata, handles)
% hObject    handle to timeline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns timeline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timeline

% define the filepath
numIt_Callback(handles.numIt, eventdata,handles);
drawnow


% --- Executes during object creation, after setting all properties.
function timeline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'[add blocks]'});



% --- Executes on button press in addBlock.
function addBlock_Callback(hObject, eventdata, handles)
% hObject    handle to addBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(handles.tasks, 'String');
val = get(handles.tasks,'Value');

str1 = get(handles.protocols, 'String');
val1 = get(handles.protocols,'Value');

% if no block or no protocol is selected, display error message
if val==1 || val1==1
    set(handles.errorSel,'Visible','on')
else   
    task=str{val};
    protocol=str1{val1};

    a=get(handles.timeline,'string');
    
    % if the timeline is empty
    if strcmp(a{end},'[add blocks]')==1
        a{1}=fullfile(task,protocol);
    else
        a{end+1}=fullfile(task,protocol);
    end
    set(handles.timeline,'string',a);
    set(handles.errorSel,'Visible','off')
    
    timeline_Callback(handles.timeline, eventdata,handles);
    
    drawnow

end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on selection change in tasks.
function tasks_Callback(hObject, eventdata, handles)
% hObject    handle to tasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tasks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tasks

set(handles.protocols,'value',1);
str = get(hObject, 'String');
val = get(hObject,'Value');
if val~=1
    task=str{val}; % gets task's name
    pathFolder=fullfile('_TASKS',task,'protocols');

    info = dir(pathFolder);
    len=size(info);
    protocolsNames{1} = '- Select protocol';
    % for i=4:len
    %     protNames{i-2}=info(i).name;
    % end

    ind=2;
    for i=1:len
        if strcmp(info(i).name(1),'.')==0
            protocolsNames{ind}=info(i).name;
            ind=ind+1;
        end
    end
     % set values as the names of the folders
     set(handles.protocols,'string',protocolsNames);    
     
else
    
    set(handles.protocols,'string',{'- Select protocol'}); 
end

% --- Executes during object creation, after setting all properties.
function tasks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% get contents of folder 'protocol'
pathFolder='_TASKS';
info = dir(pathFolder);
len=size(info);
taskNames{1} = '-Select Block';
% for i=4:len
%     protNames{i-2}=info(i).name;
% end

ind=2;
for i=1:len
    if strcmp(info(i).name(1),'.')==0
        taskNames{ind}=info(i).name;
        ind=ind+1;
    end
end
 % set values as the names of the folders
 set(hObject,'string',taskNames);



% --- Executes on selection change in protocols.
function protocols_Callback(hObject, eventdata, handles)
% hObject    handle to protocols (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns protocols contents as cell array
%        contents{get(hObject,'Value')} returns selected item from protocols


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


% --- Executes on button press in nextSet.
function nextSet_Callback(hObject, eventdata, handles)
% hObject    handle to nextSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\


numSet = str2double(get(handles.numSet, 'string'));
numIt = str2double(get(handles.numIt, 'string'));

if ~isnan(numIt)
    % check if the block is completed
    if (numSet < numIt)

        % get the new set in the iteration
        set(handles.numSet,'string', num2str(numSet+1));
        numSet_ButtonDownFcn(handles.numSet, eventdata,handles);
        drawnow

    % if it's completed, check if there's other blocks in the timeline
    else           
        
        % ---- stop EEG if it's active
        aq=get(handles.eegStatus,'value');
        if aq==1
            set(handles.eegStatus,'value',0);
            eegStatus_Callback(handles.eegStatus, eventdata,handles);
        end
        % ---- 
        
        str = get(handles.timeline, 'String');
        val = get(handles.timeline,'Value');

        % if there is another block, switch to next block
        if val < length(str)
            set(handles.timeline,'Value',val+1);
            numIt_Callback(handles.numIt, eventdata,handles);
            drawnow
        else
            stopButton_Callback(handles.stopButton, eventdata,handles);
        end
    end 
end

% --- Executes on button press in prevSet.
function prevSet_Callback(hObject, eventdata, handles)
% hObject    handle to prevSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



numSet = str2double(get(handles.numSet, 'string'));
numIt = str2double(get(handles.numIt, 'string'));

if ~isnan(numIt)
    if (numSet >1)    
        set(handles.numSet,'string', num2str(numSet-1));
        numSet_ButtonDownFcn(handles.numSet, eventdata,handles);
        drawnow

    else 
        val = get(handles.timeline,'Value');
        if val > 1
            set(handles.timeline,'Value',val-1);
            numIt_Callback(handles.numIt, eventdata,handles);
            drawnow
        end
    end
end



function numIt_Callback(hObject, eventdata, handles)
% hObject    handle to numIt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numIt as text
%        str2double(get(hObject,'String')) returns contents of numIt as a double

str = get(handles.timeline, 'String');
val = get(handles.timeline,'Value');

a=str{val};

if ~strcmp(a,'[add blocks]')
    ind   = strfind(a,filesep);
    task=a(1:ind-1);
    protocol=a(ind+1:end);

    a=dir(fullfile('_TASKS',task,'protocols',protocol,'*.mat'));
    out=size(a,1);
    set(hObject, 'string', out); % set the # of iterations to the # of set files in the block
    set(handles.numSet,'string',1);
    numSet_ButtonDownFcn(handles.numSet, eventdata,handles);
end




% --- Executes during object creation, after setting all properties.
function numIt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numIt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savePath_Callback(hObject, eventdata, handles)
% hObject    handle to savePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savePath as text
%        str2double(get(hObject,'String')) returns contents of savePath as a double


subjName= get(handles.subjName,'string');

% numSet= get(handles.numSet, 'String'); 

str = get(handles.timeline, 'String');
val = get(handles.timeline,'Value');
a=str{val};

[task,nameProtocol]=fileparts(a);
nameSet_Callback(handles.nameSet, eventdata,handles);
nameSet=get(handles.nameSet,'string');

% if it doesn't exist, create the directory for the block
% (resting state doesn't need a folder cause it has no output)
if ~exist(fullfile(subjName,[subjName,'_',nameProtocol]),'dir') && ...
    ~strcmp(task,'RestingState')
   mkdir(subjName,[subjName,'_',nameProtocol])
end

 path=fullfile(subjName,[subjName,'_',nameProtocol],[subjName,'_',nameSet]);

    
set(hObject, 'string',path);

% --- Executes during object creation, after setting all properties.
function savePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if no block or no protocol is selected, display error message

numSet= get(handles.numSet, 'String'); 
str = get(handles.timeline, 'String');
val = get(handles.timeline,'Value');
a=str{val};

if strcmp(a,'[add blocks]')
    set(handles.errormsg3,'Visible','on')
else  
    set(handles.errormsg3,'Visible','off')
    
savePath_Callback(handles.savePath, eventdata,handles);
savePath= get(handles.savePath, 'String');

nameSet=get(handles.nameSet,'string');
[task,protocol]=fileparts(a);

if strcmp(task,'RestingState')
    dataPath=fullfile('_TASKS',task,'protocols',protocol);
else    
    %path=fullfile('_TASKS',task,'protocols',protocol,[protocol,'_set',numSet,'.mat']);
    dataPath=fullfile('_TASKS',task,'protocols',protocol,nameSet);
end
load(dataPath)
% variables defining function parameters now exist in the space

if isempty(savePath)==0
    
    if exist(savePath, 'file') == 2
    q=['The set you selected has been launched already for this subject.'...
        'By proceeding, the data will be overwritten. Do you want to proceed?'];
    answer = questdlg(q,'WARNING: Data already exists', ...
	'Proceed','Cancel','Cancel');
    else
        answer='Proceed';
    end
    
    if strcmp(answer,'Proceed')
        
         % if it's the first set of the block, start the EEG acquisition
        if str2double(numSet)==1
            set(handles.eegStatus,'value',1);
            eegStatus_Callback(handles.eegStatus, eventdata,handles);
        end
    
        switch task
            case 'MotorTask'
                if isempty(numTargets)==1

                    isSetFinished=MotorTaskFUN;

                else
                    [isSetFinished]=MotorTaskFUN(numTargets,numMov,diamTargets,rTargets,centerDim,...
    numSecs,interval,rot,cursorVisible,cursorVisibleWindow,cursorVisibleSpatial,...
    seqTargets,dirTargets,showCross,playSound,isTest,pauseAfter,pauseAfterTime,savePath);
                end 

            case 'MemTask'

                if isempty(seqTargets)==1

                    isSetFinished=MemTaskFUN_wip;

                else
                    colorPath = fullfile('_TASKS','MemTask','colorSequences',['colorSeq',num2str(colorSeq),'.mat']);
                    load(colorPath) % variable colors now exists in the space
                    
                    isSetFinished=MemTaskFUN(seqTargets,diamTargets,rTargets,centerDim,numSecs,...
                            interval,colorTime,colors,savePath);
                end 
                
            case 'VisTask'
%                     colorPath = fullfile('_TASKS','VisTask','colorSequences',['colorSeq',num2str(colorSeq),'.mat']);
%                     load(colorPath) % variable colors now exists in the space
%                     isSetFinished=VisTaskFUN(seqTargets,diamTargets,rTargets,centerDim,numSecs,...
%                             interval,colorTime,colors,dataPath);

                      isSetFinished=VisTaskFUN(seqTargets,diamTargets,rTargets,centerDim,numSecs,...
                            interval,colorTime,savePath);
                        
            case 'RestingState'
                isSetFinished=1;
                RestingState(restTime)
                
            otherwise
                disp('Task does not exist')

        end
        
        if isSetFinished==1 
            nextSet_Callback(handles.nextSet, eventdata,handles);

        else
            %rename the set
            oldPath=get(handles.savePath,'string');
            newPath=[oldPath(1:length(oldPath)-4),'_INTERRUPTED.mat'];

            movefile(oldPath,newPath);
        end        
        
        
    end
    
    % psych sometime gives out and error if space isnt cleared
     clear all
%    clc
end

end

% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
q='Clear the timeline or Stay on current block?';
    answer = questdlg(q,'EXPERIMENT COMPLETED', ...
	'Clear','Stay','Clear');

if strcmp(answer,'Clear')
    
    % clear timeline
    clearTimeline_Callback(handles.clearTimeline,eventdata,handles);
%     set(handles.addBlock,'enable','on');

end

disp('you did it :)')


% --- Executes on button press in pauseButton.
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stopping
stopping = true;

% --- Executes on button press in deleteBlock.
function deleteBlock_Callback(hObject, eventdata, handles)
% hObject    handle to deleteBlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentItems = get(handles.timeline, 'String');
if length(currentItems)==1
    clearTimeline_Callback(handles.clearTimeline, eventdata, handles)
else
    toDelete = get(handles.timeline, 'value');
    currentItems(toDelete)=[];
    set(handles.timeline,'Value',1);
    set(handles.timeline, 'String',currentItems);
end


% --- Executes on button press in clearTimeline.
function clearTimeline_Callback(hObject, eventdata, handles)
% hObject    handle to clearTimeline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.timeline,'Value',1);
set(handles.timeline,'String',{'[add blocks]'});
set(handles.numSet,'string','');       
set(handles.numIt,'string','');
set(handles.savePath,'string','');
set(handles.movementsBox,'Visible','off');


% --- Executes on button press in navigate.
function navigate_Callback(hObject, eventdata, handles)
% hObject    handle to navigate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of navigate


if get(hObject,'Value')==1
    set(handles.timeline,'Enable','on');
    set(handles.startButton,'Enable','off');
    set(handles.stopButton,'Enable','off');
    set(handles.pauseButton,'Enable','off');
    
    set(handles.addBlock,'Enable','on');
    set(handles.deleteBlock,'Visible','on');
    set(handles.clearTimeline,'Visible','on');
    set(handles.saveTimeline,'Visible','on');
    set(handles.loadTimeline,'Visible','on');
    
else
    set(handles.timeline,'Enable','inactive');
    set(handles.timeline,'Value',1);
    set(handles.startButton,'Enable','on');
    set(handles.stopButton,'Enable','on');
    set(handles.pauseButton,'Enable','on');
    
    set(handles.addBlock,'Enable','off');
    set(handles.deleteBlock,'Visible','off');
    set(handles.clearTimeline,'Visible','off');
    set(handles.saveTimeline,'Visible','off');
    set(handles.loadTimeline,'Visible','off');
    
    numIt_Callback(handles.numIt,eventdata,handles);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over numSet.
function numSet_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to numSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

numSet= get(handles.numSet, 'String'); 

str = get(handles.timeline, 'String');
val = get(handles.timeline,'Value');
a=str{val};
[task,protocol]=fileparts(a);

nameSet_Callback(handles.nameSet, eventdata,handles);
nameSet=get(handles.nameSet,'string');


if strcmp(task,'RestingState')
    set(handles.movementsBox,'Visible','off');  
    set(handles.numSet,'String','1');
    set(handles.numIt,'String','1');
else

    path=fullfile('_TASKS',task,'protocols',protocol,nameSet);
    load(path)

    if strcmp(task,'MotorTask')
        [row,col]=size(seqTargets);
        set(handles.movementsBox,'Visible','on');
        set(handles.movementsTxt,'String','# movements');
        set(handles.movements,'String',num2str(numTargets*numMov));

    else

        [row,col]=size(seqTargets);
        set(handles.movementsBox,'Visible','on');
        set(handles.movementsTxt,'String','# sequences');
        set(handles.movements,'String',num2str(row));

    end
end



% --- Executes during object creation, after setting all properties.
function navigate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to navigate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in saveTimeline.
function saveTimeline_Callback(hObject, eventdata, handles)
% hObject    handle to saveTimeline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    p = mfilename('fullpath');
    f=fileparts(p);

timeline=get(handles.timeline,'string');
    
    % if the timeline is empty
    if strcmp(timeline{end},'[add blocks]')==1
        set(handles.error2,'Visible','on')
    else
        set(handles.error2,'Visible','off');
        [file,path] = uiputfile(fullfile(f,'_timelines','*.mat'),'Save timeline');
        if file ~=0
              save(fullfile(path,file),'timeline')
        end
    end
%     set(handles.timeline,'string',timeline);
%     
%     timeline_Callback(handles.timeline, eventdata,handles);
%     
%     drawnow


% --- Executes on button press in loadTimeline.
function loadTimeline_Callback(hObject, eventdata, handles)
% hObject    handle to loadTimeline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    p = mfilename('fullpath');
    f=fileparts(p);
    
[file, path]=uigetfile(fullfile(f,'_timelines','*.mat'),'Select Timeline');
if file ~=0
        load(fullfile(path,file))
        set(handles.timeline,'string',timeline);
end



function movements_Callback(hObject, eventdata, handles)
% hObject    handle to movements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movements as text
%        str2double(get(hObject,'String')) returns contents of movements as a double


% --- Executes during object creation, after setting all properties.
function movements_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movements (see GCBO)
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
        dlgtitle = 'Acquisition parameters';
        dims = [1 35];
        definput = {nameIP,port};
        newParam = inputdlg(prompt,dlgtitle,dims,definput);
        hObject.UserData = newParam;
%         set(hObject,'Value',~acquisition);
        eegStatus_Callback(hObject, eventdata, handles)
    elseif strcmp(answer,'Cancel')
        set(hObject,'Value',~acquisition);
    else
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



function nameSet_Callback(hObject, eventdata, handles)
% hObject    handle to nameSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameSet as text
%        str2double(get(hObject,'String')) returns contents of nameSet as a double

numSet= get(handles.numSet, 'String'); 

str = get(handles.timeline, 'String');
val = get(handles.timeline,'Value');
a=str{val};
[task,block]=fileparts(a);

if strcmp(task,'RestingState')
    setName=block;
else
pathFolder=fullfile('_TASKS',task,'protocols',block);

    info = dir(pathFolder);
    
    for i=1:length(info)
    k = strfind(info(i).name,['set',num2str(numSet)]);
        if ~isempty(k)
            setName=info(i).name;
            break
        end
    end
   
end
set(hObject,'String',setName)


% --- Executes during object creation, after setting all properties.
function nameSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
