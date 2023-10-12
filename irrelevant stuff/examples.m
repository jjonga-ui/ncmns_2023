M = 2;
data = randi([0 1],1000,1);
modData = pskmod(data,M);

% [0.02+0.5i 0.05]

rxSig = conv(modData,1);
% rxSig = awgn(rxSig,30);

lineq = comm.LinearEqualizer( ...
    NumTaps=8, ...
    StepSize=0.1, ...
    Constellation=complex([-1 1]), ...
    ReferenceTap=4);



trSeq = modData(1:200);
[eqSig,err] = lineq(rxSig,trSeq);

constdiag = comm.ConstellationDiagram( ...
    NumInputPorts=2, ...
    ChannelNames={'Before equalization','After equalization'}, ...
    ReferenceConstellation=pskmod([0 M-1],M));
constdiag(rxSig(400:end),eqSig(400:end))

figure
plot(abs(err))
title('Error Estimate')
xlabel('Bits')
ylabel('Amplitude (V)')