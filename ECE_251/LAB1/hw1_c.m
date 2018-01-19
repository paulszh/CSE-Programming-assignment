close all;
clear;
syms z;

% Part C
% (1)
N = 64;
tosave = figure;

subplot(2,2,1);
k = 0 : 1 : N/2;
h = [1, 0, 0, 0, -1/2];
w = 2 * pi/N .* k;
h_k = fft(h,N);
h1k = 1./h_k;


h_k = h_k(1:length(w));   
plot(w,abs(h_k));        %amplitude
title('Figure 17, linear amplitude of H(k) vs. f');
ylabel('Amplitude of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);

subplot(2,2,2);
plot(w,angle(h_k));        %phase 
title('Figure 18, linear phase of H(k) vs. f');
ylabel('Amplitude of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);

subplot(2,2,3);
h1k_pos = h1k(1:length(w)); 
plot(w,abs(h1k_pos));        %amplitude
title('Figure 19, linear amplitude of H1(k) vs. f');
ylabel('Amplitude of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);

subplot(2,2,4);
plot(w,angle(h1k_pos));        %phase
title('Figure 20, linear phase of H1(k) vs. f');
ylabel('Amplitude of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);

saveas(tosave, 'partc_1.jpg');

% (2)
tosave = figure;
subplot(2,2,1);
h1n = ifft(h1k,N); % calcuating the h1n using the inverse fft;
R = 0 : N - 1;
stem(R,h1n);       % Obtain h 1 (n) and plot h 1 (n) and the zero locations of H 1 (z).
title('Figure 21, Plot of h1[n]');
xlabel('n');
ylabel('h[n]');


% Plot H[Z]
subplot(2,2,2);
sum = 0;
for n = 0 : size(h1n,2) - 1
    sum = sum + h1n(1,n+1)* z^(-n);
end
% pretty(sum)
[n,d] = numden(sum);
ze = double(coeffs(n,'All'));
p = double(coeffs(d,'All'));
zplane(ze,p);
title('Figure 22, Plot of h1(Z)');
xlabel('real part');
ylabel('imaginary part');

% (3)Augment h1(n) with zeros out to NFFT = 256, FFT, 
% and plot linear magnitude and phase of H 1 (k) vs. f.
NFFT = 256;
k=0:1:(NFFT-1)/2;  %use only the positive frequency
w = 2 * pi/NFFT.*k;
h1kNFFT=fft(h1n,NFFT);
h1kNFFT = h1kNFFT(1:length(w));   
subplot(2,2,3);
plot(w,abs(h1kNFFT));        %amplitude
title('Figure 23, linear amplitude of H1(k) vs. f');
ylabel('Amplitude of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);

subplot(2,2,4);
plot(w,angle(h1kNFFT));
title('Figure 24, linear phase of H1(k) vs. f');
ylabel('Phase of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);
saveas(tosave, 'partC_2&3.jpg');

% (4) Obtain the linear convolution h 2 (n) = h(n) * h 1 (n) 
% via FFT (2N = 32 point result).
N = N * 2;
k=0:1:N/2;           % using only the positive frequency
w=2*pi/N.*k;
h2k = fft(h,N).* fft(h1n,N);   %multiply h1k ang hk(equivlent to convolve in space domain)
h2n=ifft(h2k ,N);       % convert back to space domiain

% (5) Plot h2(n) and zero locations of H 2 (z). Note: Trailing zeros in the 2N-point
% result for h2 (n) should be truncated prior to determining zero locations for
% H2(z).
tosave = figure;
subplot(2,2,1);
R = 0 : N - 1;
stem(R,h2n);       % Obtain h 1 (n) and plot h 1 (n) and the zero locations of H 1 (z).
title('Figure 25, Plot of h2[n]');
xlabel('n');
ylabel('h2[n]');

subplot(2,2,2);
h2n_trun = h2n(1:N/2 + 1);
sum = 0;
for n = 0 : size(h2n_trun,2) - 1
    sum = sum + h2n_trun(1,n+1)* z^(-n);
end
% pretty(sum)
[n,d] = numden(sum);
ze = double(coeffs(n,'All'));
p = double(coeffs(d,'All'));
zplane(ze,p);
title('Figure 26, Plot of h2(Z)');
xlabel('real part');
ylabel('imaginary part');

% (6) Augment h2n) with zeros out to NFFT = 256, FFT, and plot linear 
% magnitude and phase of H2(k) vs. f to see how well h1(n) has equalized 
% the channel.

h2kNFFT = fft(h2n,NFFT);
h2kNFFT_pos = h2kNFFT(1:NFFT/2);

k = 1 : NFFT/2;
w = 2 * pi/ NFFT * k;
subplot(2,2,3);
plot(w,abs(h2kNFFT_pos));        %amplitude
title('Figure 27, linear amplitude of H2(k) vs. f');
ylabel('Amplitude of H2(k)');
xlabel('f(radian/sample)');
axis([0 pi 0.998,1.002]);


subplot(2,2,4);
plot(w,angle(h2kNFFT_pos));
title('Figure 28, linear phase of H2(k) vs. f');
ylabel('Phase of H2(k)');
xlabel('f(radian/sample)');
axis([0 pi -0.002 0.002]);
saveas(tosave, 'partC_4&5.jpg');





