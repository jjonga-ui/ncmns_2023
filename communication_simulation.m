close all
clc

%--------------------------------------------------------------------------


% Define time vector

ts = 0.01;                  % increment 1/100 second
total_duration = 10;        % for 10 seconds 
t = 0:ts:total_duration-ts;    


%--------------------------------------------------------------------------


% Define the input signal

% create trail of rectangular pulses
pulse_width = 0.1;      % width of each rectangular pulse
pulse_interval = 1;     % interval between pulse
for n = 0:pulse_interval:total_duration     
    x_t = x_t + rectpuls(t-n, pulse_width);
end


%--------------------------------------------------------------------------


% Define the channel impulse response

h_t = exp(-0.2*t); % e^-0.2 , e^-0.4 , ...

%h_t = cos(2*pi * t + pi/2);

%h_t = x_t;


%--------------------------------------------------------------------------


% Convolve the input with the channel impulse response
y_t = conv(x_t, h_t);

% create new time axis for output
t_output = 0:ts:total_duration*2-ts-ts;


%--------------------------------------------------------------------------


% Equalization: define inverse impulse response 
% https://www.mathworks.com/help/matlab/math/fourier-transforms.html 

h_f = fft(h_t);                             % to frequency domain  

h_f_inv = 1 ./ h_f;                         % inverse in frequency domain

h_t_inv = ifft(h_f_inv);                    % back to time domain 


% Convolve output with inverse impulse response
z_t = conv(y_t,h_t_inv);    % equalized signal  

z_t = z_t(1:1000);          % fix scaling 


%--------------------------------------------------------------------------


% Plot the signals
figure('Position', [100, 100, 800, 600]);

% x_t
subplot(5,1,1);
plot(t, x_t);
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
plot(t_output,y_t);
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
plot(t,z_t);
xlabel('Time');
ylabel('Amplitude');
title('Equalized Signal');


%--------------------------------------------------------------------------

% plot h_t * h_t_inv