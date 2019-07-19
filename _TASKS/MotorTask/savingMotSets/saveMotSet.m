function saveMotSet(nameProtocol,numSet,numTargets,numMov,diamTargets,rTargets,centerDim,...
    numSecs,interval,rot,cursorVisible,cursorVisibleWindow,cursorVisibleSpatial,...
    seqTargets,dirTargets,showCross,playSound,isTest,pauseAfter,pauseAfterTime)

% This will create the subfolder "nameProtocol" in the "protocol" folder and 
% save a new set file named "nameProtocol_set(numSet)"
% For more info on the parameters, see Baseline_newSet

    % get current folder
    p = mfilename('fullpath');
    f=fileparts(p);
    idcs   = strfind(f,filesep);
    newdir = fullfile(f(1:idcs(end)-1),'protocols');

%     mydir  = pwd;
%     idcs   = strfind(mydir,filesep);
%     newdir = [fullfile(mydir(1:idcs(end)-1),'protocols')];
 
    mkdir(newdir,nameProtocol)
    protocolPath=fullfile(newdir,nameProtocol,[nameProtocol,'_set' num2str(numSet),'.mat']);

    if exist(protocolPath, 'file') == 2
        q='The set you are creating already exists. By proceeding, the set will be overwritten. Do you want to proceed?';
        answer = questdlg(q,'WARNING: Set already exists', ...
        'Proceed','Cancel','Cancel');
    else
        answer='Proceed';
    end
    
    if strcmp(answer,'Proceed')
            clear answer
            save(protocolPath,'nameProtocol','numSet','numTargets','numMov','diamTargets','rTargets','centerDim',...
    'numSecs','interval','rot','cursorVisible','cursorVisibleWindow','cursorVisibleSpatial','seqTargets','dirTargets',...
    'showCross','playSound','isTest','pauseAfter','pauseAfterTime')  
            disp('Set created')
    else
        disp('Set NOT created')
    end
end