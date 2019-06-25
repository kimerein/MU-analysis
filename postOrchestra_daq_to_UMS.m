function [spikes,expt]=postOrchestra_daq_to_UMS(spikes,expt,trodeInd,detectfilenames)

% spikes file is output from orchestra
%
% expt associated with this spikes file
%
% trodeInd is the index into expt.sort.trode that gives the channels on
%   which these spikes were detected

% Fill in expt fields (usually handled by ExptViewer)
spikes.info.trodeInd=trodeInd;
% Get the indices into expt.files.names that match which files were 
% included in the sort for these spikes
expt.sort.trode(trodeInd).fileInds=getMatchingDaqInds(expt,detectfilenames);
% Get details of threshold from spike sorting
expt.sort.trode(trodeInd).threshtype=spikes.params.detect_method;
expt.sort.trode(trodeInd).thresh=spikes.params.thresh;
expt.sort.trode(trodeInd).detected='yes'; % because I have spikes from daqToUMS_for_orchestra
expt.sort.trode(trodeInd).clustered='yes'; % because I have spikes from daqToUMS_for_orchestra
expt.sort.trode(trodeInd).sorted='no';

% Add .sweeps struct to spikes
spikes = spikesAddSweeps(spikes,expt,trodeInd);

% Add .stimcond to spikes
spikes = spikesAddConds(spikes);

end

function daqInds=getMatchingDaqInds(expt,detectfilenames)

daqInds=nan(1,length(detectfilenames));
for i=1:length(detectfilenames)
    currfilename=detectfilenames{i};
    for j=1:length(expt.files.names)
        indexIntoName=expt.files.names{j};
        if strcmp(currfilename,indexIntoName)==1
            daqInds(i)=j;
            break
        end
    end
end
            
if any(isnan(daqInds))
    error('Files used for spike sort do not match this experiment');
end

end
