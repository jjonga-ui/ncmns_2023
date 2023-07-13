close all
clc

%-------------------------------------------------------------------------%

% Parameters 
ts = 0.01;
numSymbols = 100;
numTrainingSymbols = 20;


%-------------------------------------------------------------------------%

% Modulation 

bpsk = comm.BPSKModulator;

x = bpsk(randi([0 1],numSymbols,1));

t_h = (0:ts:length(x)*ts)';
h = exp(-0.2*t_h);

y = conv(x,h);


%-------------------------------------------------------------------------%


% Equalization
% research more 

lineq = comm.LinearEqualizer( ...
    'Algorithm','LMS', ...
    NumTaps=5, ...
    StepSize=0.0001, ...
    Constellation=complex([-1 1]), ...
    ReferenceTap=3);

z = lineq(y,x(1:numTrainingSymbols)); 


%-------------------------------------------------------------------------%

% Constellation Diagram 
% okay for now 


constdiag = comm.ConstellationDiagram( ...
    NumInputPorts=2, ...
    ChannelNames={'Before equalization','After equalization'}, ...
    ReferenceConstellation=bpsk([0; 1]));

constdiag(y,z)


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