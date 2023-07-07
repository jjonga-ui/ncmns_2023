close all
clc

%--------------------------------------------------------------------------


% Define time vector

ts = 0.01;                  % increment 1/100 second
total_duration = 10;        % for 10 seconds 
t = 0:ts:total_duration-ts;    


%--------------------------------------------------------------------------


% Define the input signal

x_t = zeros(size(t));       % initialize to vector of zeros 
pulse_width = 0.5;          % width of each rectangular pulse
pulse_interval = 1;         % interval between pulse


% Example: 1 boxcar 
% for n = 0:pulse_interval:0    
%     x_t = x_t + rectpuls(t-n-(pulse_width/2), pulse_width);
% end


% Example: 2 boxcars
% for n = 0:pulse_interval:1    
%     x_t = x_t + rectpuls(t-n-(pulse_width/2), pulse_width);
% end


% Example: 10 boxcars 
% for n = 0:pulse_interval:total_duration     
%     x_t = x_t + rectpuls(t-n-(pulse_width/2), pulse_width);
% end


%--------------------------------------------------------------------------


% Define the channel impulse response


% Example: decreasing exponential 
h_t = exp(-0.2*t); % e^-0.2 , e^-0.4 , ...


% Example: cosine 
% h_t = cos(2*pi * t + pi/2);


% Example: boxcars
% h_t = x_t;


%--------------------------------------------------------------------------


% Convolve the input with the channel impulse response
y_t = 0.01*conv(x_t, h_t);               % appropriately scale y-axis*

y_time = 0.01*(1:length(y_t));           % create new time vector



% *Note: y_t output is based on original x_t and h_t x-axis units
%--------------------------------------------------------------------------


% Equalization: define inverse impulse response 
% https://www.mathworks.com/help/matlab/math/fourier-transforms.html 

h_f = fft(h_t);                             % to frequency domain  

% h_f_inv = 1 ./ h_f;                         % inverse in frequency domain

h_t_inv = ifft(h_f_inv);                    % back to time domain 


% Convolve output with inverse impulse response
z_t = 100*conv(y_t,h_t_inv);                % equalized signal  
z_time = 0.01*(1:length(z_t));              % create new time vector



%--------------------------------------------------------------------------


% Plot the signals
figure('Position', [100, 100, 800, 600]);

% x_t
subplot(5,1,1);
plot(t,x_t);
xlabel('Time');
ylabel('Amplitude');
title('Input Signal');

% h_t
subplot(5,1,2);
plot(t,h_t)
xlabel('Time');
ylabel('Amplitude');
title('Channel Impulse Response');

% y_t
subplot(5,1,3);
plot(y_time,y_t);
xlabel('Time');
ylabel('Amplitude');
title('Output Signal');

% h_t_inv
subplot(5,1,4);
plot(t,h_t_inv);
xlabel('Time');
ylabel('Amplitude');
title('Channel Inverse Impulse Response');

% z_t (equalized signal)
subplot(5,1,5);
plot(z_time,z_t);
xlabel('Time');
ylabel('Amplitude');
title('Equalized Signal');


%--------------------------------------------------------------------------
