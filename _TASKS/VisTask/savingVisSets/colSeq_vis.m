% If you want to create new color wheels, copy the base code, modify
% colorSeq (this is the name of the sequence) and colorNames (a cell with
% the colors) and type "colSeq_vis" into the command window.
% This will automatically create a new file into the folder colorSequences and
% update the other sequences if you modified them here.

% NB: with the current settings, colorSequences for the VisTask have to
% contain 12 elements

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

% % .         3
% %       4       2
% %     5           1
% %    6             12
% %     7          11
% % .     8      10
% % .         9

p = mfilename('fullpath');
f=fileparts(p);
idcs   = strfind(f,filesep);
newdir = fullfile(f(1:idcs(end)-1),'colorSequences');

% base code
colorSeq=1;
colorNames = {'or','y','g','bl','v','k','w','gr','br','p','t','r'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');


% base code
colorSeq=2;
colorNames={'g','r','bl','k','v','or','t','y','gr','w','br','p'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');

% base code
colorSeq=3;
colorNames={'g','r','bl','k','v','or','t','y','gr','w','br','p'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');

% base code
colorSeq=4;
colorNames={'g','r','bl','k','v','or','t','y','gr','w','br','p'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');

% base code
colorSeq=5;
colorNames={'g','r','bl','k','v','or','t','y','gr','w','br','p'};
colors=saveColors(colorNames);
save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');

% 
% colorSeq=8;
% colorNames = {'y','br','w','k','gr','p','r','bl','t','v','or','g'};
% colors=saveColors(colorNames);
% save(fullfile(newdir,['colorSeq',num2str(colorSeq)]),'colorSeq','colorNames','colors');
% 
% 
