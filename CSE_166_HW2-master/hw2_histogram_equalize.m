I = imread('tire.tif');
imshow(I);
figure
imhist(I);
%histogram(I);
figure
result = histogramEqualization(I);
imshow(result);
figure;
imhist(result);
%histogram(result);
imwrite(result, 'tire_histeq.png');
