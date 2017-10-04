% this code will extract the bit position from the pl2 file.
% version used for Rbp4 ChR2 rebound experiment
% Bitcode LFP with 8 positions.

D=dir;
filename={};
for i=3:length(D)
    
    filename{i-2}=D(i).name;
    if ~isempty(findstr(filename{i-2},'pl2'))
        FN=[cd '/' filename{i-2} ];
    end
end
pl2 = PL2GetFileIndex(FN);
PL2Print(pl2.EventChannels);

ShutterTs=PL2EventTs(FN,'EVT09');
ShutterTs=ShutterTs.Ts;

bit1=PL2EventTs(FN,'EVT01');
bit2=PL2EventTs(FN,'EVT02');
bit3=PL2EventTs(FN,'EVT03');
bit4=PL2EventTs(FN,'EVT04');

ShutterTs=cleanEvents(ShutterTs);
bit1.Ts=cleanEvents(bit1.Ts);
bit2.Ts=cleanEvents(bit2.Ts);
bit3.Ts=cleanEvents(bit3.Ts);
bit4.Ts=cleanEvents(bit4.Ts);

masterBit=[bit1.Ts' bit2.Ts' bit3.Ts' bit4.Ts'];
masterBit=sort(masterBit);

% Detect bit events
I=1;
Position=cell(20,1);
nth_pattern=0;
patternSequence=[];
while I<=(length(masterBit)-6)
    if length(unique(masterBit(I:I+3)'))==1
        nth_pattern=nth_pattern+1;
        Index=max(ismember(bit1.Ts,masterBit(I+4)))*1+max(ismember(bit2.Ts,masterBit(I+4)))*2+max(ismember(bit3.Ts,masterBit(I+4)))*4+max(ismember(bit4.Ts,masterBit(I+4)))*8;
        if Index>10
            I=I+1;
        end
        dum=ShutterTs(ShutterTs>masterBit(I+4));
        Position{Index} = [ Position{Index} dum(1)];
        patternSequence=[patternSequence Index];
        if ((I)<=length(masterBit)) && (~isempty(find((masterBit(I+4:I+7)'-masterBit(I+5:I+8 )')~=0,1)))
            I=I+4+find((masterBit(I+4:I+7)'-masterBit(I+5:I+8 )')~=0,1);
        else
            I=I+1;
        end
    else
        I=I+1;
    end
end

Position

