%ECE251AHW4
%Author: Yixiong Li(A12497306)
%Date: 2nd Feb, 2017
close all; clear all; clc;

%% Part A:
N = 1024;                 % Generate 1024 time series
n = 0:1:(N-1);
var = 1;                  % Given that Gaussian variance is 1
f = 0.25;                % The cycles/sample is 0.125 given
signal = sqrt(2)*sin(2*pi*f*n); %Get 1024 points for signal
gaussian_white_noise = randn(1,N);  %Generate 1024 Gaussian random samples
series = signal + gaussian_white_noise; %Add the signal and noise
% N = 128 for time domain plot:
N = 128;
figure;
plot(0:(N-1), series(1:N));   %Extract only 128 points from the time series
title('Time series for N = 128');
xlabel('n');
ylabel('Signal magnitude');

%% Part B:
NFFT = [128 256 512 1024];
N = NFFT;
figure;
for i=1:4
window = hamming(NFFT(i));
new_signal = series(1:NFFT(i)).*window';
Sk = fftshift(fft(new_signal, NFFT(i)));
Power_Sk = 1./sum(window.^2)*(abs(Sk).^2);
k = -N(i)/2:1:(N(i)/2-1);
fk = k*(1/N(i));
subplot(2,2,i);
plot(fk, 10*log10(abs(Power_Sk)));
title(['FFT of normalized power spectrum estimate @ N =' num2str(NFFT(i))]);
xlabel('f');
ylabel('dB magnitude of S(k)');
end

%% Part C:
N = 1024;
M = 128;
window = hamming(M);
U = 1/M*sum(window.^2);
% 0% overlap of records(K=8)
K = 8;
SUM = 0;
for i = 1:K
FFT_S = fftshift(fft(series((M*i-M+1):(M*i)).*window',M));
ADDER = 1/(M*U)*(abs(FFT_S).^2);
SUM = SUM + ADDER;
end;
incoh_avg = SUM/K;
k = -M/2:1:(M/2-1);
fk = k*(1/M);

figure;
plot(fk, 10*log10(abs(incoh_avg)));
title('Power spectrum estimate for 0% overlap of records');
xlabel('f');
ylabel('dB magnitude');
% 50% overlap of records(K=15)
K = 15;
SUM = 0;
for i = 1:15
    FFT_S = fftshift(fft(series(((i-1)*M/2+1):((i-1)*M/2+M)).*window',M));
    ADDER = 1/(M*U)*(abs(FFT_S).^2);
    SUM = SUM + ADDER;
end
incoh_avg_2 = SUM/K;

figure;
plot(fk, 10*log10(abs(incoh_avg_2)));
title('Power spectrum estimate for 50% overlap of records');
xlabel('f');
ylabel('dB magnitude');

% 75% overlap of records(K=29)
K = 29;
SUM = 0;
for i = 1:29
    FFT_S = fftshift(fft(series(((i-1)*M*1/4+1):((i-1)*M*1/4+M)).*window',M));
    ADDER = 1/(M*U)*(abs(FFT_S).^2);
    SUM = SUM + ADDER;
end
incoh_avg_3 = SUM/K;

figure;
plot(fk, 10*log10(abs(incoh_avg_3)));
title('Power spectrum estimate for 75% overlap of records');
xlabel('f');
ylabel('dB magnitude');

%Comparison between B1 and C1, C1 and C2, C1 and C3
%B1 and C1
figure;
subplot(1,3,1);

window = hamming(M);
new_signal = series(1:M).*window';
Sk = fftshift(fft(new_signal, M));
Power_Sk = 1./sum(window.^2)*(abs(Sk).^2);
k = -M/2:1:(M/2-1); fk = k*(1/M);
plot(fk, 10*log10(abs(Power_Sk))); hold on;
plot(fk, 10*log10(abs(incoh_avg)),'--'); legend('B1','C1');
title('Comparison between B1 and C1');
xlabel('f'); ylabel('dB magnitude');

subplot(1,3,2);
plot(fk, 10*log10(abs(incoh_avg))); hold on;
plot(fk, 10*log10(abs(incoh_avg_2)),'--');
legend('C1','C2');
title('Comparison between C1 and C2');
xlabel('f'); ylabel('dB magnitude');

subplot(1,3,3);
plot(fk, 10*log10(abs(incoh_avg))); hold on;
plot(fk, 10*log10(abs(incoh_avg_3)),'--');
legend('C1','C3');
title('Comparison between C1 and C3');
xlabel('f'); ylabel('dB magnitude');
%% Part D:
mysum = 0;
COH_AVG = 0;
window = hamming(M);
for i = 1:8
    extract = series(((i-1)*M+1):(i*M));
    EXTRACT = fftshift(fft(extract.*window',M));
    mysum = mysum + extract;
    COH_AVG = COH_AVG + EXTRACT;
end
coh_avg_time = mysum/i;
COH_AVG = COH_AVG/i;
figure;
subplot(1,3,1); plot(0:M-1, coh_avg_time);
title('The time series of coherent average');
xlabel('n');
ylabel('coherent average');

subplot(1,3,2);
k = -M/2:1:(M/2-1); fk = k*(1/M);
COH_AVG = 1./sum(window.^2)*(abs(COH_AVG).^2);
plot(fk, 10*log10(abs(COH_AVG)));
title('The K-FFT of coherent average');
xlabel('f');
ylabel('dB magnitude');

subplot(1,3,3);
signal_spect = fftshift(fft(coh_avg_time.*window', M));
Power_spect = 1./sum(window.^2)*(abs(signal_spect).^2);
plot(fk, 10*log10(abs(Power_spect)));
title('The Power Spectrum of coherent average time series');
xlabel('f');
ylabel('dB magnitude');