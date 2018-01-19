close all;
clear;
syms z;

% Part A Plot h[n]
h = [1, 0, 0, 0, -1/2];
R = 0 : 4;
tosave = figure;

subplot(2,2,1);
stem(R,h);
title('Figure 1, Plot of h[n]');
xlabel('n');
ylabel('h[n]');

% Plot H[Z]
subplot(2,2,2);
sum = 0;
for n = 0 : size(h,2) - 1
    sum = sum + h(1,n+1)* z^(-n);
end
% pretty(sum)
[n,d] = numden(sum);
z = double(coeffs(n,'All'));
p = double(coeffs(d,'All'));
zplane(z,p);
title('Figure 2, Plot of h(Z)');
xlabel('real part');
ylabel('imaginary part');

%N Plot DFT for H[k]
NFFT = 256;
k=0:1:(NFFT-1)/2;  %use only the positive frequency
w = 2 * pi/NFFT.*k;
h_k=fft(h,NFFT);
h_k = h_k(1:length(w));   
subplot(2,2,3);
plot(w,abs(h_k));        %amplitude
title('Figure 3, linear amplitude of H(k) vs. f');
ylabel('Amplitude of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);

subplot(2,2,4);
plot(w,angle(h_k));
title('Figure 4, linear phase of H(k) vs. f');
ylabel('Phase of H(k)');
xlabel('f(radian/sample)');
axis([0 pi -2 2]);
saveas(tosave, 'partA.jpg');





