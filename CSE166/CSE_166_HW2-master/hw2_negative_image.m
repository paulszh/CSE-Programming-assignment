I=imread('spine.png');
%First, convert the picture to grey scale
imshow(I);
whos I
figure;
%format shortg;
L = 256;
result = negativeTransform(I,L);
imshow(result);
imwrite(result, 'spine_negative.png');

