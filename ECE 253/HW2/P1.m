image = imread('beach.png');
imshow(image);
win_size = 129;
pad_size = floor(win_size/2);
disp(pad_size);
paddedImage = padarray(image,[pad_size,pad_size],'symmetric');
[height,width] = size(paddedImage);
output= uint8(zeros(size(image,1), size(image, 2)));

padImage33 = AHE(image,33);
padImage65 = AHE(image, 65);
padImage129 = AHE(image, 129);
histEq = histeq(image);
figure, subplot(2,2,1)
imshow(histEq);
title('hist')
subplot(2,2,2);
imshow(padImage33);
title('AHE w = 33')
subplot(2,2,3);
imshow(padImage65);
title('AHE w = 65')
subplot(2,2,4);
imshow(padImage129);
title('AHE w = 129')


