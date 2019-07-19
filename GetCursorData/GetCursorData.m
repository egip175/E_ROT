function GetCursorData

% m.Data(1) --> status (0: m ready / 1: break / 2: done-waiting)
% m.Data(2) --> path length (len)
% m.Data(3:len+2) --> path string
% m.Data(len+3) --> target status

global window


%--------------------------------------------------------------------------
% il file mappato in memoria e' salvato nella
% cartella Applications che e' comune a tutti i Mac

filename='/Applications/writingfile.mat';
m= memmapfile(filename, 'Writable', true, 'Format', 'uint8');
%--------------------------------------------------------------------------

m.Data(1)=0; % signal active status

% get path where to save the data mat
len=m.Data(2);
path=(char(m.Data(3:len+2))');
t=double(m.Data(2))+3; 


a=0;
i=1;
tic
data=nan(155000,4); % 1 sample every 4ms for max600s = 150000

% break after 600 seconds 
while a < 600
    [x, y] = GetMouse(window);
%     x1 = (x-xCenter)*cosd(rot) - (y-yCenter)*sind(rot);
%     y1 = (x-xCenter)*sind(rot) + (y-yCenter)*cosd(rot);
    target=double(m.Data(t));
    data(i,:)=[GetSecs,x,y,target];
    pause(0.0045)
    if m.Data(1)==1
        break
    end
    i=i+1;
    a=toc;
end

save(fullfile(path,'zzz_GetCursorData.mat'),'data');
m.Data(1)=2; % signal done status

end 
