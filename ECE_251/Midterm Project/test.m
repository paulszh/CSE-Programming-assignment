%ECE 251A HW5
%Author: Yixiong Li
%Date: Feb 20th, 2017
close all;
clear all;
clc;

%% Part A:
N = 1024;
w1 = randn(1,N);        %Generate 1024 point Gaussian white noise
mu = 0; var = 1/32;
w2 = sqrt(var).*randn(1,N) + mu; %Build additive Gaussian noise with mean 0 and sigma 1/32.
L = 8;
hn = 1/L*ones(1,L);     %Construct h[n] = 1/8 for n = 0,1,...7.
NFFT = 128;             %All DFT use 128 samples.

figure;
subplot(2,2,1);         %The time domain signal h[n]
stem(0:L-1,hn);
title('Figure 1: The signal h[n]= 1/8 from n=0 to 7'); xlabel('n'); ylabel('h[n]');
subplot(2,2,2);         %The dB magnitude of H(k)
k = 0:NFFT-1;  
fk = 1/NFFT*k-0.5;
H = fftshift(fft(hn,NFFT));
plot(fk, 20*log10(abs(H)));
title('Figure 2: dB magnitude of H(k)'); xlabel('f cycles/sample'); ylabel('20log_1_0|H(k)| dB');
subplot(2,2,3);
plot(fk, abs(H));       %The linear magnitude of H(k)
title('Figure 3: linear magnitude of H(k)'); xlabel('f cycles/sample'); ylabel('|H(k)|');
subplot(2,2,4);
phase = angle(H);       %The phase of H(k) in radians.
plot(fk, phase);
title('Figure 4: Phase of H(k)'); xlabel('f cycles/sample'); ylabel('phase of H(k)(rad)');

%% Part B:
yn = filter(hn,1,w1);   %Process the input through h[n] and get y[n]/
rn = yn + w2;           %Add noise w2[n] to y[n] and get r[n].

M = 128;                %Construct a hamming window with length 128.
window = hamming(M);    %Use Hamming window as the window function.
U = 1/M*sum(window.^2);
% Overlap 50% (K=15)
K = 15;
SUM_W1 = 0;

for i = 1:15
    FFT_1 = fftshift(fft(w1(((i-1)*M/2+1):((i-1)*M/2+M)).*window',M));
    SUM_W1 = SUM_W1 +(abs(FFT_1)).^2;
end  
W1 = SUM_W1/K;
S_w1w1 = W1/M/U;       %Normalize the power spectral to get the density.
figure;
subplot(1,2,1);
k = 0:M-1;  
fk = 1/M*k-0.5;
plot(fk, 10*log10(abs(S_w1w1)));
title('Figure 5: dB magnitude power spectrum estimate S_w_1_w_1(f)'); xlabel('f cycles/sample'); ylabel('10log_1_0|S_w_1_w_1(f)| dB magnitude');
subplot(1,2,2);
plot(fk, abs(S_w1w1));
title('Figure 6: linear magnitude power spectrum estimate S_w_1_w_1(f)'); xlabel('f cycles/sample'); ylabel('|S_w_1_w_1(f)| linear magnitude');

noverlap = M/2;             %The overlap length is 64.
fs = 1;                     %Use default value fs = 1.
W2 = fftshift(pwelch(w2, window, noverlap, NFFT, fs, 'twosided'));
figure;
subplot(1,2,1);
plot(fk, 10*log10(abs(W2')));
title('Figure 7: dB magnitude power spectrum estimate S_w_2_w_2(f)'); xlabel('f cycles/sample'); ylabel('10log_10|S_w_2_w_2(f)| dB magnitude');
subplot(1,2,2);
plot(fk, abs(W2'));
title('Figure 8: linear magnitude power spectrum estimate S_w_2_w_2(f)'); xlabel('f cycles/sample'); ylabel('|S_w_2_w_2(f)| linear magnitude');

Y = fftshift(pwelch(yn, window,noverlap, NFFT, fs, 'twosided'));
figure;
subplot(1,2,1);
plot(fk, 10*log10(abs(Y')));
title('Figure 9: dB magnitude power spectrum estimate S_y_y(f)'); xlabel('f cycles/sample'); ylabel('10log_1_0|S_y_y(f)| dB magnitude');
subplot(1,2,2);
plot(fk, abs(Y'));
title('Figure 10: linear magnitude power spectrum estimate S_y_y(f)'); xlabel('f cycles/sample'); ylabel('|S_y_y(f)| linear magnitude');

R = fftshift(pwelch(rn, window,noverlap, NFFT, fs, 'twosided'));
figure;
subplot(1,2,1);
plot(fk, 10*log10(abs(R')));
title('Figure 11: dB magnitude power spectrum estimate S_r_r(f)'); xlabel('f cycles/sample'); ylabel('10log_1_0|S_r_r(f)| dB magnitude');
subplot(1,2,2);
plot(fk, abs(R'));
title('Figure 12: linear magnitude power spectrum estimate S_r_r(f)'); xlabel('f cycles/sample'); ylabel('|S_r_r(f)| linear magnitude');

%% Part C:
% Construct cross-power spectral estimates for Sy,w1 & Sr,w1 using function cpsd.
S_y_w1 = fftshift(cpsd(yn, w1, window, noverlap, NFFT, fs, 'twosided'));
figure;
subplot(3,2,1);
plot(fk, 10*log10(abs(S_y_w1)));
title('Figure 13: dB magnitude power spectrum estimate S_y_w_1(f)'); xlabel('f cycles/sample'); ylabel('10log_1_0|S_y_w_1(f)| dB magnitude');
subplot(3,2,2);
plot(fk, abs(S_y_w1));
title('Figure 14: linear magnitude power spectrum estimate S_y_w_1(f)'); xlabel('f cycles/sample'); ylabel('|S_y_w_1(f)| linear magnitude');
subplot(3,2,3);
phase = angle(S_y_w1);       %The phase of H(k) in radians.
plot(fk, phase);
title('Figure 15: Phase of S_y_w_1(f))'); xlabel('f cycles/sample'); ylabel('phase of S_y_w_1(f)(rad)');

S_r_w1 = fftshift(cpsd(rn, w1, window, noverlap, NFFT, fs, 'twosided'));
subplot(3,2,4);
plot(fk, 10*log10(abs(S_r_w1)));
title('Figure 16: dB magnitude power spectrum estimate S_r_w_1(f)'); xlabel('f cycles/sample'); ylabel('10log_1_0|S_r_w_1(f)| dB magnitude');
subplot(3,2,5);
plot(fk, abs(S_r_w1));
title('Figure 17: linear magnitude power spectrum estimate S_r_w_1(f)'); xlabel('f cycles/sample'); ylabel('|S_r_w_1(f)| linear magnitude');
subplot(3,2,6);
phase = angle(S_r_w1);       %The phase of H(k) in radians.
plot(fk, phase);
title('Figure 18: Phase of S_r_w_1(f))'); xlabel('f cycles/sample'); ylabel('phase of S_r_w_1(f)(rad)');

%% Part D:
% Compute the Transfer function estimates Hw1,y & Hw1,r
% For convenience, divide cross-power spectral estimates by auto-power spectral estimates directly.
H_w1_y = S_y_w1./S_w1w1';
figure;
subplot(3,2,1);
plot(fk, 10*log10(abs(H_w1_y)));
title('Figure 19: dB magnitude power spectrum estimate H_w_1_y(f)'); xlabel('f cycles/sample'); ylabel('10log_1_0|H_w_1_y(f)| dB magnitude');
line([fk(65) fk(65)],[-1.3+10*log10(abs(H_w1_y(65))) 1.1+10*log10(abs(H_w1_y(65)))]);
line([fk(89) fk(89)],[-1.3+10*log10(abs(H_w1_y(89))) 1.1+10*log10(abs(H_w1_y(89)))]);
line([fk(105) fk(105)],[-1.3+10*log10(abs(H_w1_y(105))) 1.1+10*log10(abs(H_w1_y(105)))]);
subplot(3,2,2);
plot(fk, abs(H_w1_y));
title('Figure 20: linear magnitude power spectrum estimate H_w_1_y(f)'); xlabel('f cycles/sample'); ylabel('|H_w_1_y(f)| linear magnitude');
subplot(3,2,3);
phase = angle(H_w1_y);       %The phase of H(k) in radians.
plot(fk, phase);
title('Figure 21: Phase of H_w_1_y(f))'); xlabel('f cycles/sample'); ylabel('phase of H_w_1_y(f)(rad)');
line([fk(65) fk(65)],[-8/180*pi+phase(65) 8/180*pi+phase(65)]);
line([fk(89) fk(89)],[-8/180*pi+phase(89) 8/180*pi+phase(89)]);
line([fk(105) fk(105)],[-8/180*pi+phase(105) 8/180*pi+phase(105)]);

H_w1_r = S_r_w1./S_w1w1';
subplot(3,2,4);
plot(fk, 10*log10(abs(H_w1_r)));
title('Figure 22: dB magnitude power spectrum estimate H_w_1_r(f)'); xlabel('f cycles/sample'); ylabel('10log_1_0|H_w_1_r(f)| dB magnitude');
line([fk(65) fk(65)],[-1.3+10*log10(abs(H_w1_r(65))) 1.1+10*log10(abs(H_w1_r(65)))]);
line([fk(89) fk(89)],[-3.5+10*log10(abs(H_w1_r(89))) 2.5+10*log10(abs(H_w1_r(89)))]);
line([fk(105) fk(105)],[-6+10*log10(abs(H_w1_r(105))) 3.5+10*log10(abs(H_w1_r(105)))]);
subplot(3,2,5);
plot(fk, abs(H_w1_r));
title('Figure 23: linear magnitude power spectrum estimate H_w_1_r(f)'); xlabel('f cycles/sample'); ylabel('|H_w_1_r(f)| linear magnitude');
subplot(3,2,6);
phase = angle(H_w1_r);       %The phase of H(k) in radians.
plot(fk, phase);
title('Figure 24: Phase of H_w_1_y(f))'); xlabel('f cycles/sample'); ylabel('phase of H_w_1_r(f)(rad)');
line([fk(65) fk(65)],[-8/180*pi+phase(65) 8/180*pi+phase(65)]);
line([fk(89) fk(89)],[-19/180*pi+phase(89) 19/180*pi+phase(89)]);
line([fk(105) fk(105)],[-30/180*pi+phase(105) 30/180*pi+phase(105)]);

%% Part E:
% Compute the Magnitude-squared coherence function estimates gamma_square_w1,y & gamma_square_w1,r.
% This part just plot linear magnitude.
gamma_square_w1_y = (abs(S_y_w1').^2)./(S_w1w1.*Y');
gamma_square_w1_r = (abs(S_r_w1').^2)./(S_w1w1.*R');
figure;
subplot(1,2,1);
plot(fk,abs(gamma_square_w1_y));
title('Figure 25: linear magnitude of gamma^2_w_1_y(f)'); xlabel('f cycles/sample'); ylabel('|gamma^2_w_1_y(f)| linear magnitude');
subplot(1,2,2);
plot(fk,abs(gamma_square_w1_r));
title('Figure 26: linear magnitude of gamma^2_w_1_r(f)'); xlabel('f cycles/sample'); ylabel('|gamma^2_w_1_r(f)| linear magnitude');