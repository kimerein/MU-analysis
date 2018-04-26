function out=eventTriggeredSU(allspiketimes,shuttertimes)

timeWindowBefore=1; % baseline window before opto stim in sec
timeWindowAfter=5; % window after opto stim in sec
binsize=0.02; % in seconds

binEdges=0:binsize:max(allspiketimes);

% Make shutter-triggered response
[histo.counts,histo.binEdges]=histcounts(allspiketimes,binEdges);
indsBefore=ceil(timeWindowBefore./(binEdges(2)-binEdges(1)));
indsAfter=ceil(timeWindowAfter./(binEdges(2)-binEdges(1)));
binTimes=nanmean([binEdges(1:end-1); binEdges(2:end)],1);
trialResponse{1}=nan(length(shuttertimes),indsBefore+indsAfter);
temp=histo;
histo(1).counts=temp.counts;
histo(1).binEdges=temp.binEdges;
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
    x(i,:)=linspace(-timeWindowBefore,timeWindowAfter,size(trialResponse{i},2));
    y(i,:)=nanmean(trialResponse{i},1);
    plot(x(i,:),y(i,:),'Color',colorCycle{colorInd});
    hold on;
end

out.x=x;
out.y=y;