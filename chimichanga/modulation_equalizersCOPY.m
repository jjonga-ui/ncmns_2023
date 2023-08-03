close all
clc

%-------------------------------------------------------------------------%


% Parameters 
ts = 0.01;
numSymbols = 1000;
numTrainingSymbols = 200;
channel_run_name = "ht&r_70";


%-------------------------------------------------------------------------%


% Modulation 
M = 2;  % BPSK
data = randi([0 1],numSymbols,1);

% Input Signal 
x = pskmod(data,M);

% Simple Plot of BPSK Signal 
% s = stem(x,'filled');
% title('C_n BPSK signal')


%-------------------------------------------------------------------------%

% The output x is the m_t message signal after the BPSK modulation 
% (c_n graph). This portion turns this into a passband signal by convolving
% with the cosine carrier wave.

% figure('Position',[700 700 1200,1200])
% subplot(3,1,1)
% s = stem(x,'filled');
% title('C_n BPSK signal')
% amp = 1;
% t = 1;
% subplot(3,1,2)
% carrierWave = amp.*cos(2*pi*1*t);
% title('Cosine Carrier Wave')
% pbSignal = conv(x,carrierWave);
% subplot(3,1,3)
% plot(x, real(x), 'b', x, imag(x), 'r')
% plot(pbSignal, real(pbSignal), 'b', pbSignal, imag(pbSignal), 'r')
% title('Passband Signal')


%-------------------------------------------------------------------------%


% Importing Channel Data
file_path = "chimichanga/results/" + channel_run_name + "/channel_data";
channel_data = importdata(file_path);

% Channel Model
h = channel_data.hmat(:,1);


%-------------------------------------------------------------------------%


% Output Signal 
y = conv(x,h);


%-------------------------------------------------------------------------%

% Equalization 


% Linear Equalizer 
LE = comm.LinearEqualizer( ...
    'NumTaps',8, ...
    'StepSize',0.1, ...
    'Constellation',complex([-1 1]), ...
    'ReferenceTap',4);

[zLE,errLE] = LE(y,x(1:numTrainingSymbols)); % LMS



% Decision Feedback Equalizer 
% https://www.mathworks.com/help/comm/ref/comm.decisionfeedbackequalizer-system-object.html#mw_ee65a6e9-38d3-4fea-b902-ba1250b24985
DFE = comm.DecisionFeedbackEqualizer( ...
    'Algorithm','LMS', ...
    'NumForwardTaps',4, ...
    'NumFeedbackTaps',3, ...
    'StepSize',0.1, ...
    'Constellation',complex([-1 1]));

[zDFE,errDFE] = DFE(y,x(1:numTrainingSymbols));


%-------------------------------------------------------------------------%

% Constellation Diagrams


% Linear Equalizer 

constdiag_LE = comm.ConstellationDiagram( ...
    'NumInputPorts',2, ...
    'ChannelNames',{'Before equalization','After equalization'}, ...
    'ReferenceConstellation',pskmod([0 M-1],M));

constdiag_LE.Position = [150, 200, 600, 600];
constdiag_LE(y(numTrainingSymbols:numSymbols/2),zLE(numTrainingSymbols:numSymbols/2));
% Only half the data points of y and z are plotted (minus the training
% symbols)



% Decision Feedback Equalizer 

constdiag_DFE = comm.ConstellationDiagram( ...
    'NumInputPorts',2, ...
    'ChannelNames',{'Before equalization','After equalization'}, ...
    'ReferenceConstellation',pskmod([0 M-1],M));

constdiag_DFE.Position = [750, 200, 600, 600];
constdiag_DFE(y(numTrainingSymbols:numSymbols/2),zDFE(numTrainingSymbols:numSymbols/2));
% Only half the data points of y and z are plotted (minus the training
% symbols)


%-------------------------------------------------------------------------%


% Continuous Time Plotting 

figure('Position', [100, 100, 1200, 650]);
% plotting x_t
% there is one impulse for each 0.01 second
t_x = (0:ts:length(x)*ts)';     % time vector, traspose to match x
x_t = [x; x(end)];              % append vector to fix discontinuity 



% Linear Equalizer 

subplot(2,2,1);
stairs(t_x,x_t);           
ylim([-2 2]); 
xlabel('Time');
ylabel('Amplitude');
title('Input Signal');

% plotting z_t (equalized signal)

t_zLE = (0:ts:length(zLE)*ts)'; 
zLE_t = [zLE; zLE(end)];

subplot(2,2,3);
stairs(t_zLE,zLE_t);           
ylim([-2 2]); 
xlabel('Time');
ylabel('Amplitude');
title('LE Equalized Signal');



% Decision Feedback Equalizer

subplot(2,2,2);
stairs(t_x,x_t);           
ylim([-2 2]); 
xlabel('Time');
ylabel('Amplitude');
title('Input Signal');

% plotting z_t (equalized signal)

t_zDFE = (0:ts:length(zDFE)*ts)'; 
zDFE_t = [zDFE; zDFE(end)];

subplot(2,2,4);
stairs(t_zDFE,zDFE_t);           
ylim([-2 2]); 
xlabel('Time');
ylabel('Amplitude');
title('DFE Equalized Signal');


%-------------------------------------------------------------------------%

% Plotting Error 

figure('Position', [300, 300, 900, 350]);


% Linear Equalizer
subplot(1,2,1);
plot(abs(errLE))
title('LE Error Estimate')
xlabel('Bits')
ylabel('Amplitude (V)')


% Decision Feedback Equalizer 
subplot(1,2,2);
plot(abs(errDFE))
title('DFE Error Estimate')
xlabel('Bits')
ylabel('Amplitude (V)')


%--------------------------------------------------------------------------

% save figures and data to personal files 

% choose your own path to a results folder
results_folder = "/Users/graceflores/Documents/MATLAB/ncmns_git/chimichanga/results/";

% folder of specific channel run 
folder_path = results_folder + channel_run_name;

% save figures 
save_figure(figure(1), "continuous_time_plotting", folder_path)
save_figure(figure(2), "error_estimate", folder_path)


