%ECE251AHW3
%Author: Yixiong Li(A12497306)
%Date: Jan 27th, 2017
close all;
clear all;
clc;
syms z;

%% Part A:
L=1024;
uniform = rand(1,L);
gaussian = randn(1,L);

%% Part IB:
%Plot the histogram of the two random number sequence in IA
figure;
subplot(1,2,1);
hist(uniform);
title('Histogram of uniform distributed sequence'); xlabel('random value');
subplot(1,2,2);
hist(gaussian);
title('Histogram of Gaussian distributed sequence'); xlabel('random value');

figure;
subplot(1,2,1);
histogram(uniform);
title('Histogram of uniform distributed sequence'); xlabel('random value');
subplot(1,2,2);
histogram(gaussian);
title('Histogram of Gaussian distributed sequence'); xlabel('random value');
%% Part IC:
%Autocorrelation of the uniform distribution
N=256;
Cxx = xcorr(uniform(1:256), 'bias');
figure;
subplot(1,2,1);
stem(0:15, Cxx(N:N+15));
title('autocorrelation sequence estimate for uniform distribution'); xlabel('m'); ylabel('Cxx(m)');

%Autocorrelation of the Gaussian distribution
Cxx = xcorr(gaussian(1:256),'bias');
subplot(1,2,2);
stem(0:15,Cxx(N:N+15));
title('autocorrelation sequence estimate for Gaussiam distribution'); xlabel('m'); ylabel('Cxx(m)');
% ylim([-0.5 1.5]);

%% Part IIA:
% z-plane description of the FIR filter
l = 0:1:7;
h = ones(1,length(l));

H=0;
for l=0:length(l)-1
    adder=h(1,l+1)*z^(-l);
    H=adder+H;
end

[n,d]=numden(H);
d=coeffs(d,'All');
n=coeffs(n,'All');
n=double(n);
d=double(d);
figure;
zplane(n,d);
title('FIR filter z-domain plot');

% Augmentation of the h[n] sequence to length of 256
NFFT = 256;
h = [h zeros(1, NFFT-length(h))];
Hk = fftshift(fft(h, NFFT));
k = 0:1:NFFT-1;
f = 1/NFFT*k-0.5;
figure;
plot(f, 20*log10(abs(Hk)));
title('dB magnitude response H(k) vs. f'); xlabel('cycles/sample'); ylabel('dB magnitude');

%% Part IIB:
%Pass the uncorrelated Gaussian random sequence through the filter
input = gaussian;
input = input(1:NFFT);
output = filter(input,1,h);

k = 0:1:NFFT-1;
figure;
subplot(1,2,1);
plot(k, input);
title('256-point of input sequence'); xlabel('n');
subplot(1,2,2);
plot(k, output);
title('256-point of output sequence'); xlabel('n');

% Plot of the autocorrelation sequence of the filter's output.
Cyy = xcorr(output, 'bias');
figure;
subplot(1,2,1);
stem(0:15, Cyy(N:N+15));
title('Autocorrelation sequence of the filter output'); xlabel('m');

% plot the cross-correlation sequence between the input and output.
Cxy = xcorr(output, input, 'bias');
subplot(1,2,2);
stem(-15:15, Cxy(N-15:N+15));
title('Cross-correlation sequence between input and output'); xlabel('m');