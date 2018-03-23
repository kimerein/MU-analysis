function data=filterWBtoMU(data, Fs)

Fp=400; % Passband frequency in Hz
Fst=300; % Stopband frequency in Hz
Ap=1; % Passband ripple in dB
Ast=95; % Stopband attenuation in dB

% Design the filter
df=designfilt('highpassfir',...
              'PassbandFrequency',Fp,...
              'StopbandFrequency',Fst,...
              'PassbandRipple',Ap,...
              'StopbandAttenuation',Ast,...
              'SampleRate',Fs);

% Filter the data and compensate for delay
D=mean(grpdelay(df)); % filter delay
data=filter(df,[data; zeros(D,1)]);
data=data(D+1:end);