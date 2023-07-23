close all
clc

%-------------------------------------------------------------------------%

% Parameters 
ts = 0.01;
numSymbols = 5000;
numTrainingSymbols = 200;


%-------------------------------------------------------------------------%

% Modulation 

M = 2;  % BPSK
data = randi([0 1],numSymbols,1);
x = pskmod(data,M);

%-------------------------------------------------------------------------%

% Simple Examples 
% h = 1;
% h = [0.02+0.5i 0.05];

% % Ideal Example
% t_h = (0:ts:length(x)*ts)';
% h = exp(-0.2*t_h);
% h = h(1:2);

% Decreasing Exponential Example
t_h = (0:1:numSymbols)';
h = 0.5.^t_h;

% % Simple Example
% h = [1 0.5 0.25];

% % Complex Example
% h = cos(0:1:100);

y = conv(x,h);
% rxSig = awgn(rxSig,30)


%-------------------------------------------------------------------------%

% Equalization
% research more 

lineq = comm.LinearEqualizer( ...
    NumTaps=8, ...
    StepSize=0.1, ...
    Constellation=complex([-1 1]), ...
    ReferenceTap=4);

[z,err] = lineq(y,x(1:numTrainingSymbols)); 
%[z,err] = lineq(y,x); 

% dfeq = comm.DecisionFeedbackEqualizer('Algorithm','LMS','NumForwardTaps',4,'NumFeedbackTaps',3,'StepSize',0.01,'Constellation',complex([-1 1]));
% z = dfeq(y,x);

%-------------------------------------------------------------------------%

% Constellation Diagram 
% okay for now 


constdiag = comm.ConstellationDiagram( ...
    NumInputPorts=2, ...
    ChannelNames={'Before equalization','After equalization'}, ...
    ReferenceConstellation=pskmod([0 M-1],M));

%constdiag(y(numSymbols/2:end),z(numSymbols/2:end));
% constdiag(y(numTrainingSymbols:(numSymbols/2)),z(numTrainingSymbols:(numSymbols/2)));
constdiag(y,z);

%-------------------------------------------------------------------------%

% Continuous-Time Plotting
figure('Position', [100, 100, 800, 600]);


% plotting x_t
% there is one impulse for each 0.01 second

t_x = (0:ts:length(x)*ts)';   % time vector, traspose to match x
x_t = [x; x(end)];              % append vector to fix discontinuity 

subplot(2,1,1);
stairs(t_x,x_t);           
ylim([-5 5]); 
xlabel('Time');
ylabel('Amplitude');
title('Input Signal');




% plotting z_t (equalized signal)

t_z = (0:ts:length(z)*ts)'; 
z_t = [z; z(end)];

subplot(2,1,2);
stairs(t_z,z_t);           
ylim([-5 5]); 
xlabel('Time');
ylabel('Amplitude');
title('Input Signal');


%-------------------------------------------------------------------------%

% Plotting error

figure
plot(abs(err))
title('Error Estimate')
xlabel('Bits')
ylabel('Amplitude (V)')


%-------------------------------------------------------------------------%