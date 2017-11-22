image = imread('pattern.tif');
imwrite(uint8(image),'origin.jpg');
%Problem 1-ii-b
mostSharpen = blurOrSharpen(image, 1,1);
mostBlurred = blurOrSharpen(image,-1,1);

tosave = figure;
(imshow(uint8(mostBlurred)));
saveas(tosave,'mostBluredSigma10.jpg')

tosave = figure;
imshow(uint8(mostSharpen));
saveas(tosave,'mostSharpenSigma10.jpg')

tosave = figure; 
blurred = blurOrSharpen(image,-1,10);
imshow(uint8(blurOrSharpen(blurred,1,10)));
saveas(tosave,'sharpenOnBlurImageSigma10.jpg');

%Problem 1-ii-c
result = blurOrSharpen(image,1,10);
tosave = figure;
imshow(uint8(result));
saveas(tosave,'sharpenSigma10.jpg');

% problem 1-iii-a

brain = imread('brain.tif');
tosave = figure;
imshow(uint8(brain));
saveas(tosave,'brainOrigin.jpg')
toRecover = gaussianBlur(brain,2);
tosave = figure;
imshow(uint8(toRecover));
saveas(tosave,'brainBlurred.jpg');
recover = gaussianUnblur(toRecover,2,1000,0.0001);
tosave = figure;
imshow(uint8(recover));
saveas(tosave,'brainSharpen.jpg');
gaussianUnblurHelper(brain,toRecover,2,1000,0.0001);

%problem 1-iii-b
toRecover = single(imnoise(uint8(toRecover), 'gaussian'));
tosave = figure;
imshow(uint8(toRecover));
saveas(tosave,'brainBlurredNoise.jpg');
recover = gaussianUnblur(toRecover,2,1000,0.0001);
tosave = figure;
imshow(uint8(recover));
saveas(tosave,'brainSharpenNoise.jpg');
gaussianUnblurHelper(brain,toRecover,2,1000,0.0001);


