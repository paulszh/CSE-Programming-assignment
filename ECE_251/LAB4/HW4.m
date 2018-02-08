close all;
clear;

%% Part A:
N = 1024; % 1024 points
f = 0.125; % Given in the question, double check
var = 1;   % Given in the quetion, variance is 1
n = 0 : N-1;
sine = sqrt(2)*sin(2*pi*f*n);
white_noise = randn(1,N); 

series = sine + white_noise;

N0 = 128;
series128 = series(1:N0);
tosave = figure;
plot(0 : N0 - 1, series128);
axis([0 128 -4 4]);
title('Figure 1: time series N = 128');
xlabel('N');
ylabel('Magnitude');
saveas(tosave, 'Figure1.jpg')

 %% Part B? 
tosave = figure;
NFFT = 64;
for i = 1 : 4
    NFFT = 2 * NFFT;
    window = hamming(NFFT);
    newSignal =series(1 : NFFT) .* window';
    Sk = fftshift(fft(newSignal, NFFT));
    normSk = 1./sum(window.^2)*(abs(Sk).^2);            %TODO?double check
    k = -NFFT/2 : NFFT/2 -1;
    fk = k*(1/NFFT);
    subplot(2,2,i);
    plot(fk, 10*log10(abs(normSk)));
    str = ['Figure ' num2str(1 + i) ' : normalized power spectrum N : ' num2str(NFFT)];
    title(str);
    xlabel('f(cycle/sample)');
    ylabel('dB magnitude');
end
 saveas(tosave, 'Figure_2_3_4_5.jpg');

 %% Part C? 
 M = 128;
 window = hamming(M);
 U = 1/M * sum(window.^2);
 K = [8 15 29];
 overlap = [0 50 75];
 temp = [1 2 4];
 tosave = figure;
 incoh_avg_result = zeros(3,128,'double');
 for i = 1 : 3
    SUM = 0;
    for j = 1:K(i)
%         tempSeries = series((j-1)*(M/(2^(j-1)))+1:(j-1)*(M/(2^(j-1)))+M);
        tempSeries = series((j-1)*(M/temp(i))+1:(j-1)*(M/temp(i))+M);
%         if (tempSeries(5) ~= tempSeries(5))
%             disp('here');
%         end
        FFT = fftshift(fft(tempSeries.*window',M));
        ADDER = 1/(M*U)*(abs(FFT).^2);
        SUM = SUM + ADDER;
    end;
    incoh_avg = SUM/K(i);
    k = -M/2: M/2-1;
    fk = k*(1/M);
    subplot(3,1,i);
    plot(fk, 10*log10(abs(incoh_avg)));
    incoh_avg_result(i,:) = incoh_avg(:);
    str = ['Figure ' num2str(5 + i) ' : Power spectrum estimate for ' num2str(overlap(i)) '% overlap of records'];
    title(str);
    xlabel('f(cycle/sample)');
    ylabel('dB magnitude');
 end
 saveas(tosave, 'Figure_6_7_8.jpg');    

%Compare B1 C1
tosave = figure;
k = -M/2 : (M/2-1); 
fk = k*(1/M);
newSignal = series(1:M).*window';
Sk = fftshift(fft(newSignal, M));
normSk = 1./sum(window.^2)*(abs(Sk).^2);
plot(fk, 10*log10(abs(normSk))); hold on;
plot(fk, 10*log10(abs(incoh_avg_result(1,:))),'r--'); 
legend('B1','C1');
title('Figure9: Compare B1 and C1 (K = 8)');
xlabel('f(cycle/sample)'); 
ylabel('dB magnitude');   
saveas(tosave, 'Figure9.jpg');   

%Compare C1 C2
tosave = figure;
plot(fk, 10*log10(abs(incoh_avg_result(1,:)))); hold on;
plot(fk, 10*log10(abs(incoh_avg_result(2,:))),'r--'); 
title('Figure10: Compare C1 and C2');
xlabel('f(cycle/sample)'); 
ylabel('dB magnitude');   
legend('C1','C2');
saveas(tosave, 'Figure10.jpg'); 

%Compare C2 C3
tosave = figure;
plot(fk, 10*log10(abs(incoh_avg_result(1,:)))); hold on;
plot(fk, 10*log10(abs(incoh_avg_result(3,:))),'r--'); 
legend('C1','C3');
title('Figure11: Compare C1 and C3');
xlabel('f(cycle/sample)'); 
ylabel('dB magnitude');   
saveas(tosave, 'Figure11.jpg');

%% Part D:
currSum = zeros(1,M,'double');
coherentAvgFFT = zeros(1,M,'double');
k = -M/2:M/2-1; fk = k*(1/M);
% K = 1 
for i = 1:8
    seriesSeg= series(((i-1)*M+1):(i*M));
    currSum = currSum + seriesSeg;
    coherentAvgFFT = coherentAvgFFT + fftshift(fft(seriesSeg.*window',M));
end
coherentAvg = currSum./8;
coherentAvgFFT = coherentAvgFFT./8;

tosave = figure; 
plot(0:M-1, coherentAvg);
title('Figure12: coherent average of time series segment');
axis([0 128 -2 2.5])
xlabel('n');
ylabel('coherent average');
saveas(tosave, 'Figure12.jpg');

tosave = figure; 
subplot(1,2,1);
coherentAvgFFT = 1./sum(window.^2)*(abs(coherentAvgFFT).^2);
plot(fk, 10*log10(abs(coherentAvgFFT)));
title('Figure13: The K-FFT of coherent average');
xlabel('f(cycle/sample)');
ylabel('dB magnitude');

subplot(1,2,2);
signalSpectrum = fftshift(fft(coherentAvg.*window', M));
powerSpectrum = 1./sum(window.^2)*(abs(signalSpectrum).^2);
plot(fk, 10*log10(abs(powerSpectrum)));
title('Figure14: The Power Spectrum of coherent average');
xlabel('f(cycle/sample)');
ylabel('dB magnitude');
saveas(tosave, 'Figure13_14.jpg');