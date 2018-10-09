function allTrials_optoDelays=classifyTrialByCueOptoDelay(cuetimes,optotimes,isOpto)

optoDelays=optotimes-cuetimes(isOpto==1);
% classify
optoDelays(optoDelays<=0)=0;
optoDelays(optoDelays>=0.01 & optoDelays<=0.022)=0.02;
optoDelays(optoDelays>=0.04 & optoDelays<=0.052)=0.05;

allTrials_optoDelays=nan(size(cuetimes));
allTrials_optoDelays(isOpto==1)=optoDelays;

% fill in for control trials
for i=1:length(allTrials_optoDelays)
    if isnan(allTrials_optoDelays(i))
        % is control trial -- fill in with most recent opto delay setting
        if i==1
            allTrials_optoDelays(i)=allTrials_optoDelays(find(~isnan(allTrials_optoDelays),1,'first'));
        else
            goBackDelays=allTrials_optoDelays(i-1:-1:1);
            allTrials_optoDelays(i)=goBackDelays(find(~isnan(goBackDelays),1,'first'));
        end
    end
end