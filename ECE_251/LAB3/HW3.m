close all;
clear;
syms z;
%% Part A
uniform = rand(1, 1024);
gaussian = randn(1, 1024);

% plot the historgram: 
tosave = figure;
subplot(2,2,1);
hist(uniform);
title('Figure 1: hitogram of uniform distribution')
subplot(2,2,2);
hist(gaussian);
title('Figure 2: hitogram of gaussian distribution')

N = 256;
m = 16;

cxx_uniform = xcorr(uniform(1:N),'bias');
subplot(2,2,3);
stem(0:m-1, cxx_uniform(N:N+15));
title('Uniform: autocorrelation sequence estimation')
xlabel('m');
ylabel('Cxx(m)');

subplot(2,2,4);
cxx_gaussian = xcorr(gaussian(1:N),'bias');
stem(0:m-1, cxx_gaussian(N:N+15));
title('Gaussian: autocorrelation sequence estimation')
xlabel('m');
ylabel('Cxx(m)');
saveas(tosave, 'Figure1_2_3_4.jpg');


%% Part B
len = 8;
% n = 0 : len - 1;
h = ones(1, len);

sum = 0;
for x = 0: len-1 
    acc= h(1,x+1)*z^(-x);
    sum = acc + sum;
end

[n,d] = numden(sum);
z = double(coeffs(n,'All'));
p = double(coeffs(d,'All'));
tosave = figure;
zplane(z,p);
title('Figure 5, zplane plot FIR');
xlabel('real part');
ylabel('imaginary part');
saveas(tosave, 'figure5.jpg');

NFFT = 256;
Hk = fftshift(fft(h, NFFT));
k = 0:NFFT-1;
tosave = figure;
plot(1/NFFT*k-0.5, 20*log10(abs(Hk)));
title('Figure 6: magnitude (dB) response of H(k) vs. f'); 
xlabel('cycles/sample'); 
ylabel('magnitude(dB)');
saveas(tosave, 'figure6.jpg');

input = gaussian(1:NFFT);
output = filter(input, 1, [h zeros(1, NFFT-length(h))]);

tosave = figure;
subplot(2,2,1);
plot(k, input);
title('Figure 7: 256 point example of input sequence'); 
xlabel('n');
% axis([0 255 -3 3]);
subplot(2,2,2);
plot(k, output);
title('Figure 8: 256 point example of output sequence'); 
xlabel('n');
% axis([0 255 -8 8]);


cyy = xcorr(output,'bias');
subplot(2,2,3);
stem(0:m-1, cyy(N:N+15));
title('Figure 9: Input: autocorrelation sequence estimation'); 
xlabel('m');
ylabel('Cyy(m)');

subplot(2,2,4);
cxy = xcorr(input, output, 'bias');
stem(-m+1: m-1, cxy(N-15:N+15));
title('Figure 10: Output: autocorrelation sequence estimation');
xlabel('m');
ylabel('Cxy(m)');
saveas(tosave, 'figure7_8_9_10.jpg');

