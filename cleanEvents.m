% This function cleans the events Ts data to remove doublets
function cleaned_events=cleanEvents(TS)
toBeRemoved=[];
for i=1:length(TS)-1
    if (abs(TS(i+1)-TS(i))>0 ) && abs(TS(i+1)-TS(i))<0.005
        toBeRemoved=[toBeRemoved i+1];
    end
end

TS(toBeRemoved)=[];
toBeRemoved=[];
for i=1:length(TS)-1
    if (abs(TS(i+1)-TS(i))>0 ) && abs(TS(i+1)-TS(i))<0.005
        toBeRemoved=[toBeRemoved i+1];
    end
end
TS(toBeRemoved)=[];
cleaned_events=TS;