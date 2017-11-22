fuck = imread('test.png'); 
fftCar = fft2(rgb2gray(fuck),512,512);
imFFT = fftshift(fftCar);
figure,imagesc(-256:255,-256:255,log(abs(imFFT))); colorbar;