function SaveAssignStructs(spikes)

% Save spikes and expt
save(getFilename(spikes.info.spikesfile),'spikes','-v7.3');
% Assign in base
assignin('base','spikes',spikes);