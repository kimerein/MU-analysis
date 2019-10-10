% function daqToUMS_for_orchestra()

addpath(genpath('daq_to_UMS_code'));
addpath(genpath('UltraMegaSort'));
addpath(genpath('Scanziani_Analysis_Code'));

cd('daq_data');

a=load('detectfilenames.mat');
detectfilenames=a.detectfilenames;

a=load('doTrodes1.mat');
doTrodes=a.doTrodes;

a=load('expt.mat');
expt=a.expt;

a=load('KR_2016-02-20_Mawake402_T0+1i_trode1_Ch_23_15_22_14_S1_spikes.mat');
spikes=a.spikes;

spikes = ss_energy(spikes);
disp(['T' num2str(itrode) ' spikes energy']);
spikes = ss_aggregate(spikes);
disp(['T' num2str(itrode) ' spikes aggregated']);

% Save
SaveAssignStructs(spikes);
disp(['Saved T1 spikes after clustering']);
