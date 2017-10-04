function makeShutterTriggeredMUResponse(filedir,shuttertimes)

groupChs={[33 35 36 46 51 52 53]; [34 37 38 39 40 41 42 43 44 45 47 48 49 50 54 55 56 57 58 59 60 61 62 63 64]}; % how to sort channels into groups
groupNames={'Driven', 'Suppressed'}; % names of groups, corresponds to elements in groupChs
ch='ch'; % string that indicates files containing spike channel MU data
timeWindowBefore=1; % baseline window before opto stim in sec
timeWindowAfter=3; % window after opto stim in sec


% Load spikes from different channels
listing=dir(filedir);
chNums=[];
binEdges=[];
allspiketimes={};
for i=1:length(groupChs)
    allspiketimes{i}=[];
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
        a=load([filedir '\' curr.name]);
        binEdges=a.out.binEdges;
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
    plot(linspace(-timeWindowBefore,timeWindowAfter,size(trialResponse{i},2)),nanmean(trialResponse{i},1),'Color',colorCycle{colorInd});
    hold on;
end
legend(groupNames); 