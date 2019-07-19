path='/Users/zingarella/Documents/MATLAB/Experiment/_TASKS/RestingState/protocols/';

time={'30s','60s','90s','120s','150s','180','210','240','270','300'};
r=[30,60,90,120,150,180,210,240,270,300];

if length(time)==length(r)
    for i=1:length(time)
        restTime=r(i);
        save([path,'RS_',char(time(i)),'.mat'],'restTime');
    end
else
    disp('check the consistency of the data')
end