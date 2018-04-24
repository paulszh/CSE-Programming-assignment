close all;
clear all;
clc;

%% Part A: 
hn = zeros(1,8);
hn(1,:) = 1/8;

N = 1024;
% standard normal distribution
w1n = randn(1,N);
w2n = sqrt(1/32).* randn(1,N) + 0;

NFFT = 128;
Hk = fftshift(fft(hn,NFFT));
fk = 1/NFFT * (0:NFFT-1) - 0.5;
tosave = figure;
subplot(2,2,1);
plot(0:7, hn);
axis([0 7 0 0.15]);
title('Figure 1: original h(n)')
xlabel('n'); 
ylabel('h(n)');

subplot(2,2,2);
plot(fk, 20 * log10(abs(Hk)));
title('Figure 2: H(K) dB magnitude')
xlabel('f(cycles/sample)'); 
ylabel('magnitude dB');

subplot(2,2,3);
plot(fk, abs(Hk));
title('Figure 3: H(K) linear magnitude')
xlabel('f(cycles/sample)'); 
ylabel('|H(k)|');

subplot(2,2,4);
plot(fk, angle(Hk));
title('Figure 4 : H(K) phase')
xlabel('f(cycles/sample)'); 
ylabel('phase(radians)');

saveas(tosave, 'Figure1_2_3_4.jpg');

%% Part B:
filtered = conv(w1n,hn);
yn = filtered(1:1024);
rn = w2n + yn;
window = hamming(NFFT);

% 50 percent overlap
k = (1024/128) * 2 - 1;
SUM = 0;
for i = 1 : k
    left = (i-1)*NFFT/2+1;
    right = (i-1)*NFFT/2+NFFT;
    temp = fftshift(fft(w1n(left:right).*window',NFFT));
    SUM = SUM + abs(temp) .* abs(temp); 
end

avg = SUM/k;
u = 1/NFFT * sum(window.^2);
Sw1w1 = avg / (NFFT * u);
figure;
subplot(2,2,1);
plot(fk, 10*log10(abs(Sw1w1)));
title('Figure 5: dB magnitude power spectrum estimate S_{w1w1}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
subplot(2,2,2);
plot(fk, abs(Sw1w1));
title('Figure 6: linear magnitude power spectrum estimate S_{w1w1}'); 
xlabel('f(cycles/sample)');
ylabel(' |S_{w1w1}|');

Sw2w2 = fftshift(pwelch(w2n, window, NFFT/2, NFFT, 1, 'twosided'));
subplot(2,2,3);
plot(fk, 10*log10(abs(Sw2w2')));
title('Figure 7: dB magnitude power spectrum estimate S_{w2w2}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
subplot(2,2,4);
plot(fk, abs(Sw2w2'));
title('Figure 8: linear magnitude power spectrum estimate S_{w2w2}'); 
xlabel('f(cycles/sample)');
ylabel(' |S_{w2w2}|');

Syy = fftshift(pwelch(yn, window, NFFT/2, NFFT, 1, 'twosided'));
figure;
subplot(2,2,1);
plot(fk, 10*log10(abs(Syy')));
title('Figure 9: dB magnitude power spectrum estimate S_{yy}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
subplot(2,2,2);
plot(fk, abs(Syy'));
title('Figure 10: linear magnitude power spectrum estimate S_{yy}'); 
xlabel('f(cycles/sample)');
ylabel(' |Y_{nn}|');

Srr = fftshift(pwelch(rn, window, NFFT/2, NFFT, 1, 'twosided'));
subplot(2,2,3);
plot(fk, 10*log10(abs(Srr')));
title('Figure 11: dB magnitude power spectrum estimate S_{yy}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
subplot(2,2,4);
plot(fk, abs(Srr'));
title('Figure 12: linear magnitude power spectrum estimate S_{yy}'); 
xlabel('f(cycles/sample)');
ylabel(' |Y_{nn}|');

%% Part c using cpsd for cross power spectral
Syw1 = fftshift(cpsd(yn,w1n, window, NFFT/2, NFFT, 1, 'twosided'));
figure;
subplot(3,2,1);
plot(fk, 10*log10(abs(Syw1)));
title('Figure 13: dB magnitude power spectrum estimate S_{yw1}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
subplot(3,2,2);
plot(fk, abs(Syw1));
title('Figure 14: linear magnitude power spectrum estimate S_{yw1}'); 
xlabel('f(cycles/sample)');
ylabel(' |Y_{yw1}|');
subplot(3,2,3);
plot(fk, angle(Syw1));
title('Figure 15: phase power spectrum estimate S_{yw1}'); 
xlabel('f(cycles/sample)');
ylabel('phase(radians)');

Srw1 = fftshift(cpsd(rn,w1n, window, NFFT/2, NFFT, 1, 'twosided'));
subplot(3,2,4);
plot(fk, 10*log10(abs(Srw1)));
title('Figure 16: dB magnitude power spectrum estimate S_{rw1}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
subplot(3,2,5);
plot(fk, abs(Srw1));
title('Figure 17: linear magnitude power spectrum estimate S_{rw1}'); 
xlabel('f(cycles/sample)');
ylabel(' |S_{rw1}|');
subplot(3,2,6);
plot(fk, angle(Srw1));
title('Figure 18: phase power spectrum estimate S_{rw1}'); 
xlabel('f(cycles/sample)');
ylabel('phase(radians)');

%% Part D
Hw1y = Syw1./Sw1w1';
Hw1r = Srw1./Sw1w1';
figure;
subplot(3,2,1);
plot(fk, 10*log10(abs(Hw1y)));
title('Figure 19: dB magnitude power spectrum estimate H_{w1y}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
line([fk(65) fk(65)],[-1.3+10*log10(abs(Hw1y(65))) 1.1+10*log10(abs(Hw1y(65)))], 'Color', 'red');
line([fk(89) fk(89)],[-1.3+10*log10(abs(Hw1y(89))) 1.1+10*log10(abs(Hw1y(89)))], 'Color', 'red');
line([fk(105) fk(105)],[-1.3+10*log10(abs(Hw1y(105))) 1.1+10*log10(abs(Hw1y(105)))], 'Color', 'red');
subplot(3,2,2);
plot(fk, abs(Hw1y));
title('Figure 20: linear magnitude power spectrum estimate H_{w1y}'); 
xlabel('f(cycles/sample)'); 
ylabel('|H_{w1y}|');
subplot(3,2,3);
plot(fk, angle(Hw1y));
title('Figure 21: Phase : H_{w1y})'); 
xlabel('f(cycles/sample)'); 
ylabel('phase(radians)');
phase = angle(Hw1y);
line([fk(65) fk(65)],[-8/180*pi+phase(65) 8/180*pi+phase(65)], 'Color', 'red');
line([fk(89) fk(89)],[-8/180*pi+phase(89) 8/180*pi+phase(89)], 'Color', 'red');
line([fk(105) fk(105)],[-8/180*pi+phase(105) 8/180*pi+phase(105)], 'Color', 'red');
subplot(3,2,4);
plot(fk, 10*log10(abs(Hw1r)));
title('Figure 22: dB magnitude power spectrum estimate H_{w1r}'); 
xlabel('f(cycles/sample)'); 
ylabel('dB magnitude');
% 90 percent confidence interval
line([fk(65) fk(65)],[-1.3+10*log10(abs(Hw1r(65))) 1.1+10*log10(abs(Hw1r(65)))], 'Color', 'red');
line([fk(89) fk(89)],[-3.5+10*log10(abs(Hw1r(89))) 2.5+10*log10(abs(Hw1r(89)))], 'Color', 'red');
line([fk(105) fk(105)],[-3.5+10*log10(abs(Hw1r(105))) 2.5+10*log10(abs(Hw1r(105)))], 'Color', 'red');
subplot(3,2,5);
plot(fk, abs(Hw1r));
title('Figure 23: linear magnitude power spectrum estimate H_{w1r}'); 
xlabel('f(cycles/sample)'); 
ylabel('|H_{w1y}|');
subplot(3,2,6);
plot(fk, angle(Hw1r));
title('Figure 24: Phase : H_{w1r})'); 
xlabel('f(cycles/sample)'); 
ylabel('phase(radians)');
phase = angle(Hw1r);
line([fk(65) fk(65)],[-8/180*pi+phase(65) 8/180*pi+phase(65)], 'Color', 'red');
line([fk(89) fk(89)],[-8/180*pi+phase(89) 8/180*pi+phase(89)], 'Color', 'red');
line([fk(105) fk(105)],[-8/180*pi+phase(105) 8/180*pi+phase(105)], 'Color', 'red');
%% Part E Magnitude-squared coherence function estimates
Gw1y = (abs(Syw1').^2)./(abs(Sw1w1).* abs(Syy'));
Gw2y = (abs(Srw1').^2)./(abs(Sw1w1).* abs(Srr'));
figure;
subplot(1,2,1);
plot(fk,abs(Gw1y));
magnitude1 = abs(Gw1y);
title('Figure 25: linear magnitude : \gamma^2_{w1y}'); 
xlabel('f(cycles/sample)'); 
ylabel('|\gamma^2_{w1y}|');
line([fk(65) fk(65)],[0.94 1], 'Color', 'red');
line([fk(89) fk(89)],[0.94 1], 'Color', 'red');
line([fk(105) fk(105)],[0.94 1],'Color', 'red');
subplot(1,2,2);
plot(fk,abs(Gw2y));
title('Figure 26: linear magnitude : \gamma^2_{w1r}'); 
xlabel('f(cycles/sample_)'); 
ylabel('|\gamma^2_{w1r}|');
line([fk(65) fk(65)],[0.94 1], 'Color', 'red');
line([fk(89) fk(89)],[0.25 0.67], 'Color', 'red');
line([fk(105) fk(105)],[0.50 0.81],'Color', 'red');
