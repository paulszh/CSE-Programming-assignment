function [ result ] = gradientMagnitude( image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
old = image;
imshow(image);

F = [-1 -2 -1; 0 0 0; 1 2 1];
result = imfilter(image, F);
figure,imshow(result);title('new');

B = old - result;
figure,imshow(B),title('final');
end

