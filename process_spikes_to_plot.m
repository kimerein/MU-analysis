function [spikes,cuetimes,optotimes]=process_spikes_to_plot(filename,spikes)

% takes spikes struct currently loaded in workspace, grabs details about
% experiment events (including cue and led)
% then switches spikes structure from continuous form to trial-by-trial

% filename='\\research.files.med.harvard.edu\neurobio\MICROSCOPE\Kim\Behavior on Electrophys Rig\str_white\20180417 SORT THIS\str.pl2';
cuech='AI01'; % Plexon system
ledch='AI03'; % Plexon system
ledch='auxData193'; % WHISPER system distractor LED
cuech='auxData195invert'; % WHISPER system inverted cue

% convert spikes to cue-triggered trial-by-trial
[spikes,cuetimes,optotimes]=convertToTrialByTrial_wrapper(spikes,filename,cuech,ledch);

% plot trial durations histogram
[n,x]=histcounts(cuetimes(2:end)-cuetimes(1:end-1),10);
figure(); plot(nanmean([x(1:end-1); x(2:end)],1),n);
xlabel('trial duration (seconds)');
ylabel('count');
title('distribution of trial durations in this experiment');