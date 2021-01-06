function [data1,data2,data3,data4]=removeChewingNoise(data1,data2,data3,data4)

% note that chewing in the mouse occurs at a frequency of approx. 7 Hz
% cycle is 1/7 Hz = 143 ms
chewing_cycle=0.143; % in seconds
% if more than X% of the points within a cycle are greater than ~7 times the
% standard deviation of the high-frequency noise, this is likely a chewing
% bout
threshX=1*10^-4;
nStdDevsForChew=7; % n times the std dev of high freq noise
% good spike amplitudes tend to be between 4 and 7 times the std dev of the
% HF noise
% importantly, chewing is nearly identical across all channels, whereas
% spikes have different amplitudes on different channels (are point
% sources)
% chewing noise artifact is SLIGHTLY lower frequency than real spikes --
% use this 
upperCutoff=2500; % in Hz; 2500 Hz is 2X the width of a spike, should be OK
% don't want to use fft, because will be too slow on huge data sets
% ideally, just use threshold crossings for this noise reduction

Fs=data1.ADFreq;

timeBins=0:1/Fs:(length(data1.Values)-1)*(1/Fs);

binWidthInInds=floor(chewing_cycle/(1/Fs));

% get HF noise
data1_stdev=nanstd(data1.Values);
data2_stdev=nanstd(data2.Values);
data3_stdev=nanstd(data3.Values);
data4_stdev=nanstd(data4.Values);

frac1=nan(1,length(1:floor(binWidthInInds/4):length(data1.Values)));
frac2=nan(1,length(1:floor(binWidthInInds/4):length(data1.Values)));
frac3=nan(1,length(1:floor(binWidthInInds/4):length(data1.Values)));
frac4=nan(1,length(1:floor(binWidthInInds/4):length(data1.Values)));
j=1;
% overlapping bins
for i=1:floor(binWidthInInds/4):length(data1.Values)
    % plot fraction points above nStdDevsForChew * stdev of HF noise in binWidthInInds
    % positive-going direction, because extracellular spikes tend to be in
    % the negative-going direction
    if i+binWidthInInds-1>length(data1.Values)
        indsRange=i:length(data1.Values);
    else
        indsRange=i:i+binWidthInInds-1;
    end
    frac1(j)=nansum(data1.Values(indsRange)>(nStdDevsForChew*data1_stdev))/length(data1.Values(indsRange));
    frac2(j)=nansum(data2.Values(indsRange)>(nStdDevsForChew*data2_stdev))/length(data2.Values(indsRange));
    frac3(j)=nansum(data3.Values(indsRange)>(nStdDevsForChew*data3_stdev))/length(data3.Values(indsRange));
    frac4(j)=nansum(data4.Values(indsRange)>(nStdDevsForChew*data4_stdev))/length(data4.Values(indsRange));
    j=j+1;
end

matchedBins=1:floor(binWidthInInds/4):length(data1.Values);
matchedTimeBins=timeBins(matchedBins);
figure();
plot(matchedTimeBins,frac1);
hold all;
plot(matchedTimeBins,frac2);
plot(matchedTimeBins,frac3);
plot(matchedTimeBins,frac4);

% get common mode
cm=median([bandPassLFP(data1.Values,data1.ADFreq,1,upperCutoff,0); bandPassLFP(data2.Values,data1.ADFreq,1,upperCutoff,0); bandPassLFP(data3.Values,data1.ADFreq,1,upperCutoff,0); bandPassLFP(data4.Values,data1.ADFreq,1,upperCutoff,0)],1,'omitnan');

% For time windows when all channels are above threshX, use common mode
% referencing
removed_commonmode=zeros(1,length(data1.Values));
for i=1:length(frac1)
    if frac1(i)>threshX && frac2(i)>threshX && frac3(i)>threshX && frac4(i)>threshX
        % common mode reference
        if matchedBins(i)+binWidthInInds-1>length(data1.Values)
            indsRange=matchedBins(i):length(data1.Values);
        else
            indsRange=matchedBins(i):matchedBins(i)+binWidthInInds-1;
        end
        % find inds not yet corrected
        temp=removed_commonmode==0 & ismember(1:length(cm),indsRange);
        % change these inds and keep track of which inds changed
        removed_commonmode(temp)=1;
        data1.Values(temp)=data1.Values(temp)-cm(temp);
        data2.Values(temp)=data2.Values(temp)-cm(temp);
        data3.Values(temp)=data3.Values(temp)-cm(temp);
        data4.Values(temp)=data4.Values(temp)-cm(temp);
    end
end
    
figure();
plot(matchedTimeBins,frac1);
hold all;
plot(matchedTimeBins,frac2);
plot(matchedTimeBins,frac3);
plot(matchedTimeBins,frac4);
plot(timeBins,removed_commonmode*nanmax(frac1),'Color','k');
title('which inds changed');
    
    