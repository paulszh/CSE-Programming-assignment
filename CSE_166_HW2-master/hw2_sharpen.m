A = imread('moon.tif');
image = A;
imshow(image);
figure;
result = sharpen(A);
imshow(result);


