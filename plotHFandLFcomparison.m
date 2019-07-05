function plotHFandLFcomparison(psth,plotThisUnit,noThetaTrials,ds,ledOff,ledOn,useTrials)

params.Fs=1/(psth.t(2)-psth.t(1));
params.tapers=[3 5];
params.fpass=[1 50];
movingwin=[1 0.05];
params.trialave=1;

led=psth.unitLED{plotThisUnit};

temp=psth.psths{plotThisUnit};

figure();
plot(downSampAv(psth.t,ds),downSampAv(nanmean(temp(ismember(psth.unitLED{plotThisUnit},ledOff) & ismember(psth.unitTrials{plotThisUnit},useTrials),:),1),ds),'Color','k');
hold on;
plot(downSampAv(psth.t,ds),downSampAv(nanmean(temp(ismember(psth.unitLED{plotThisUnit},ledOn) & ismember(psth.unitTrials{plotThisUnit},useTrials),:),1),ds),'Color','b');
title('Firing rate');
xlabel('Time (seconds)');
ylabel('spikes per second');
legend({'LED off','LED on'});

[S,t,f]=mtspecgrampb(temp(ismember(led,ledOff) & noThetaTrials'==1,:)',movingwin,params);
figure(); plot(t,nanmean(S(:,f>=1 & f<=12),2),'Color','b'); hold on; plot(t,nanmean(S(:,f>=12 & f<=30),2),'Color','r');
title('No theta trials');
xlabel('Time (seconds)');
ylabel('Power');
legend({'1-12 Hz','12-30 Hz'});

[S,t,f]=mtspecgrampb(temp(ismember(led,ledOff) & noThetaTrials'==0,:)',movingwin,params);
figure(); plot(t,nanmean(S(:,f>=1 & f<=12),2),'Color','b'); hold on; plot(t,nanmean(S(:,f>=12 & f<=30),2),'Color','r');
title('Theta trials');
xlabel('Time (seconds)');
ylabel('Power');
legend({'1-12 Hz','12-30 Hz'});