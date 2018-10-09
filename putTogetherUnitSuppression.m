function [allx,ally,allx_led,ally_led,unit_isCued,unit_isDriven,allDistance,allIsBehaving]=putTogetherUnitSuppression(datadir)

binsize=1; % in ms
show_binsize=40; % in ms
query_user=0; % 1 if want user to do manual classification of unit response type, else 0
useOptoDelayWindow=[-0.001 0.021]; % use delays between cue and opto within this range, in seconds

l=1;
allx=[];
ally=[];
allx_led=[];
ally_led=[];
unit_isCued=[];
unit_isDriven=[];
allDistance=[];
allIsBehaving=[];
for i=1:length(datadir)
    disp(i);
    d=datadir{i};
    filesInDir=dir(d);
    unitsInThisDir=1;
    a=load([d '\' 'distanceFromMaxExpression.mat']);
    distance=a.distanceFromMaxExpression;
    a=load([d '\' 'isBehaving.mat']);
    isBehaving=a.isBehaving;
    a=load([d '\' 'optoDelays.mat']);
    optoDelays=a.optoDelays;
    for j=1:length(filesInDir)
        if ~isempty(regexp(filesInDir(j).name,'ch','once'))
            % has spikes
            % load
            a=load([d '\' filesInDir(j).name]);
            spikes=a.spikes;
            unit_response_type=a.unit_response_type;
            for k=1:size(unit_response_type,1)
                [x_con,y_con,x_led,y_led]=plotSUresponse(spikes,unit_response_type(k,1),binsize,optoDelays>=useOptoDelayWindow(1) & optoDelays<=useOptoDelayWindow(2),0);
                if length(x_con)>size(allx,2)
                    if l==1
                        allx(l,:)=x_con;
                        ally(l,:)=y_con;
                        allx_led(l,:)=x_led;
                        ally_led(l,:)=y_led;
                    else
                        allx(l,:)=x_con(1:size(allx,2));
                        ally(l,:)=y_con(1:size(allx,2));
                        allx_led(l,:)=x_led(1:size(allx,2));
                        ally_led(l,:)=y_led(1:size(allx,2));
                    end
                elseif length(x_con)<size(allx,2)
                    allx(l,:)=[x_con nan(1,size(allx,2)-length(x_con))];
                    ally(l,:)=[y_con nan(1,size(allx,2)-length(x_con))];
                    allx_led(l,:)=[x_led nan(1,size(allx,2)-length(x_con))];
                    ally_led(l,:)=[y_led nan(1,size(allx,2)-length(x_con))];
                else
                    allx(l,:)=x_con;
                    ally(l,:)=y_con;
                    allx_led(l,:)=x_led;
                    ally_led(l,:)=y_led;
                end
                if query_user==1
                    plotSUresponse(spikes,unit_response_type(k,1),show_binsize,[],1);
                    answer=questdlg('Does unit have response to cue (within first 250 ms)?','Classify unit -- cued');
                    if strcmp(answer,'Cancel')
                        return
                    elseif strcmp(answer,'Yes')
                        unit_isCued(l)=1;
                    else
                        unit_isCued(l)=0;
                    end
                    answer=questdlg('Is unit driven by ReaChR (within first 40 ms)?','Classify unit -- driven');
                    if strcmp(answer,'Cancel')
                        return
                    elseif strcmp(answer,'Yes')
                        unit_isDriven(l)=1;
                    else
                        unit_isDriven(l)=0;
                    end
                else
                    unit_isCued(l)=nan;
                    unit_isDriven(l)=nan;
                end
                allDistance=[allDistance distance];
                allIsBehaving=[allIsBehaving isBehaving];
                l=l+1;
                unitsInThisDir=unitsInThisDir+1;
                close all;
            end
        end
    end
    SU_details.allx=allx(end-(unitsInThisDir-1)+1:end,:);
    SU_details.ally=ally(end-(unitsInThisDir-1)+1:end,:);
    SU_details.allx_led=allx_led(end-(unitsInThisDir-1)+1:end,:);
    SU_details.ally_led=ally_led(end-(unitsInThisDir-1)+1:end,:);
    SU_details.unit_isCued=unit_isCued(end-(unitsInThisDir-1)+1:end);
    SU_details.unit_isDriven=unit_isDriven(end-(unitsInThisDir-1)+1:end);
    SU_details.distanceFromMaxExpression=ones(size(SU_details.unit_isCued)).*distance;
    SU_details.isBehaving=ones(size(SU_details.unit_isCued)).*isBehaving;
    save([d '\' 'SU_details.mat'], 'SU_details');
end
                
 