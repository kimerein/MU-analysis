function readWHISPERData_wrapper(bin_name,data_path,save_path)

% warning: 1 min of data takes about 90 sec to read over VPN, about another
% 90 sec to filter and save
% bin_name, e.g., July_3__g0_t0.nidq.bin
% data_path, e.g., \\research.files.med.harvard.edu\neurobio\MICROSCOPE\Kim\WHISPER recs\July_3\20201229\phys\July_3__g0\

WHISPER_acquisition_order=[0:31]+1; % channel names and acquisition order according to WHISPER system
super_to_deep=[15 19 13 18 14 17 11 16 9 12 7 10 8 5 6 4 25 27 29 31 35 33 32 34 23 30 22 28 21 26 20 24]; % ordering of these WHISPER channels from superficial to deep
aux_analogInput_chs=[192:195]; % auxiliary analog input channels according to WHISPER system

% Ask user for binary file
% [bin_name,data_path] = uigetfile('*.bin', 'Select Binary File');

% create trodes to sort channels from superficial to deep
[~,si]=sort(super_to_deep,'ascend');
super_to_deep_WHISPER=WHISPER_acquisition_order(si);

chSaveNames=cell(1,length(super_to_deep_WHISPER)+length(aux_analogInput_chs));
for i=1:length(super_to_deep_WHISPER)
    chSaveNames{i}=[save_path 'data' num2str(i) '.mat'];
end
j=1;
for i=length(super_to_deep_WHISPER)+1:length(super_to_deep_WHISPER)+length(aux_analogInput_chs)
    chSaveNames{i}=[save_path 'auxData' num2str(aux_analogInput_chs(j)) '.mat'];
    j=j+1;
end

readWHISPERData(bin_name, data_path, [super_to_deep_WHISPER length(super_to_deep_WHISPER)+1:length(super_to_deep_WHISPER)+length(aux_analogInput_chs)], chSaveNames);

end