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

                


















% EXTRA SCRAP CODE  

% %-------------------------------------------------------------------------%
% 
% M = 2; % BPSK
% % data = randi([0 1],1000,1);       % 0s and 1s 
% % modData = pskmod(data,M);         % 1s and -1s
% 
% modData = complex(ones(1000, 1), ones(1000, 1)); % column of complex 1s
% 
% %-------------------------------------------------------------------------%
% 
% ts = 0.01;                      % increment 1/100 second
% total_duration = 10;            % for 10 seconds 
% t = 0:ts:total_duration-ts;  
% 
% h_t = exp(-0.2*t);
% 
% %-------------------------------------------------------------------------%
% 
% % rxSig = conv(modData,[0.02+0.5i 0.05]);
% 
% rxSig = conv(modData,[0.02+0.5i 0.05]);   
% rxSig = awgn(rxSig,30);   % adding noise, not important 
% 
% %-------------------------------------------------------------------------%
% 
% lineq = comm.LinearEqualizer( ...
%     'Algorithm','CMA', ...
%     NumTaps=8, ...
%     StepSize=0.03, ...
%     Constellation=complex([-1 1]), ...
%     ReferenceTap=4);
% 
% %-------------------------------------------------------------------------%
% 
% trSeq = modData(1:200);
% [eqSig,err] = lineq(rxSig);
% 
% %-------------------------------------------------------------------------%
% 
% constdiag = comm.ConstellationDiagram( ...
%     NumInputPorts=2, ...
%     ChannelNames={'Before equalization','After equalization'}, ...
%     ReferenceConstellation=pskmod([0 M-1],M));
% constdiag(rxSig(400:end),eqSig(400:end))
% 
% %-------------------------------------------------------------------------%
% 
% % t_new = 1:length(eqSig);
% % figure
% % plot(t,eqSig);
% 
% %-------------------------------------------------------------------------%








% %--------------------------------------------------------------------------
% 
% 
% % Define time vector
% 
% ts = 0.01;                  % increment 1/100 second
% total_duration = 10;        % for 10 seconds 
% t = 0:ts:total_duration-ts;    
% 
% 
% %--------------------------------------------------------------------------
% 
% 
% % Define the input signal
% 
% x_t = zeros(size(t));       % initialize to vector of zeros 
% pulse_width = 0.5;          % width of each rectangular pulse
% pulse_interval = 1;         % interval between pulse
% 
% 
% % Example: 1 boxcar 
% % for n = 0:pulse_interval:0    
% %     x_t = x_t + rectpuls(t-n-(pulse_width/2), pulse_width);
% % end
% 
% 
% % Example: 2 boxcars
% % for n = 0:pulse_interval:1    
% %     x_t = x_t + rectpuls(t-n-(pulse_width/2), pulse_width);
% % end
% 
% 
% % Example: 10 boxcars 
% for n = 0:pulse_interval:total_duration     
%     x_t = x_t + rectpuls(t-n-(pulse_width/2), pulse_width);
% end
% 
% 
% %--------------------------------------------------------------------------
% 
% 
% % Define the channel impulse response
% 
% 
% % Example: decreasing exponential 
% % h_t = exp(-0.2*t); % e^-0.2 , e^-0.4 , ...
% 
% 
% % Example: cosine 
% % h_t = cos(2*pi * t + pi/2);
% 
% 
% % Example: boxcars
% h_t = x_t;
% 
% 
% %--------------------------------------------------------------------------
% 
% 
% % Convolve the input with the channel impulse response
% y_t = 0.01*conv(x_t, h_t);               % appropriately scale y-axis*
% 
% y_time = 0.01*(1:length(y_t));           % create new time vector
% 
% 
% 
% % *Note: y_t output is based on original x_t and h_t x-axis units
% %--------------------------------------------------------------------------
% 
% 
% % Equalization: define inverse impulse response 
% % https://www.mathworks.com/help/matlab/math/fourier-transforms.html 
% 
% h_f = fft(h_t);                             % to frequency domain  
% 
% h_f_inv = 1 ./ h_f;                         % inverse in frequency domain
% 
% h_t_inv = ifft(h_f);                    % back to time domain 
% 
% 
% % Convolve output with inverse impulse response
% z_t = 100*conv(y_t,h_t_inv);                % equalized signal  
% z_time = 0.01*(1:length(z_t));              % create new time vector
% 
% 
% 
% %--------------------------------------------------------------------------
% 
% 
% % Plot the signals
% figure('Position', [100, 100, 800, 600]);
% 
% % x_t
% subplot(5,1,1);
% plot(t,x_t);
% xlabel('Time');
% ylabel('Amplitude');
% title('Input Signal');
% 
% % h_t
% subplot(5,1,2);
% plot(t,h_t)
% xlabel('Time');
% ylabel('Amplitude');
% title('Channel Impulse Response');
% 
% % y_t
% subplot(5,1,3);
% plot(y_time,y_t);
% xlabel('Time');
% ylabel('Amplitude');
% title('Output Signal');
% 
% % h_t_inv
% subplot(5,1,4);
% plot(t,h_t_inv);
% xlabel('Time');
% ylabel('Amplitude');
% title('Channel Inverse Impulse Response');
% 
% % z_t (equalized signal)
% subplot(5,1,5);
% plot(z_time,z_t);
% xlabel('Time');
% ylabel('Amplitude');
% title('Equalized Signal');
% 
% 
% %--------------------------------------------------------------------------