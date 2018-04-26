function dataforsort=chopTops(dataforsort,n)

temp=dataforsort{1};

s=std(temp(1:10000000));
temp(temp>n*s)=n*s;
temp(temp<-n*s)=-n*s;

figure();
plot(temp(1:1000000,1),'Color','k');
hold on;
line([1 1000000],[n*s n*s],'Color','r');
line([1 1000000],[-n*s -n*s],'Color','r');

dataforsort{1}=temp;
