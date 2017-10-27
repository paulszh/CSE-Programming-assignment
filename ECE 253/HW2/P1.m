image = imread('beach.png');
% image = imresize(image,[300,400]);
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

figure, imshow(histeq(image));
figure,imshow(padImage33);
figure,imshow(padImage65);
figure, imshow(padImage129);


