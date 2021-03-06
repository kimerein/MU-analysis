function [spikes,cuetimes,optotimes,opto_trials]=convertToTrialByTrial_wrapper(spikes,filename,cueChName,optoChName)

% Note that spikes before first trial will be discarded!

% seconds before cue to begin trial
cueRelativeToTrialStart=1; % in seconds

cuetimes=getEventsFromAnalogCh(filename,cueChName);
optotimes=getEventsFromAnalogCh(filename,optoChName);
[noopto_cuetimes,opto_cuetimes]=findCueWithoutOpto(cuetimes, optotimes, [-0.01 0.2]);
noopto_trials=ismember(cuetimes,noopto_cuetimes);
opto_trials=ismember(cuetimes,opto_cuetimes);
disp('this many noopto trials');
disp(sum(noopto_trials));
disp('this many opto trials');
disp(sum(opto_trials));

spikes=convertContinuousToTrialStructure(spikes,cuetimes-cueRelativeToTrialStart,opto_trials,cueRelativeToTrialStart);

% truncate spikes before first trial
throwOut=isnan(spikes.trials);
f=fieldnames(spikes);
numSpikesAtBeginning=length(spikes.trials);
for i=1:length(f)
    temp=spikes.(f{i});
    if isstruct(temp)
        % ignore
    elseif strcmp(f{i},'waveforms')
        temp=temp(throwOut==false,:,:);
    elseif length(temp)==numSpikesAtBeginning
        temp=temp(throwOut==false);
    end
    spikes.(f{i})=temp;
end


