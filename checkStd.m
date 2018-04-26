function checkStd(dataforsort,n)

temp=dataforsort{1};
figure();
plot(temp(1:1000000,1),'Color','k');
hold on;
line([1 1000000],[mean(temp(1:1000000,1))-n*std(temp(1:1000000,1)) mean(temp(1:1000000,1))-n*std(temp(1:1000000,1))],'Color','r');
line([1 1000000],[mean(temp(1:1000000,1))+n*std(temp(1:1000000,1)) mean(temp(1:1000000,1))+n*std(temp(1:1000000,1))],'Color','r');