clc
clear all 
close all


bpsk = comm.BPSKModulator;
x = bpsk(randi([0 1],1000,1));
rxSig = conv(x,[1 0.8 0.3]);

M = 2;
% data = randi([0 1],1000,1);
% %modData = pskmod(data,M);
% modData = [1 1 1 1 1 1 1];

%-------------------------------------------------------------------------%
% t = -20:0.01:20;    %Adjusted increment to 0.01
% u = heaviside(t+5.5);
% 
% % Making an array of shifts
% countA = 1;
% uNum = [];
% iNum = 5.5;
% while (countA < 20)
%     if (mod(countA,2) == 1)
%         iNum = iNum - 0.5;
%     else
%         iNum = iNum - 1;
%     end
%     uNum(countA) = iNum;
%     countA = countA + 1;
% end
% 
% % 10 Cycles of unit step in one variable
% count = 0;
% for T = uNum
%     if (mod(count,2) == 0)
%         u = u - heaviside(t+T);
%     else
%         u = u + heaviside(t+T);
%     end
%     count = count + 1;
% end
%-------------------------------------------------------------------------%

% rxSig = conv(modData,[0.02+0.5i 0.05]);
% rxSig = awgn(rxSig,30);

lineq = comm.LinearEqualizer(NumTaps=8, StepSize=0.1, Constellation=complex([-1 1]), ReferenceTap=4);

%trSeq = modData(1:200);
trSeq = x;
[eqSig,err] = lineq(rxSig,trSeq);

constdiag = comm.ConstellationDiagram(NumInputPorts=2, ChannelNames={'Before equalization','After equalization'}, ReferenceConstellation=pskmod([0 M-1],M));
constdiag(rxSig(400:end),eqSig(400:end))

