function readMUchannel_andGetSpikes(filename,chName)

indFile=regexp(filename,'\');
filedirname=filename(1:indFile(end));

disp('Reading data from file');
[data]=PL2Ad(filename,chName);
disp('Calculating MU from WB');
mu=filterWBtoMU(data.Values,data.ADFreq);
times=0:(1/data.ADFreq):(1/data.ADFreq)*(length(mu)-1);
% figure(); 
% plot(mu(1:500000));
% th=input('Enter threshold for MU spike detection. ');
th=-0.05;
disp('Detecting MU spikes');
[out,spiketimes,spikeamps]=getMUspikerate(mu,times,th);
save([filedirname chName '.mat'],'out','spiketimes','spikeamps');
close all;