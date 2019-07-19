
% If you want to create new color wheels, copy the base code, modify
% colorSeq (this is the name of the sequence) and colorNames (a cell with
% the colors) and type "colSeq_mem" into the command window.
% This will automatically create a new file into the folder colorSequences and
% update the other sequences if you also modified them here.

% NB: with the current settings, colorSequences for the MemTask have to
% contain 8 elements

% red=r
% blue=bl
% green=g
% yellow=y
% teal=t
% orange=or
% brown=br
% white=w
% black=k
% pink=p
% grey=gr
% violet=v

% % target position:

% %              2
% %           3     1
% %         4         8
% %           5     7
% %              6


p = mfilename('fullpath');
f=fileparts(p);
idcs   = strfind(f,filesep);
newdir = fullfile(f(1:idcs(end)-1),'colorSequences');

% base code
colorSeq=1;
colorNames = {'r','y','g','k','or','bl','p','w'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');


% base code
colorSeq=2;
colorNames={'or','k','g','y','r','w','p','bl'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');

% base code
colorSeq=3;
colorNames={'r','w','p','bl','or','k','g','y'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');
