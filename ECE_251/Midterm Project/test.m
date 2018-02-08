%ECE 251A Midterm Project: Complex Basebanding
%Author: Yixiong Li (A12497306)
%Date: Feb 15th, 2017
close all;
clear all;
clc;

%%  I. Data Set
%   Part A:
L = 4096;                   % length of the sampling is 4096
A = [100 10 1];             
fl = [160 237 240];
fs = 1000;                  % Sampling rate is 1 KHz
n = 0:1:(L-1);              
x = 0;
for i = 1:3                 % Add all the three frequencies signal together
s = A(i)*cos(2*pi*fl(i).*n/fs);
x = x + s;
end                         % The x is the original sum of the signal

%   Part B:
N = 256;                    % Use the length of 256 for the signal.
xn = x(1,1:N);              % Extract the first 256 sample as x[n].
n = 0:1:(N-1);
figure;
stem(n,xn,'filled');
xlim([0,N-1]);
title('Figure 1: x[n] from 0 to 255');
xlabel('n');
ylabel('x[n] amplitude');

beta = 7.85;                 % Construct the KB window function
KBwindow = kaiser(N,beta)';  % alpha = beta/pi;
xn = xn.*KBwindow;           % Process the x[n] with length 256 through the KB window.

Xk = fftshift(fft(xn,N));    % Construct the 256 point FFT of that new x[n].
k=0:1:N-1;
f=1/N*k-0.5;
f = f*fs;                    % Use the frequency domain as the horizontal axis.
figure;
plot(f,20*log10(abs(Xk)),'linewidth',1.5);
title('Figure 2: dB magnitude of FFT |X(k)|');
xlabel('frequency f(Hz)');
ylabel('dB magnitude |X(k)|');

%%  II Decimation filter design
%   Part A:
fp = 40;
fst = 85;
n = 63;                       % Filter order
f = [0 2*fp/fs 2*fst/fs 1];   % Frequency band edges
a = [1  1   0  0];            % Desired amplitudes
w = [50 1];                   % Weight vector
hn = firpm(n,f,a,w);          % Generate the LPF in time domain
figure;                       % FIR filter in time domain with length of 64.
stem(0:n,hn,'filled');
title('Figure 3: equiripple FIR filter h[n]');
xlabel('n');
ylabel('h[n] amplitude');

%   Part B:
length_h = 1024;           % Use length of 256 for the rectangle window.
hn = [hn, zeros(1,length_h-length(hn))];% Pad the h[n] from length of 64 to 1024. 
Hk = fftshift(fft(hn, length_h));% Take 1024 FFT
k = -length_h/2:(length_h/2-1);
fk = 1/length_h.* k;
fk = fk*fs;
figure;
subplot(1,2,1);
plot(fk,20*log10(abs(Hk)),'linewidth',1.5);    % This is the dB magnitude plot for |Hk|.
xlim([-500 500]);
title('Figure 4: dB magnitude of |H(k)| with weighting ratio 50');
xlabel('frequency f(Hz)');
ylabel('dB magnitude |H(k)|');
subplot(1,2,2);
plot(fk,20*log10(abs(Hk)),'linewidth',1.5);    % This is the dB magnitude of |H(k)| for 0 to |40| Hz.
xlim([-fp fp]);
title('Figure 5: dB magnitude of |H(k)| from -40 to 40 Hz with weighting ratio 50');
xlabel('frequency f(Hz)');
ylabel('dB magnitude |H(k)|');
ylim([-0.01 0.01]);
%% III Complex Basebanding and Desampling
% Part A:
fo = 250;                                  % Set the center frequency for shift signal to 250 Hz. 
wo = 2*pi*fo/fs;
n = 0:L-1;
complex_mul = exp(-j.*n.*wo).*x;            % Multiply with length of 4096
complex_mul_extr = complex_mul(1:N).*KBwindow; % Extract first 256 sample from the complex multiplication sequence, then multiply by KB window.
COMPLEX_MUL_EXTR = fftshift(fft(complex_mul_extr,N)); % Take FFT.
figure;
k = 0:1:N-1;                              % Construct 256 point FFT of e^(-jwo*n)*x[n].
fk = 1/N.*k - 0.5;
fk = fk*fs;
plot(fk, 20*log10(abs(COMPLEX_MUL_EXTR)),'linewidth', 1.5);
title('Figure 6: dB magnitude of FFT of new complex sequence N=256');
xlabel('frequency f(Hz)');
ylabel('dB magnitude of |FFT|');

% Part B:
%filtered = filter(hn,1,complex_mul);        % pass the complex signal through filter
filtered = conv(complex_mul,hn(1:64),'same');
filtered_extr = filtered(N+1:2*N).*KBwindow;% pass the 256 samples from 257 to 512 through KB window;
FILTERED_EXTR = fftshift(fft(filtered_extr,N));% Take FFT
figure;
%subplot(1,2,1);
k = 0:1:N-1;                                % Take the 256 point FFT of the filtered e^(-jwo*n)*x[n]
fk = 1/N.*k - 0.5;
fk = fk*fs;
plot(fk, 20*log10(abs(FILTERED_EXTR)),'linewidth', 1.5);
title('Figure 7: dB magnitude of FFT of extracted complex sequence passed filter N=256');
xlabel('frequency f(Hz)');
ylabel('dB magnitude of |FFT|');
ylim([-60, 80]);
% 
% % Part C:
new_filtered = downsample(filtered,8);      %Downsampling the filtered complex sequence by 8, yiled x'[n].

%% IV High Resolution Spectral Analysis
% Part A:
new_filtered_extr = new_filtered(N+1:2*N).*KBwindow;    % Extract the point from 257 to 512 of the downsampled signal, and multiply by KB window.
NEW_FILTERED_EXTR = fftshift(fft(new_filtered_extr,N)); % Take 256 point FFT.
figure;
%subplot(1,2,2);
k = 0:1:N-1;                        % Plot the frequency response of the |X'(k)|.
fk = 1/N.*k-0.5;
fk = fk*fs/8;
plot(fk, 20*log10(abs(NEW_FILTERED_EXTR)),'linewidth', 1.5);
title('Figure 8: dB magnitude of FFT of downsampled extracted complex sequence passed filter N=256');
xlabel('frequency fk in Hz');
ylabel('dB magnitude of |FFT|');
xlim([-fs/8/2 fs/8/2]);
% Part B:
% Redo the procedure with LPF of lower weighting ratio

%%  II Decimation filter design
%   Part A:
fp = 40;
fst = 85;
n = 63;              % Filter order
f = [0 2*fp/fs 2*fst/fs 1];   % Frequency band edges
a = [1  1   0  0];   % Desired amplitudes
w = [1 200];          % Change the Weight vector be lower 
hn = firpm(n,f,a,w);
figure;             % FIR filter in time domain with length of 64.
stem(0:n,hn,'filled');
title('Figure 9: 2nd equiripple FIR filter h[n]');
xlabel('n');
ylabel('2nd h[n] amplitude');
%   Part B:
hn = [hn, zeros(1,length_h-length(hn))]; % Pad the 2nd h[n] from length of 64 to 1024. 
Hk = fftshift(fft(hn, length_h));
k = -length_h/2:(length_h/2-1);
fk = 1/length_h.* k;
fk = fk*fs;
figure;
subplot(1,2,1);
plot(fk,20*log10(abs(Hk)), 'linewidth', 1.5);     % This is the 2nd dB magnitude plot for |Hk|.
xlim([-500 500]);
title('Figure 10: dB magnitude of 2nd |H(k)| with weighting ratio 0.005');
xlabel('frequency fk in Hz');
ylabel('dB magnitude |H(k)|');
subplot(1,2,2);
plot(fk,20*log10(abs(Hk)), 'linewidth', 1.5);    % This is the 2nd |H(k)| for 0 to 40 Hz.
xlim([-fp fp]);
title('Figure 11: dB magnitude of 2nd |H(k)| from -40 to 40 Hz with weighting ratio 0.005');
xlabel('frequency fk in Hz');
ylabel('dB magnitude |H(k)|');

%% III Complex Basebanding and Desampling
% Part A:
fo = 250;
wo = 2*pi*fo/fs;
n = 0:L-1;
complex_mul = exp(-j.*n*wo).*x;            % Multiply with length of 4096
% Part B:
%filtered = conv(complex_mul, hn(1:64), 'same');
filtered = filter(hn,1,complex_mul);        % pass the complex signal through 2nd filter
% Part C:
new_filtered = downsample(filtered,8);      %Downsampling the 2nd filtered complex sequence

%% IV High Resolution Spectral Analysis
% Part A:
new_filtered_extr = new_filtered(N+1:2*N).*KBwindow;
NEW_FILTERED_EXTR = fftshift(fft(new_filtered_extr,N));
%figure;
figure;                                     % Plot the frequency response of the 2nd |X'(k)|.
k = 0:1:N-1;
fk = 1/N.*k-0.5;
fk = fk*fs/8;
plot(fk, 20*log10(abs(NEW_FILTERED_EXTR)), 'linewidth', 1.5);
title('Figure 12: 2nd dB magnitude of FFT of downsampled extracted complex sequence passed filter N=256');
xlabel('frequency fk in Hz');
ylabel('2nd dB magnitude of |FFT|');
xlim([-fs/8/2 fs/8/2]);