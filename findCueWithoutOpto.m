function [noopto_cuetimes,opto_cuetimes]=findCueWithoutOpto(cuetimes, optotimes, delayWindow)

% delayWindow(1) is min delay after cue for opto to begin
% delayWindow(2) is max delay after cue for opto to begin

minopto=cuetimes+delayWindow(1);
maxopto=cuetimes+delayWindow(2);

hasopto=zeros(1,length(cuetimes));

for i=1:length(minopto)
    if any(optotimes>minopto(i) & optotimes<maxopto(i))
        hasopto(i)=1;
    end
end

noopto_cuetimes=cuetimes(hasopto==0);
opto_cuetimes=cuetimes(hasopto==1);