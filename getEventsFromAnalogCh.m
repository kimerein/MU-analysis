function eventtimes=getEventsFromAnalogCh(filename,chName)

indFile=regexp(filename,'\');
filedirname=filename(1:indFile(end));

disp('Reading data from file');
[data]=PL2Ad(filename,chName);
disp('Finding events');
f=findEvents(data.Values);
times=0:(1/data.ADFreq):(1/data.ADFreq)*(length(data.Values)-1);
eventtimes=times(f);
save([filedirname chName '.mat'],'eventtimes');
close all;

function f=findEvents(data)

thresh=50;
isOn=data>thresh;
f=find((isOn(2:end)-isOn(1:end-1))==1);