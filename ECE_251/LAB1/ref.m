%ECE 251A HW1
close all;
clear all;
clc;
syms z;
%   II Numerical
%   Part A:
no=4;                   %parameters given in problem
N=4*no;                 %This is the length of the FFT
h=[1 0 0 0 -0.5];       %time domain plot of given impulse response
% figure;
% subplot(2,2,1);
% stem(h);
% title('Figure 1: Plot of h[n]');
% xlabel('n');
% ylabel('h[n]');
% 
% H=0;                    %Here is the calculation of H(z)
% for n=0:length(h)-1
%     adder=h(1,n+1)*z^(-n);
%     H=adder+H;
% end
% 
% [n,d]=numden(H);        %Convert H(z) to fractional equation
% d=coeffs(d,'All');      %Find the coefficients of denominator and numerator
% n=coeffs(n,'All');
% n=double(n);
% d=double(d);
% subplot(2,2,2);               
% zplane(n,d);            %z-plane plot
% title('Figure 2: Plot of H(z)');



% NFFT=256;
% k=0:1:(NFFT-1)/2;       %take only positive frequency of one period
% w=2*pi/NFFT.*k;         %use radians/sample as the x-axis parameter
% h_aug=[h zeros(1,NFFT-length(h))]; %augment the signal to length of 256
% hk=fft(h_aug,NFFT);     %FFT process
% hk=hk(1:128);           %Keep the first half of H(k)
% 
% subplot(2,2,3);

% title('Figure 3: Linear amplitude of H(k) vs. w after augmentation');
% ylabel('Amplitude of H(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% subplot(2,2,4)          %Plot the phase 
% plot(w,angle(hk));
% title('Figure 4: Linear phase of H(k) vs. w after augmentation');
% ylabel('Phase of H(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
%   Part B:
%   Part (1)
% N=16;
% NFFT=256;
% %   This part is for H(k) where N=16
% k=0:1:N/2;          %Still need to use only positive frequency
% w=2*pi/N.*k;
% hk=fft(h,N);
% h1k_original=1./hk;     %Use the definition H1(k)=1/H(k)
% hk=hk(1:N/2+1);         %Keep H(k) with first half length
% 
% figure;  
% subplot(2,2,1);
% plot(w,abs(hk));        %Plot of amplitude of H(k)
% title('Figure 5: Linear amplitude of H(k) vs. w when N=16');
% ylabel('Amplitude of H(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% subplot(2,2,2);               
% plot(w,angle(hk));      %Plot of phase of H(k??
% title('Figure 6: Linear phase of H(k) vs. w when N=16');
% ylabel('Phase of H(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% %   This part is for H1(k) where N=16
% h1k=h1k_original(1:N/2+1);%Keep the first half length of H1(k??
% subplot(2,2,3);                
% plot(w,abs(h1k));       %Plot  of amplitude of H1(k??
% title('Figure 7: Linear amplitude of H1(k) vs. w when N=16');
% ylabel('Amplitude of H1(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% subplot(2,2,4);                 
% plot(w,angle(h1k));     %Plot of phase of H1(K)
% title('Figure 8: Linear phase of H1(k) vs. w when N=16');
% ylabel('Phase of H1(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% %   Part (2)
% %   Find h1[n] from H1(k), and plot h1[n]
% h1n=ifft(h1k_original,N);
% figure;
% subplot(2,2,1);
% stem(0:N-1,h1n);
% title('Figure 9: Plot of h1[n]');
% xlabel('n');
% ylabel('h1[n]');
% %   Find H1(z) from h1[n], and plot H1(z)
% H1z=0;
% for n=0:N-1
%     adder=h1n(1,n+1)*z^(-n);
%     H1z=adder+H1z;
% end
% 
% [n,d]=numden(H1z);
% d=coeffs(d,'All');
% n=coeffs(n,'All');
% n=double(n);
% d=double(d);
% subplot(2,2,2);
% zplane(n,d)
% title('Figure 10: Plot of H1(z)');
% % 
% %   Part (3)
% h1_aug=[h1n zeros(1,NFFT-length(h1n))]; %Augment length of h1[n] to 256
% h1k_aug=fft(h1_aug,length(h1_aug));     %FFT  process
% h1k_aug=h1k_aug(1:length(h1_aug)/2+1);    %Keep the first half of augmented H1(k)
% magnitude_h1k_aug=abs(h1k_aug);        
% phase_h1k_aug=angle(h1k_aug);
% 
% k=0:1:length(h1_aug)/2;         %Keep positive half length of frequency
% w=2*pi/length(h1_aug).*k;
% 
% subplot(2,2,3);                 
% plot(w,magnitude_h1k_aug);      %Plot of magnitude_H1(k)_augmented
% title('Figure 11: Linear amplitude of H1(k) after augmentation vs. w');
% ylabel('Amplitude of H1(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% subplot(2,2,4);                
% plot(w,phase_h1k_aug);          %Plot of phase_H1(k)_augmented
% title('Figure 12: Linear phase of H1(k) after augmentation vs. w');
% ylabel('Phase of H1(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% %   Part  (4)
% N_IV=2*N;               %double the length of FFT of H(k) and H1(k)
% k=0:1:N_IV/2;           %but still, keep the positive frequency range.
% w=2*pi/N_IV.*k;
% hk_IV=fft(h,N_IV);
% h1k_IV=fft(h1n,N_IV);
% h2k_IV=h1k_IV.*hk_IV;   %multiply h1k ang hk to get h2k
% h2n=ifft(h2k_IV,N_IV);  %inverse FFT to find h2[n]
% 
% %   Part (5)
% figure;
% subplot(2,2,1);
% stem(0:N_IV-1,h2n);
% title('Figure 13: h2[n] via IFFT');
% xlabel('n');
% ylabel('h2[n]');
% 
% h2n_tranc=h2n(1:N_IV/2+1);  %truncate unnecessary zeros of h2[n]
% H2z=0;                      %calculate for H2(z) after the truncation.
% for n=0:length(h2n_tranc)-1
%     adder=h2n_tranc(1,n+1)*z^(-n);
%     H2z=adder+H2z;
% end
% 
% [n,d]=numden(H2z);
% d=coeffs(d,'All');
% n=coeffs(n,'All');
% n=double(n);
% d=double(d);
% subplot(2,2,2);
% zplane(n,d);
% title('Figure 14: Plot of H2(z)');
% 
% %  Part  (6)
% h2_aug=[h2n zeros(1,NFFT-length(h2n))]; %augment zeros to h2[n] to 256 length
% h2k_aug=fft(h2_aug,length(h2_aug));     %FFT
% h2k_aug=h2k_aug(1:length(h2_aug)/2);    %keep the positive frequency range of H2(k)
% magnitude_h2k_aug=abs(h2k_aug);
% phase_h2k_aug=angle(h2k_aug);
% 
% k=0:1:(length(h2_aug)-1)/2;
% w=2*pi/length(h2_aug).*k;
% 
% subplot(2,2,3);                                 
% plot(w,magnitude_h2k_aug);          %Plot of magnitude_H2(k)_augmented
% title('Figure 15: Linear amplitude of H2(k) vs. w after augmentation ');
% ylabel('Amplitude of H2(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% subplot(2,2,4);               
% plot(w,phase_h2k_aug);               %Plot of phase_H2(k)_augmented
% title('Figure 16: Linear phase of H2(k) vs. w after augmentation');
% ylabel('Phase of H2(k)');
% xlabel('radians/sample');
% axis([0 pi -2 2]);
% 
% %   Part C:
%   Part (1)
N=64;
NFFT=256;
%   This part is for H(k) where N=64
k=0:1:N/2;              %Still need to use only positive frequency
w=2*pi/N.*k;
hk=fft(h,N);
h1k_original=1./hk;     %Use the definition H1(k)=1/H(k)
hk=hk(1:N/2+1);         %Keep H(k) with first half length

figure;                
subplot(2,2,1);         %Plot of amplitude of H(k)
plot(w,abs(hk));
title('Figure 17: Linear amplitude of H(k) vs. w when N=64');
ylabel('Amplitude of H(k)');
xlabel('radians/sample');
axis([0 pi -2 2]);

subplot(2,2,2);                
plot(w,angle(hk));      %Plot of phase of H(k??
title('Figure 18: Linear phase of H(k) vs. w when N=64');
ylabel('Phase of H(k)');
xlabel('radians/sample');
axis([0 pi -2 2]);

%   This part is for H1(k) where N=64
h1k=h1k_original(1:N/2+1);%Keep the first half length of H1(k??
subplot(2,2,3);                 
plot(w,abs(h1k));       %Plot  of amplitude of H1(k??
title('Figure 19: Linear amplitude of H1(k) vs. w when N=64');
ylabel('Amplitude of H1(k)');
xlabel('radians/sample');
axis([0 pi -2 2]);

subplot(2,2,4);              
plot(w,angle(h1k));     %Plot of phase of H1(K)
title('Figure 20: Linear phase of H1(k) vs. w when N=64');
ylabel('Phase of H1(k)');
xlabel('radians/sample');
axis([0 pi -2 2]);

%   Part (2)
%   Find h1[n] from H1(k), and plot h1[n]
h1n=ifft(h1k_original,N);
figure;
subplot(2,2,1);
stem(0:N-1,h1n);
title('Figure 21: Plot of h1[n]');
xlabel('n');
ylabel('h1[n]');
%   Find H1(z) from h1[n], and plot H1(z)
H1z=0;
for n=0:N-1
    adder=h1n(1,n+1)*z^(-n);
    H1z=adder+H1z;
end

[n,d]=numden(H1z);
d=coeffs(d,'All');
n=coeffs(n,'All');
n=double(n);
d=double(d);
subplot(2,2,2);
zplane(n,d);
title('Figure 22: Plot of H1(z)');

%   Part (3)
h1_aug=[h1n zeros(1,NFFT-length(h1n))]; %Augment length of h1[n] to 256
h1k_aug=fft(h1_aug,length(h1_aug));     %FFT  process
h1k_aug=h1k_aug(1:length(h1_aug)/2+1);    %Keep the first half of augmented H1(k)
magnitude_h1k_aug=abs(h1k_aug);        
phase_h1k_aug=angle(h1k_aug);

k=0:1:length(h1_aug)/2;             %Keep positive half length of frequency
w=2*pi/length(h1_aug).*k;

subplot(2,2,3);
plot(w,magnitude_h1k_aug);          %Plot of magnitude_H1(k)_augmented
title('Figure 23: Linear amplitude of H1(k) vs. w after augmentation');
ylabel('Amplitude of H1(k)');
xlabel('radians/sample');
axis([0 pi -2 2]);

subplot(2,2,4);                
plot(w,phase_h1k_aug);              %Plot of phase_H1(k)_augmented
title('Figure 24: Linear phase of H1(k) vs. w after augmentation');
ylabel('Phase of H1(k)');
xlabel('radians/sample');
axis([0 pi -2 2]);

%   Part  (4)
N_IV=2*N;               %double the length of FFT of H(k) and H1(k)
k=0:1:N_IV/2;       %but still, keep the positive frequency range.
w=2*pi/N_IV.*k;
hk_IV=fft(h,N_IV);
h1k_IV=fft(h1n,N_IV);
h2k_IV=h1k_IV.*hk_IV;   %multiply h1k ang hk to get h2k
h2n=ifft(h2k_IV,N_IV);  %inverse FFT to find h2[n]

%   Part (5)
figure;
subplot(2,2,1);
stem(0:N_IV-1,h2n);
title('Figure 25: h2[n] via IFFT');
xlabel('n');
ylabel('h2[n]');

h2n_tranc=h2n(1:N_IV/2+1);  %truncate unnecessary zeros of h2[n]
H2z=0;                      %calculate for H2(z) after the truncation.
for n=0:length(h2n_tranc)-1
    adder=h2n_tranc(1,n+1)*z^(-n);
    H2z=adder+H2z;
end

[n,d]=numden(H2z);
d=coeffs(d,'All');
n=coeffs(n,'All');
n=double(n);
d=double(d);
subplot(2,2,2);
zplane(n,d);
title('Figure 26: Plot of H2(z)');

%  Part  (6)
h2_aug=[h2n zeros(1,NFFT-length(h2n))]; %augment zeros to h2[n] to 256 length
h2k_aug=fft(h2_aug,length(h2_aug));     %FFT
h2k_aug=h2k_aug(1:length(h2_aug)/2+1);  %keep the positive frequency range of H2(k)
magnitude_h2k_aug=abs(h2k_aug);
phase_h2k_aug=angle(h2k_aug);

k=0:1:length(h2_aug)/2;
w=2*pi/length(h2_aug).*k;

subplot(2,2,3);           
plot(w,magnitude_h2k_aug);              %Plot of magnitude_H2(k)_augmented
title('Figure 27: Linear amplitude of H2(k) vs. w after augmentation');
ylabel('Amplitude of H2(k)');
xlabel('radians/sample');
axis([0 pi 0.999 1.001]);

subplot(2,2,4);                 
plot(w,phase_h2k_aug);                  %Plot of phase_H2(k)_augmented
title('Figure 28: Linear phase of H2(k) vs. w after augmentation');
ylabel('Phase of H2(k)');
xlabel('radians/sample');
axis([0 pi -0.001 0.001]);