function [out,spiketimes,spikeamps]=getMUspikerate(data,times,thresh)

[pks,locs]=findpeaks(-data);
countAsSpikes=locs(pks>-thresh);
spiketimes=times(countAsSpikes);
spikeamps=pks(pks>-thresh);
h=histogram(spiketimes,linspace(min(times),max(times),(max(times)-min(times))./0.01));
out.counts=h.Values;
out.binEdges=h.BinEdges;
