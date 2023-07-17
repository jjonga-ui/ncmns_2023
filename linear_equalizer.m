close all
clc

%-------------------------------------------------------------------------%

% Parameters 
ts = 0.01;
numSymbols = 1000;
numTrainingSymbols = 200;


%-------------------------------------------------------------------------%

% Modulation 
M = 2;  % BPSK
data = randi([0 1],numSymbols,1);

% Input Signal 
x = pskmod(data,M);

% Decreasing Exponential Channel
t_h = (0:1:1000)';
h = 0.5.^t_h;

% Output Signal 
y = conv(x,h);


%-------------------------------------------------------------------------%

% Equalization

lineq = comm.LinearEqualizer( ...
    NumTaps=8, ...
    StepSize=0.1, ...
    Constellation=complex([-1 1]), ...
    ReferenceTap=4);

[z,err] = lineq(y,x(1:numTrainingSymbols)); % LMS


%-------------------------------------------------------------------------%

% Constellation Diagram 

constdiag = comm.ConstellationDiagram( ...
    NumInputPorts=2, ...
    ChannelNames={'Before equalization','After equalization'}, ...
    ReferenceConstellation=pskmod([0 M-1],M));

constdiag(y(numSymbols/2:end),z(numSymbols/2:end));


%-------------------------------------------------------------------------%

% Continuous-Time Plotting
figure('Position', [100, 100, 800, 600]);


% plotting x_t
% there is one impulse for each 0.01 second

t_x = (0:ts:length(x)*ts)';     % time vector, traspose to match x
x_t = [x; x(end)];              % append vector to fix discontinuity 

subplot(2,1,1);
stairs(t_x,x_t);           
ylim([-2 2]); 
xlabel('Time');
ylabel('Amplitude');
title('Input Signal');




% plotting z_t (equalized signal)

t_z = (0:ts:length(z)*ts)'; 
z_t = [z; z(end)];

subplot(2,1,2);
stairs(t_z,z_t);           
ylim([-2 2]); 
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