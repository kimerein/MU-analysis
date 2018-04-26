function [cut_data,excludeChunks,useInds]=excludeInds(data,excludeChunks)

% Rows are values at different time points
% Columns are different channels

chunkSize=10000000;

if isempty(excludeChunks)
    disp('Enter "done" when finished with each segment.');
    chunkNum=1;
    figure();
    for i=1:chunkSize:size(data,1)
        if i+chunkSize-1>size(data,1)
            plot(i:size(data,1),data(i:end,1),'Color','k');
        else
            plot(i:i+chunkSize-1,data(i:i+chunkSize-1,1),'Color','k');
        end
        set(gca,'XMinorTick','on','YMinorTick','off');
        ticklabelformat(gca,'x','%.4e');
        uin='starting';
        safetycounter=1;
        while ~strcmp(uin,'done') && safetycounter<20
            uin=input('Enter inds to exclude in form [start_ind end_ind]. ','s');
            safetycounter=safetycounter+1;
            excludeChunks{chunkNum}=(uin);
            chunkNum=chunkNum+1;
        end
    end
end

% Exclude these chunks from data
dontUseInds=[];
for i=1:length(excludeChunks)
    temp=excludeChunks{i};
    dontUseInds=[dontUseInds temp(1):temp(2)];
end
dontUse=zeros(1,size(data,1));
dontUse(dontUseInds)=1;
useInds=dontUse==0;
cut_data=data(useInds,:);
    
    
    
    