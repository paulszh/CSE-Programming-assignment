close all;
clear;
%% A. Implement the block diagram shown below (Figure 12.11a in [1]) and 
% demonstrate the successful generation of both upper and lower single 
%sideband signals.
f1 = 0.05;
f2 = 0.075;
f3 = 0.1;   
fc = 0.25;  % carrier frequency

r1 = f1 * 2 * pi;
r2 = f2 * 2 * pi;
r3 = f3 * 2 * pi;

n = 0 : 1023;
% R = 20Log10(A1/A2)
A1 = 10 * sqrt(10) ;    % power seperate by 10db 
A2 = 10;
A3 = sqrt(10);

x_r = A1 * sin(r1 * n) + A2 * sin(r2 * n) + A3 * sin(r3 * n);
tosave = figure;
stem(x_r);

axis([0,1023, -50, 50]);
title('figure 6, impulse response of low pass filter');
xlabel('n');
ylabel('xr[n]');
saveas(tosave, 'Figure1.jpg');
%% 64-point FIR Hilbert transformer
N = 64;
h = firpm(N-1,[0.1 0.9],[1 1],'hilbert');
tosave = figure;
subplot(2,2,1);
stem(h);
title('Figure 2, Impulse response of Hilbert Transformer filter')
ylabel('h[n]');
xlabel('n');
axis([0, 64, -0.7 0.7]);

NFFT = 256;
hk=fftshift(fft(h,NFFT));
k = 0:NFFT-1;
f=1/length(hk)*k - 0.5;
db = 20*log10(abs(hk));

subplot(2,2,2);
plot(f,db);                  %find the amplitude of H(k)
title('Figure 3: dB Magnitude of H(k) vs. f');
ylabel('amplitude of H(k)(db)');
xlabel('f(cycles/sample)');
               
subplot(2,2,3);
plot(f, angle(hk));                         %find the phase of H(k)
title('Figure 4: Phase of H(k) vs. f');
ylabel('phase of H(k)');
xlabel('f(cycles/sample)');

subplot(2,2,4);
plot(f, angle(hk));
axis([-0.01 0.01 -4 4]);
title('Figure 5: Blow up the phase plot: h(k) vs. f');
ylabel('phase of H(k)');
xlabel('f(cycles/sample)');
saveas(tosave, 'Figure2_3_4_5.jpg');
%% Part C
freq_band = [0, 0.2, 0.35, 1];
LPF = firpm(N-1, freq_band, [1 ,1, 0, 0]);
tosave = figure;
stem(LPF);
axis([0 64 -0.1 0.3])
title('figure 6, impulse response of low pass filter');
xlabel('n')
ylabel('low pass filter LPF(n)')
saveas(tosave, 'figure6.jpg');

%convert to frequency domain
lpf_freq = fftshift(fft(LPF, NFFT));
p = 0 : NFFT - 1;
freq = (1/length(lpf_freq) * p) - 0.5;
tosave = figure;
subplot(1,2,1);
plot(freq, 20 * log10(abs(lpf_freq)));
title('figure 7, amplitdue of Low pass filter');
xlabel('f(cycles/sample)');
ylabel('amplitude(db)');

subplot(1,2,2);
plot(freq, angle(lpf_freq));          
title('Figure 8: Phase of the low pass filter vs f');
ylabel('phase of the low pass filter');
xlabel('f(cycles/sample)');
saveas(tosave, 'Figure7_8.jpg');

%% lower path
x_in_origin = filter(h,1,x_r);
window = window('hamming', NFFT);
x_in = x_in_origin(NFFT+1 : 2 * NFFT).* window'; 
% tosave = figure;
% stem(x_in);
% ylabel('xi[n]')
% xlabel('n')
% axis([0, 256, -60, 60]);
% title('Figure 9, Plot of xi[n]')
% saveas(tosave, 'Figure9.jpg');

% Generating sin wc n
wc = fc * 2 * pi; %convert frequncy to radians per sample
sinwc = sin(wc * n);

% lower part signal
lower_original = x_in_origin.*sinwc;   %Multiply xi[n] with sin(wc*n);
lower  = lower_original(NFFT+1 : 2 * NFFT) .* window'; %use window for extracted signal
    
% upperpath signal flow:
% xr'[n] multiply with cos(wc*n)
xr_n_origin = filter(LPF,1,x_r);              %compute the xr'[n] signal
xr_n = xr_n_origin(NFFT+1:2*NFFT) .* window'; % extract the signal        
coswc = cos(wc*n);          

upper_original = xr_n_origin.* coswc;                %Multiply xr'[n] with cos(wc*n);
upper = upper_original(NFFT+1:2*NFFT).*window';     %extract the lower part

%Calculate the usb[n] and lsb[n]
usb_original = upper_original-lower_original;     %usb computation
usb = usb_original(NFFT+1:2*NFFT).*window';

lsb_original = upper_original+lower_original;     %usb computation
lsb = lsb_original(NFFT+1:2*NFFT).*window';

%x[n] and s[n]
x_origin = xr_n_origin+ 1i*x_in_origin;
x = x_origin(NFFT+1:2*NFFT).*window';

s_origin = x_origin.*exp(1i*wc*n);
s = s_origin(NFFT+1:2*NFFT).*window';

%% Part D: Start plotting
% x_r_[n]
x_r = x_r(NFFT+1:2*NFFT);
x_r = x_r.*window';
tosave = figure;
plot(f,20*log10(abs(fftshift(fft(x_r,NFFT)))));                    %find the amplitude of XR(k)
title('Figure 10: dB Magnitude of FFT xr(n) vs. f');
ylabel('amplitude of XR[k]');
xlabel('cycles/sample');
saveas(tosave, 'Figure10.jpg');

% xr[n],
XR_P = fftshift(fft(xr_n,NFFT));
tosave = figure;
plot(f,20*log10(abs(XR_P)));              %find the amplitude of XR_PRIME(k)
title('Figure 11: dB Magnitude of FFT xr_p_r_i_m_e(n) vs. f');
ylabel('amplitude of XR_Prime(k)');
xlabel('cycles/sample');
saveas(tosave, 'Figure11.jpg');

%xi[n]
k=0: NFFT - 1;
f=1/NFFT*k-0.5;
tosave = figure;
plot(f,20*log10(abs(fftshift(fft(x_in,NFFT)))));                    %find the amplitude of XR(k)
title('Figure 12: dB Magnitude of FFT xi[n] vs. f');
ylabel('amplitude of XI[k]');
xlabel('cycles/sample');
saveas(tosave, 'Figure12.jpg');

%xr'(n) * cos(2*pi*fcn)
tosave = figure;
upper_FFT = fftshift(fft(upper,NFFT));
subplot(2,2,1);
plot(f,20*log10(abs(upper_FFT)));         
title('Figure 13: dB Magnitude of FFT xr_p_r_i_m_e[n]*cos(wc*n) vs. f');
ylabel('Amplitude of FFT xr_p_r_i_m_e(n)*cos(wc*n)');
xlabel('f(cycles/sample)');

% xi(n) * sin (2 * pi * fc * n)
lower_FFT = fftshift(fft(lower,NFFT));
subplot(2,2,2);
plot(f,20*log10(abs(lower_FFT)));          
title('Figure 14: dB Magnitude of FFT xi(n)*sin(wc*n)) vs. f');
ylabel('amplitude of FFT xi(n)*sin(wc*n))');
xlabel('f(cycles/sample)');

%sr(n) usb
USB = fftshift(fft(usb,NFFT));
subplot(2,2,3);
plot(f,20*log10(abs(USB)));                    %find the amplitude of USB(k)
title('Figure 15: dB Magnitude of USB(k) vs. f');
ylabel('Amplitude of USB(k)');
xlabel('f(cycles/sample)');

% sr(n) lsb                    
LSB = fftshift(fft(lsb,NFFT));
subplot(2,2,4);
plot(f,20*log10(abs(LSB)));                    %find the amplitude of LSB(k)
title('Figure 16: dB Magnitude of LSB(k) vs. f');
ylabel('Amplitude of LSB(k)');
xlabel('f(cycles/sample)');
saveas(tosave, 'Figure13_14_15_16_plot.jpg');

% fft xn                      
fft_x = fftshift(fft(x,NFFT));
tosave = figure;
subplot(1,2,1);
plot(f,20*log10(abs(fft_x)));                   
title('Figure 17: dB Magnitude of X(k) vs. f');
ylabel('Amplitude of X(k)');
xlabel('f(cycles/sample)');

% fft sn                      
fft_s = fftshift(fft(s,NFFT));
subplot(1,2,2);
plot(f,20*log10(abs(fft_s)));                   
title('Figure 18: dB Magnitude of S(k) vs. f');
ylabel('Amplitude of S(k)');
xlabel('f(cycles/sample)');
saveas(tosave, 'figure17_18.jpg');