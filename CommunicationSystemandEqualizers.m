clc
clear all 
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step_func = @(t) heaviside(t);
% repetitions = 10;
% t = -20:0.1:20;
% repeated_step = repmat(step_func(t), repetitions, 1);
% 
% % Transpose the repeated_step vector to match the dimensions of t
% repeated_step = repeated_step';
% 
% % Reshape the time vector to match the size of repeated_step
% t_repeated = repmat(t, repetitions, 1);

% subplot(2,2,1)
% plot(t_repeated(:), repeated_step(:))
% xlabel('Time(s)')
% title('10 Cycles of Unit Step')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% u(t+2.5) - u(t+2) + u(t+1) - u(t)
%u = heaviside(t+5.5) - heaviside(t+4) + heaviside(t+3);

%------------------------------------------------------------%

t = -20:0.01:20;    %Adjusted increment to 0.01
u = heaviside(t+5.5);

% Making an array of shifts
countA = 1;
uNum = [];
iNum = 5.5;
while (countA < 20)
    if (mod(countA,2) == 1)
        iNum = iNum - 0.5;
    else
        iNum = iNum - 1;
    end
    uNum(countA) = iNum;
    countA = countA + 1;
end

% 10 Cycles of unit step in one variable
count = 0;
for T = uNum
    if (mod(count,2) == 0)
        u = u - heaviside(t+T);
    else
        u = u + heaviside(t+T);
    end
    count = count + 1;
end

figure(1)
subplot(4,1,1)
plot(t, u)
xlabel('Time(s)')
title('10 Cycles of Unit Step')

%------------------------------------------------------------%

% Impulse Response
h_n = exp(-2*(0:0.01:1))';  %Adjusted increment to 0.01

%h_n = u;

subplot(4,1,2)
plot(h_n)
xlabel('Time(s)')
title('Impulse Response')


convolution = 0.1*conv(u,h_n, 'same'); %edited
convX = 0.1*(1:length(convolution));

% Adjusting time
%t_conv = linspace(t(1)+min(0:0.001:1), t(end)+max(0:0.001:1), length(convolution));

subplot(4,1,3)
plot(convX,convolution)
xlabel('Time(s)')
title('Output')

%------------------------------------------------------------%

% Frequence Response
channel_freq_response = fftshift(fft(h_n));

%one = ifft(h_n);

% Inverse of FR
channel_inverse = 1 ./ channel_freq_response;
%channel_inverse = ifft(channel_freq_response);
%channel_inverse = finverse(channel_freq_response);


% Putting back into time domain
ctime = ifft(channel_inverse);

% Linear Equalization
equalized_signal_linear = 0.1*conv(convolution, channel_inverse, 'same');
equalX = 0.1*(1:length(equalized_signal_linear));

subplot(4,1,4)
plot(equalX, equalized_signal_linear)
xlabel('Time(s)')
title('Linearly Equalized Output')


% figure(2)
% plot(channel_inverse);
%------------------------------------------------------------%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Equalizer
% equalizer = comm.LinearEqualizer('Algorithm', 'LMS', 'NumTaps', length(convolution));
% equalizedOutput = equalizer(convolution, repeated_step(:));
% 
% figure(4)
% stem(equalizedOutput)
% xlabel('Time(s)')
% title('Equalized Signal')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%













