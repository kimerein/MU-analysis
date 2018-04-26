function eventtimes=getEventsFromAnalogCh(filename,chName)

indFile=regexp(filename,'\');
filedirname=filename(1:indFile(end));

disp('Reading data from file');
[data]=PL2Ad(filename,chName);
disp('Finding events');
times=0:(1/data.ADFreq):(1/data.ADFreq)*(length(data.Values)-1);
f=findEvents(data.Values,times);
eventtimes=times(f);
save([filedirname chName '.mat'],'eventtimes');

function f=findEvents(data,times)

thresh=100;
figure(); 
plot(times,data,'Color','k');
hold on;
line([1 max(times)],[thresh thresh],'Color','r');

% May need to exclude end
% Ask user
timecut=input('Exclude cues after this time (x axis in seconds): ');
data=data(times<timecut);

isOn=data>thresh;
f=find((isOn(2:end)-isOn(1:end-1))==1);
f=f+1;