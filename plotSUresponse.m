function [x_con,y_con,x_led,y_led]=plotSUresponse(varargin)

% default is to show plot
doShow=1;

if length(varargin)<4
    spikes=varargin{1};
    ass=varargin{2};
    binsize=varargin{3};
else
    spikes=varargin{1};
    ass=varargin{2};
    binsize=varargin{3};
    useTrials=varargin{4};
    if length(varargin)>4
        doShow=varargin{5};
    end
end

% plot SU response
% which SU is ass, refers to spikes.assigns
% binsize is in ms
if length(varargin)<4
    [~,~,~,x_con,y_con]=show_psth(filtspikes(spikes,0,'assigns',ass,'led',0),binsize,0,min(spikes.sweeps.trialDuration),[]);
    [~,~,~,x_led,y_led]=show_psth(filtspikes(spikes,0,'assigns',ass,'led',1),binsize,0,min(spikes.sweeps.trialDuration),[]);
    if doShow==1
        figure(); plot(x_con,y_con,'Color','k'); hold on; plot(x_led,y_led,'Color','r');
    end
else
    if islogical(useTrials)
        useTrials=find(useTrials==1);
    elseif isempty(useTrials)
        useTrials=unique(spikes.trials);
        useTrials=useTrials(~isnan(useTrials));
    end
    [~,~,~,x_con,y_con]=show_psth(filtspikes(spikes,0,'assigns',ass,'led',0,'trials',useTrials),binsize,0,min(spikes.sweeps.trialDuration),length(useTrials));
    [~,~,~,x_led,y_led]=show_psth(filtspikes(spikes,0,'assigns',ass,'led',1,'trials',useTrials),binsize,0,min(spikes.sweeps.trialDuration),length(useTrials));
    if doShow==1
        figure(); plot(x_con,y_con,'Color','k'); hold on; plot(x_led,y_led,'Color','r');
    end
end