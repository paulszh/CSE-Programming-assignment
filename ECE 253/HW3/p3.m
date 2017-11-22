% problem 3 i 
letter = double(imread('Letters.jpg'));
template = double(imread('LettersTemplate.jpg'));
convResult = convolveSpatial(letter,template);
tosave = figure;
imagesc(convResult),colorbar;
saveas(tosave, 'convolution_spatial_letter.jpg');
filteredImage = multiFreq(letter, template);
tosave = figure;
imagesc(filteredImage),colorbar;
saveas(tosave, 'convolution_freq_letter.jpg');

% problem 3 ii 
rgbImage = imread('StopSign.jpg');
stopSign = double(rgb2gray(rgbImage));
stopSignTemp = double(rgb2gray(imread('StopSignTemplate.jpg')));
convResult = convolveSpatial(stopSign,stopSignTemp);
tosave = figure;
imagesc(convResult),colorbar;
saveas(tosave, 'convolution_spatial_sign.jpg');
filteredImage = multiFreq(stopSign, stopSignTemp);
tosave = figure;
imagesc(filteredImage),colorbar;
saveas(tosave, 'convolution_freq_sign.jpg');


%problem 3 iii
resultImage = normxcorr2(stopSignTemp, stopSign);
[h,w] = size(stopSign);
[r,c] = size(stopSignTemp);

%crop the image to original size
resultImage = resultImage(1 + floor(r/2): floor(r/2) + h, 1 + floor(c/2) : floor(c/2) + w);
tosave = figure;
imagesc(resultImage),colorbar;
saveas(tosave, 'normalized_cross_correlation.jpg');
maxInt = max(resultImage(:));
[x1,y1]=find(resultImage == maxInt);
stopSign = insertShape(rgbImage, 'rectangle', [round(y1-c/2) round(x1-r/2), c, r], 'LineWidth',5);
tosave = figure;
imagesc(stopSign);colorbar;
saveas(tosave, 'detected_origin_image.jpg');







