% function daqToUMS_for_orchestra()

a=load('detectfilenames.mat');
detectfilenames=a.detectfilenames;

a=load('doTrodes.mat');
doTrodes=a.doTrodes;

a=load('expt.mat');
expt=a.expt;

detectFiles=1:length(detectfilenames);
for i=1:length(doTrodes)
    channels=doTrodes{i};
    
    chStr = [];
    for j = 1:length(channels)
        temp = num2str(channels(j));
        chStr = [chStr '_' temp];
    end
    fName = getFilename(expt.name);
    fName = [fName '_T' num2str(i) '_Ch' chStr '_S1' '_spikes'];
    
    % Make new default spikes struct
    Fs = expt.files.Fs(1);
    spikes = ss_default_params_custom(Fs);
    
    spikes.info.spikesfile = fName;
    SaveAssignStructs(spikes);
    
    for fileInd = detectFiles
        Triggers = expt.files.triggers(fileInd);
        duration = expt.files.duration(fileInd);
        
        % Estimate noise SD using median absolute deviation derived from a
        % random subset of files to sort
        if fileInd == detectFiles(1)
            Fs = expt.files.Fs(fileInd);
            
            disp('Computing noise SD...')
            nFiles = min(2,length(detectFiles)); % How many files to use to calculate stddev
            temp = randperm(length(detectFiles));
            sampFiles = detectFiles(temp(1:nFiles));
            dataTemp = [];
            for j=1:length(channels)
                disp(['Reading in ' num2str(j) ' of ' num2str(length(channels)) ' channels...']);
                dataTemp2=[];
                for i = 1:length(sampFiles)
                    disp(['Reading in ' num2str(i) ' of ' num2str(length(sampFiles)) ' files...']);
                    data = daqread([detectfilenames{fileInd}],'Channels',channels(j));
                    dataTemp2 = [dataTemp2; data];
                end
                dataTemp=[dataTemp dataTemp2];
            end
            k = find(isnan(dataTemp(:,1)));
            dataTemp(k,:) = [];
            dataTemp = filtdata(dataTemp,Fs,[],'band',[500 10000],[300 12000]); % Band-pass 0.5-10 kHz
            stds = 1.4785*mad(dataTemp,1);
            clear dataTemp
        end
        
        % Load daq file
        disp('Reading daq file...')
        disp(detectfilenames{fileInd});
        data = daqread([detectfilenames{fileInd}],'Channels',channels);
        
        % Reformat data from daq file organization (All samples x Channnels
        % to Samples x Triggers x Channels)
        data = MakeDataMat(data,Triggers,Fs,duration);
        
        % Band-pass filter data (0.5-10 kHz)
        for i = 1:size(data,3)
            data(:,:,i) = filtdata(data(:,:,i),Fs,[],'band',[500 10000],[300 12000]);
        end
        
        for i = 1:size(data,2)
            if size(data,3) > 1 % If more than 1 channel
                dataTemp{i} = squeeze(permute(data(:,i,:),[2 1 3]));
            else
                dataTemp{i} = data(:,i);
            end
        end
        data = dataTemp; clear dataTemp
        
        % Detect. Spikes are appended on each loop
        spikes = ss_detect_custom(data,spikes,stds);                             % Triggers x Samples x Channels
        clear data
        
        % Set additional information in spikes struct
        spikes.info.exptfile = expt.info.exptfile;
        spikes.info.trodeInd = i;
        
        % Save
        SaveAssignStructs(spikes);
    end
    
    % Cluster
    spikes = ss_align(spikes);
    spikes = ss_kmeans(spikes);
    spikes = ss_energy(spikes);
    spikes = ss_aggregate(spikes);
    
    % Save
    SaveAssignStructs(spikes);
end