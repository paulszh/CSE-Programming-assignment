clear;
close all;
%% Part I: data set

% Generating the 4096 point signal with fs = 1khz
fs = 1000;          %given in the problem, the fs = 1khz
Al = [100 10 1];
fl = [160 237 240];
N = 4096;           % given in data set
t = 0 : N - 1;
xt = 0;
for l = 1 : 3
    xt = xt + Al(l) * cos(2 * pi * fl(l).*t/fs); 
end

NFFT = 256;
n = 0 : NFFT - 1;
% extracting the first 256 portion of the data
xn = xt(1:NFFT);
tosave = figure; 
plot(xn);
title('Figure 1: x(n) (n = 0, ..., 255)');
xlabel('n');
ylabel('amplitude');
axis([0 256 -150 150]);
saveas(tosave, 'figure1.jpg');

alpha = 2.5;
beta = 7.85;
kbWindow = kaiser(NFFT, beta);
xk1 = fftshift(fft(xn));

xk = fftshift(fft(xn.* kbWindow', NFFT));
f = fs * (1/NFFT * n - 0.5);

figure;
stem(f, 20*log10(abs(xk1)));

tosave = figure; 
plot(f, 20*log10(abs(xk)));
title('Figure 2: |X(k)| db magnitude');
xlabel('f(Hz)');
ylabel('db magnitude');
saveas(tosave, 'figure2.jpg');

%% Part II: Decimation Filter Design

fpc = 40;   %passband cutoff frequency = 40 Hz (analog)
fsc = 85;   %stopband cutoff frequency = 85 Hz (analog)
n = 63; % 64-coefficient, linear phase, FIR
freq_band = [0, 2 * fpc/fs, 2 * fsc/fs, 1];
hn= firpm(n, freq_band, [1 ,1, 0, 0], [50, 1]);
%plot hn
tosave = figure;
plot(hn);
title('Figure 3: equalrippler FIR filter h(n)');
xlabel('h(n) magnitude');
ylabel('n');
axis([0 64 -0.05 0.15]);
saveas(tosave, 'figure3.jpg');

NFFT = 1024;
w = rectwin(1024);
hn = [hn, zeros(1,NFFT-length(hn))];
hk = fftshift(fft(hn.* w', NFFT));

k = -NFFT/2 : NFFT/2 - 1; % 1024 points in total
fk = fs * (1/NFFT * k);
tosave = figure;
plot(fk, 20 * log10(abs(hk)));
title('Figure 4: |H(k)| db magnitude');
xlabel('f(Hz)');
ylabel('db magnitude');
saveas(tosave, 'figure 4.jpg');

% plot the zoom in graph f from -40hz to 40hz
tosave = figure;
plot(fk, 20 * log10(abs(hk)));
title('Figure 5: |H(k)| db magnitude -40hz to 40hz');
xlim([-40 40]);
ylim([-0.01, 0.01])
xlabel('f(Hz)');
ylabel('db magnitude');
saveas(tosave, 'figure 5.jpg');

%% Part III Complex Basebanding and Desampling
% part a
f0 = 250;
w0 = 2 * pi * f0/fs;
NFFT = 256;
alpha = 2.5;
beta = 7.85;
n = 0 : N - 1;
k = 0 : NFFT - 1;
kbWindow = kaiser(NFFT, beta);
cm = exp(-1i .* n * w0) .* xt;
fftcm = fftshift(fft(cm(1:NFFT) .* kbWindow', NFFT));
tosave = figure;
f = fs * (1/NFFT * k - 0.5);
plot(f, 20 * log10(abs(fftcm)));
title('Figure 6: |FFT| db magnitude n = 0 : 255');
xlabel('f(Hz)');
ylabel('db magnitude of |FFT|');
saveas(tosave, 'figure 6.jpg');

% part b
% hn4096 = [hn, zeros(1,N-length(hn))];
% filtered = filter(hn4096(1:64),1,cm);
filtered = conv(cm,hn(1:64),'same');
fftcm1= fftshift(fft(filtered(NFFT+1:2*NFFT).* kbWindow',NFFT));% Take FFT
tosave = figure;
plot(f, 20*log10(abs(fftcm1)));
title('Figure 7: |FFT| db magnitude n = 256 : 511');
xlabel('frequency f(Hz)');
ylabel('dB magnitude of |FFT|');
saveas(tosave, 'figure 7.jpg');
% part c
downsampleFiltered = downsample(filtered, 8);

%% Part IV High Resolution Spectral Analysis
fftcm2= fftshift(fft(downsampleFiltered(NFFT+1:2*NFFT).* kbWindow',NFFT));
tosave = figure;
f2 = 125 * (1/NFFT * k - 0.5);
plot(f2, 20*log10(abs(fftcm2)));
title('Figure 8: Downsampled(125Hz)|FFT| db magnitude n = 256 : 511');
xlabel('frequency f(Hz)');
ylabel('dB magnitude of |FFT|');
axis([-60 60 -40 60]);
saveas(tosave, 'figure 8.jpg');

% part b
fpc = 40;   %passband cutoff frequency = 40 Hz (analog)
fsc = 85;   %stopband cutoff frequency = 85 Hz (analog)
n = 63; % 64-coefficient, linear phase, FIR
freq_band = [0, 2 * fpc/fs, 2 * fsc/fs, 1];
hn= firpm(n, freq_band, [1 ,1, 0, 0], [1,150]);
%plot hn
tosave = figure;
plot(hn);
title('Figure 9: equalrippler FIR filter h(n) with weighting ratio 1 : 150');
xlabel('h(n) magnitude');
ylabel('n');
axis([0 64 -0.05 0.15]);
saveas(tosave, 'figure9.jpg');

NFFT = 1024;
w = rectwin(1024);
hn = [hn, zeros(1,NFFT-length(hn))];
hk = fftshift(fft(hn.* w', NFFT));

k = -NFFT/2 : NFFT/2 - 1; % 1024 points in total
fk = fs * (1/NFFT * k);
tosave = figure;
plot(fk, 20 * log10(abs(hk)));
title('Figure 10: |H(k)| db magnitude');
xlabel('f(Hz)');
ylabel('db magnitude');
saveas(tosave, 'figure 10.jpg');

% plot the zoom in graph f from -40hz to 40hz
tosave = figure;
plot(fk, 20 * log10(abs(hk)));
title('Figure 11: |H(k)| db magnitude -40hz to 40hz');
xlim([-40 40]);
ylim([-0.25, 0.25])
xlabel('f(Hz)');
ylabel('db magnitude');
saveas(tosave, 'figure11.jpg');

f0 = 250;
w0 = 2 * pi * f0/fs;
NFFT = 256;
alpha = 2.5;
beta = 7.85;
n = 0 : N - 1;
k = 0 : NFFT - 1;
kbWindow = kaiser(NFFT, beta);
cm = exp(-1i .* n * w0) .* xt;
% hn4096 = [hn, zeros(1,N-length(hn))];
% filtered = filter(cm,1,hn4096);
filtered = conv(cm,hn(1:64),'same');
downsampleFiltered = downsample(filtered, 8);
fftcm2= fftshift(fft(downsampleFiltered(NFFT+1:2*NFFT).* kbWindow',NFFT));
tosave = figure;
plot(f2, 20*log10(abs(fftcm2)));
title('Figure 12: Downsampled(125Hz)|FFT| db magnitude n = 256 : 511');
xlabel('frequency f(Hz)');
ylabel('dB magnitude of |FFT|');
axis([-60 60 -40 60]);
saveas(tosave, 'figure 12.jpg');