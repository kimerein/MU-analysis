function out=makeShutterTriggeredMUResponse(filedir,shuttertimes,useThresh)

% groupChs={[33 35 36 46 51 52 53]; [34 38 40 41 42 43 44 45 49 50 54 55 56 59 60]}; % how to sort channels into groups
% groupChs={[35 36 46 53]; [41 42 44 45 47 48 49 54 55 57]}; % how to sort channels into groups
% [34 37 38 39 40 41 42 43 44 45 47 48 49 50 54 55 56 57 58 59 60 61 62 63 64]

groupChs={[16 17 18 19 20 22 24]; [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 21 23 25 26 27 28 29 30 31 32]}; % how to sort channels into groups

groupNames={'Driven', 'Suppressed'}; % names of groups, corresponds to elements in groupChs
% ch='ch'; % string that indicates files containing spike channel MU data
ch='WB'; % string that indicates files containing spike channel MU data
timeWindowBefore=1; % baseline window before opto stim in sec
timeWindowAfter=5; % window after opto stim in sec
binsize=0.03; % in seconds
normByNumChs=1; % if 1, will divide through by number of channels in group

% Load spikes from different channels
if ~iscell(filedir)
    temp{1}=filedir;
    filedir=temp;
end
binEdges=[];
for k=1:length(filedir)
    listing=dir(filedir{k});
    if k==1
        chNums=[];
        binEdges=[];
        allspiketimes={};
        for i=1:length(groupChs)
            allspiketimes{i}=[];
        end
    end
    for i=1:length(listing)
        curr=listing(i);
        firstInd=regexp(curr.name,ch);
        matInd=regexp(curr.name,'.mat');
        if ~isempty(matInd) && ~isempty(firstInd)
            % is .mat file and contains ch
            chIDstart=firstInd+length(ch);
            chIDend=matInd-1;
            chNum=str2num(curr.name(chIDstart:chIDend));
            chNums=[chNums chNum];
            a=load([filedir{k} '\' curr.name]);
            currBinEdges=a.out.binEdges;
            if ~isempty(useThresh)
                if isfield(a,'spikeamps')
                    a.spiketimes=a.spiketimes(a.spikeamps>-useThresh);
                end
            end
            inGroup=0;
            for j=1:length(groupChs)
                if ismember(chNum,groupChs{j})
                    inGroup=1;
                    break
                end
            end
            if inGroup==0 % discard this ch
            else
                allspiketimes{j}=[allspiketimes{j} a.spiketimes];
            end
        end
    end
    binEdges=[binEdges currBinEdges];
end
binEdges=sort(unique(binEdges));
binEdges=min(binEdges):binsize:max(binEdges);
        
shuttertimes=shuttertimes(shuttertimes>binEdges(1) & shuttertimes<binEdges(end));

% Make shutter-triggered response
for i=1:length(allspiketimes)
    [histo(i).counts,histo(i).binEdges]=histcounts(allspiketimes{i},binEdges);
end
indsBefore=ceil(timeWindowBefore./(binEdges(2)-binEdges(1)));
indsAfter=ceil(timeWindowAfter./(binEdges(2)-binEdges(1)));
trialResponse=cell(1,length(allspiketimes));
binTimes=nanmean([binEdges(1:end-1); binEdges(2:end)],1);
for i=1:length(allspiketimes)
    trialResponse{i}=nan(length(shuttertimes),indsBefore+indsAfter);
end
for i=1:length(histo)
    currcounts=histo(i).counts;
    currResponse=trialResponse{i};
    for j=1:length(shuttertimes)
        [~,mi]=min(abs(binTimes-shuttertimes(j)));
        startInd=mi-indsBefore;
        endInd=mi+indsAfter-1;
        if startInd<1 && endInd>length(currcounts)
            currResponse(j,:)=[nan(1,1-startInd) currcounts(1:end) nan(1,endInd-length(currcounts))];
        elseif startInd<1
            currResponse(j,:)=[nan(1,1-startInd) currcounts(1:endInd)];
        elseif endInd>length(currcounts)
            currResponse(j,:)=[currcounts(startInd:end) nan(1,endInd-length(currcounts))];
        else
            currResponse(j,:)=currcounts(startInd:endInd);
        end
    end
    trialResponse{i}=currResponse;
end

% Plot shutter-triggered response
colorCycle={'k','r','b','m','g','y','c'};
figure();
for i=1:length(trialResponse)
    colorInd=mod(i,length(colorCycle));
    if normByNumChs==1
        x(i,:)=linspace(-timeWindowBefore,timeWindowAfter,size(trialResponse{i},2));
        y(i,:)=nanmean(trialResponse{i},1)./length(groupChs{i});
    else
        x(i,:)=linspace(-timeWindowBefore,timeWindowAfter,size(trialResponse{i},2));
        y(i,:)=nanmean(trialResponse{i},1);
    end
    plot(x(i,:),y(i,:),'Color',colorCycle{colorInd});
    hold on;
end
legend(groupNames);

out.x=x;
out.y=y;