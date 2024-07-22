function [eventtimes,threshData,data,answerout]=getEventsFromAnalogCh(varargin)

if length(varargin)==2
    filename=varargin{1};
    chName=varargin{2};
    answer=nan;
elseif length(varargin)==3
    filename=varargin{1};
    chName=varargin{2};
    answer=varargin{3};
else
    error('Wrong number of arguments passed to getEventsFromAnalogCh.m');
end

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
[f,isOn,answerout]=findEvents(data.Values,times,answer);
threshData.Values=isOn;
threshData.ADFreq=data.ADFreq;
eventtimes=times(f);
%save([filedirname chName '.mat'],'eventtimes');

end

function [f,isOn,answerout]=findEvents(data,times,answer)

askUser=true;
thresh=100;
figure(); 
subplot(2,1,1);
plot(times,data,'Color','k');
subplot(2,1,2);
plot(times(times<500),data(times<500),'Color','k');
if askUser==true
    if ~isnan(answer)
        thresh=answer(1);
        answerout(1)=thresh;
    else
        thresh=input('Threshold: ');
        answerout(1)=thresh;
    end
end
hold on;
line([1 max(times)],[thresh thresh],'Color','r');

% May need to exclude end
% Ask user
if ~isnan(answer)
    timecut=answer(2);
    answerout(2)=thresh;
else
    timecut=input('Exclude cues after this time (x axis in seconds): ');
    answerout(2)=thresh;
end
data=data(times<timecut);

isOn=data>thresh;
f=find((isOn(2:end)-isOn(1:end-1))==1);
f=f+1;
end