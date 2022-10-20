function [eventtimes,threshData,data]=getEventsFromAnalogCh(filename,chName)

indFile=regexp(filename,'\');
filedirname=filename(1:indFile(end));

data=[];

if ~isempty(regexp(chName,'AI','once'))
    % assumes this is from a Plexon recording system
    disp('Reading data from file');
    [data]=PL2Ad(filename,chName);
elseif ~isempty(regexp(chName,'auxData','once'))
    % assumes this is from the WHISPER recording system
    disp(['Reading data from file ' chName]);
    auxInd=regexp(filename,'auxData','once');
    invertInd=regexp(chName,'invert','once');
    if ~isempty(invertInd)
        % invert channel
        a=load([filename(1:auxInd-1) chName(1:invertInd-1) '.mat']);
        data=a.data;
        data.Values=range(data.Values)+1-data.Values;
    else
        a=load([filename(1:auxInd-1) chName '.mat']);
        data=a.data;
    end
end
disp('Finding events');
times=0:(1/data.ADFreq):(1/data.ADFreq)*(length(data.Values)-1);
[f,isOn]=findEvents(data.Values,times);
threshData.Values=isOn;
threshData.ADFreq=data.ADFreq;
eventtimes=times(f);
%save([filedirname chName '.mat'],'eventtimes');

end

function [f,isOn]=findEvents(data,times)

askUser=true;
thresh=100;
figure(); 
plot(times,data,'Color','k');
if askUser==true
    thresh=input('Threshold: ');
end
hold on;
line([1 max(times)],[thresh thresh],'Color','r');

% May need to exclude end
% Ask user
timecut=input('Exclude cues after this time (x axis in seconds): ');
data=data(times<timecut);

isOn=data>thresh;
f=find((isOn(2:end)-isOn(1:end-1))==1);
f=f+1;
end