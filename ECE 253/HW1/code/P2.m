%i read the image
A = imread('car.png');
figure,imshow(A);
title('A');
%ii convert to grayscale
B = rgb2gray(A);
figure,imshow(B);
%verify the maximum pixel intensity value
disp(max(B(:)));

%iii
C = B + 20;
% the maximum pixel density is also 255, all the pixels with intensity larger
% than 255 are set to 255. This might related to the fact that uint8 cannot hold
% integer value larger than 255
disp(max(C(:)));

%iv
D = flip(fliplr(B));
figure, imshow(D);

%v
vecB = reshape(B, 1, []);
medianB = median(vecB);
[m,n] = size(B);
E = false(m,n);
E(B(:) > medianB) = 1;
E(B(:) <= medianB) = 0;

figure, imshow(E);
axis off
figure, subplot(2,2,1);
imshow(B);
title('B');
subplot(2,2,2);
imshow(C);
title('C');
subplot(2,2,3)
imshow(D);
title('D');
subplot(2,2,4)
imshow(E);
title('E');

