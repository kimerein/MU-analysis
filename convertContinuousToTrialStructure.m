function spikes=convertContinuousToTrialStructure(spikes,trialStartTimes,isLEDtrial,cueRelativeToTrialStart)

whichTrialStart=nan(1,length(spikes.spiketimes));
for i=1:length(trialStartTimes)
    temp=spikes.spiketimes-trialStartTimes(i);
    whichTrialStart(temp>=0)=i;
end

spikes.trials=whichTrialStart;
temp=1:length(trialStartTimes);
temp2=spikes.trials;
temp2(isnan(temp2))=1;
spikes.spiketimes=spikes.spiketimes-trialStartTimes(temp2);
spikes.led=ismember(spikes.trials,temp(isLEDtrial));
spikes.led=single(spikes.led);
spikes.info.cue_thisManyS_beforeTrialOnset=cueRelativeToTrialStart;

spikes.sweeps.trials=temp;
spikes.sweeps.led=single(isLEDtrial);
spikes.sweeps.trialDuration=[trialStartTimes(2:end)-trialStartTimes(1:end-1) max(spikes.spiketimes)-trialStartTimes(end)];
