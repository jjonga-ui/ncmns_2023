clc
clear all 
close all

%-------------------------------------------------------------------------%
% Input
M = 2;
data = randi([0 1],1000,1);
modData = pskmod(data,M);

t_m = 0:length(modData)-1;

figure(1)
subplot(3,1,1)
plot(t_m,modData);

% Impulse
% t_h = (0:0.01:length(modData)*0.01)';
% h = exp(-0.002*t_h);
% 
% subplot(3,1,2)
% plot(t_h,h);

h = [1 0.5 0.25];

% Output
y = conv(modData,h);
t_y = 0:length(y)-1;

subplot(3,1,3)
plot(t_y,y);

% Equalization
lineq = comm.LinearEqualizer(NumTaps=8, StepSize=0.1, Constellation=complex([-1 1]), ReferenceTap=4);

[eqSig,err] = lineq(y,modData(1:200));

constdiag = comm.ConstellationDiagram(NumInputPorts=2, ChannelNames={'Before equalization','After equalization'}, ReferenceConstellation=pskmod([0 M-1],M));
%constdiag(y(400:end),eqSig(400:end));
constdiag(y,eqSig);
%-------------------------------------------------------------------------%

% bpsk = comm.BPSKModulator;
% x = bpsk(randi([0 1],1000,1));
% rxSig = conv(x,[1 0.8 0.3]);
% t = 0:length(x)-1;
% figure(1)
% plot(t,x)
% 
% cT = 0:length(rxSig)-1;
% figure(2)
% plot(cT,rxSig)
% 
% M = 2;
% % data = randi([0 1],1000,1);
% % %modData = pskmod(data,M);
% % modData = [1 1 1 1 1 1 1];
% 
% 
% % rxSig = conv(modData,[0.02+0.5i 0.05]);
% % rxSig = awgn(rxSig,30);
% 
% lineq = comm.LinearEqualizer(NumTaps=8, StepSize=0.1, Constellation=complex([-1 1]), ReferenceTap=4);
% %equalizer = comm.LinearEqualizer('Algorithm', 'LMS', 'NumTaps', length(convolution));
% 
% %trSeq = modData(1:200);
% trSeq = x;
% [eqSig,err] = lineq(rxSig,trSeq);
% 
% constdiag = comm.ConstellationDiagram(NumInputPorts=2, ChannelNames={'Before equalization','After equalization'}, ReferenceConstellation=pskmod([0 M-1],M));
% constdiag(rxSig(400:end),eqSig(400:end))

