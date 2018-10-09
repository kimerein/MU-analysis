function [fracs,con_spiking,led_spiking]=getFractionSpikesSuppressed(x,x_led,y,y_led,inTimeWindow,useTheseUnits)

x=x(useTheseUnits==1,:);
x_led=x_led(useTheseUnits==1,:);
y=y(useTheseUnits==1,:);
y_led=y_led(useTheseUnits==1,:);

consensus_x=nanmean([x; x_led],1);

con_spiking=nanmean(y(:,consensus_x>=inTimeWindow(1) & consensus_x<=inTimeWindow(2)),2);
led_spiking=nanmean(y_led(:,consensus_x>=inTimeWindow(1) & consensus_x<=inTimeWindow(2)),2);

fracs=(con_spiking-led_spiking)./con_spiking;
