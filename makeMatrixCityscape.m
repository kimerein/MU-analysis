function [new_xdata,new_ydata]=makeMatrixCityscape(xdata,ydata)

for i=1:size(ydata,1)
   [new_n,new_x]=cityscape_hist(ydata(i,:),xdata(i,:)); 
   if i==1
      new_xdata=nan(size(ydata,1),length(new_n));
      new_ydata=nan(size(xdata,1),length(new_x));
   end
   new_xdata(i,:)=new_x;
   new_ydata(i,:)=new_n;
end