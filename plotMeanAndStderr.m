function plotMeanAndStderr(x_timepoints,data1,data2,c1,c2,doFill,ds,doSmooth,smoothBy)

doRectangularFill=1;

doNorm=0;
normWindow=[0 1];
if doNorm==1
    data1=data1./repmat(nanmean(data1(:,x_timepoints>=normWindow(1) & x_timepoints<=normWindow(2)),2),1,size(data1,2));
    data2=data2./repmat(nanmean(data2(:,x_timepoints>=normWindow(1) & x_timepoints<=normWindow(2)),2),1,size(data1,2));
end

data1=downSampMatrix(data1,ds);
data2=downSampMatrix(data2,ds);
x_timepoints=downSampMatrix(x_timepoints,ds);

if doSmooth==1
    figure();
    plot(x_timepoints,smooth(nanmean(data1,1),smoothBy),'Color',c1);
    hold on;
    if doFill==1
        fill([x_timepoints fliplr(x_timepoints)],[smooth(nanmean(data1,1)+nanstd(data1,[],1)./sqrt(size(data1,1)),smoothBy)' smooth(fliplr(nanmean(data1,1)-nanstd(data1,[],1)./sqrt(size(data1,1))),smoothBy)'],[0.5 0.5 0.5]);
    end
    plot(x_timepoints,smooth(nanmean(data1,1),smoothBy),'Color',c1);
    plot(x_timepoints,smooth(nanmean(data1,1)+nanstd(data1,[],1)./sqrt(size(data1,1)),smoothBy),'Color',c1);
    plot(x_timepoints,smooth(nanmean(data1,1)-nanstd(data1,[],1)./sqrt(size(data1,1)),smoothBy),'Color',c1);
    
    plot(x_timepoints,smooth(nanmean(data2,1),smoothBy),'Color',c2);
    if doFill==1
        fill([x_timepoints fliplr(x_timepoints)],[smooth(nanmean(data2,1)+nanstd(data2,[],1)./sqrt(size(data2,1)),smoothBy)' smooth(fliplr(nanmean(data2,1)-nanstd(data2,[],1)./sqrt(size(data2,1))),smoothBy)'],[0.1 0.7 0.5]);
    end
    plot(x_timepoints,smooth(nanmean(data2,1),smoothBy),'Color',c2);
    plot(x_timepoints,smooth(nanmean(data2,1)+nanstd(data2,[],1)./sqrt(size(data2,1)),smoothBy),'Color',c2);
    plot(x_timepoints,smooth(nanmean(data2,1)-nanstd(data2,[],1)./sqrt(size(data2,1)),smoothBy),'Color',c2);
    
    plot(x_timepoints,smooth(nanmean(data1,1),smoothBy),'Color',c1);
else
    figure();
    plot(x_timepoints,nanmean(data1,1),'Color',c1);
    hold on;
    if doFill==1
        if doRectangularFill==1
            temp=x_timepoints;
            temp=temp(~isnan(temp));
            useThese=1:2:length(temp);
            temp=diff(x_timepoints);
            temp=temp(temp~=0);
            diffTimes=mode(temp);
            for i=1:length(useThese)
                a=nanmean(data1(:,useThese(i)),1)+nanstd(data1(:,useThese(i)),[],1)./sqrt(size(data1,1));
                b=nanmean(data1(:,useThese(i)),1)-nanstd(data1(:,useThese(i)),[],1)./sqrt(size(data1,1));
                rectangle('Position',[x_timepoints(useThese(i)) b diffTimes (a-b)],'FaceColor',[0.5 0.5 0.5]);
            end
        else
            fill([x_timepoints fliplr(x_timepoints)],[nanmean(data1,1)+nanstd(data1,[],1)./sqrt(size(data1,1)) fliplr(nanmean(data1,1)-nanstd(data1,[],1)./sqrt(size(data1,1)))],[0.5 0.5 0.5]);
        end
    end
    plot(x_timepoints,nanmean(data1,1),'Color',c1);
    plot(x_timepoints,nanmean(data1,1)+nanstd(data1,[],1)./sqrt(size(data1,1)),'Color',c1);
    plot(x_timepoints,nanmean(data1,1)-nanstd(data1,[],1)./sqrt(size(data1,1)),'Color',c1);
    
    plot(x_timepoints,nanmean(data2,1),'Color',c2);
    if doFill==1
        if doRectangularFill==1
            temp=x_timepoints;
            temp=temp(~isnan(temp));
            useThese=1:2:length(temp);
            temp=diff(x_timepoints);
            temp=temp(temp~=0);
            diffTimes=mode(temp);
            for i=1:length(useThese)
                a=nanmean(data2(:,useThese(i)),1)+nanstd(data2(:,useThese(i)),[],1)./sqrt(size(data2,1));
                b=nanmean(data2(:,useThese(i)),1)-nanstd(data2(:,useThese(i)),[],1)./sqrt(size(data2,1));
                rectangle('Position',[x_timepoints(useThese(i)) b diffTimes (a-b)],'FaceColor',[0.1 0.7 0.5]);
            end
        else
            fill([x_timepoints fliplr(x_timepoints)],[nanmean(data2,1)+nanstd(data2,[],1)./sqrt(size(data2,1)) fliplr(nanmean(data2,1)-nanstd(data2,[],1)./sqrt(size(data2,1)))],[0.1 0.7 0.5]);
        end
    end
    plot(x_timepoints,nanmean(data2,1),'Color',c2);
    plot(x_timepoints,nanmean(data2,1)+nanstd(data2,[],1)./sqrt(size(data2,1)),'Color',c2);
    plot(x_timepoints,nanmean(data2,1)-nanstd(data2,[],1)./sqrt(size(data2,1)),'Color',c2);
    
    plot(x_timepoints,nanmean(data1,1),'Color',c1);
end