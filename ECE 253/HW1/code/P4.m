clear
image1 = imread('dog.jpg');
image2 = imread('travolta.jpg');
imshow(image1);
grayImage1 = rgb2gray(image1);
grayImage2 = rgb2gray(image2);
binaryImage1 = false(size(grayImage1,1),size(grayImage1,2));
binaryImage2 = false(size(grayImage2,1),size(grayImage2,2));

% figure,imhist(image1(:,:,1));
% figure,imhist(image1(:,:,2));
% figure,imhist(image1(:,:,3));

%creating the mask for dog.jpg
binaryImage1(image1(:,:,2) < 245 & image1(:,:,1) > 100 & image1(:,:,3) > 110) = 1;
binaryImage1(image1(:,:,2) < 160 & image1(:,:,1) > 40 & image1(:,:,3) > 30) = 1;
binaryImage1(image1(:,:,2) < 70 & image1(:,:,1) > 10 & image1(:,:,3) > 10) = 1;
SE = strel('square',7);
erodeImage1 = binaryImage1;
erodeImage1 = imerode(erodeImage1, SE);         %opening 
erodeImage1 = imdilate(erodeImage1, SE);
erodeImage1 = imdilate(erodeImage1, SE);        %closing
erodeImage1 = imerode(erodeImage1, SE);
SE = strel('square',5);
erodeImage1 = imerode(erodeImage1, SE);
binaryImage1 = erodeImage1;
figure,imshow(binaryImage1);

%creating the mask for travolta.jpg
binaryImage2(image2(:,:,2) < 236 & image2(:,:,1) > 5 & image2(:,:,3) > 5) = 1;
% figure,imshow(binaryImage2);
erodeImage1 = binaryImage2;
SE = strel('square',3);
erodeImage1 = imdilate(erodeImage1, SE);        %closing
erodeImage1 = imerode(erodeImage1, SE);
% erodeImage1 = imerode(erodeImage1, SE);         %opening 
% erodeImage1 = imdilate(erodeImage1, SE);
SE = strel('square',9);
erodeImage1 = imerode(erodeImage1, SE);
binaryImage2 = erodeImage1;

figure,subplot(1,2,1);
imshow(binaryImage1);
subplot(1,2,2);
imshow(binaryImage2);
% imwrite(binaryImage1, 'problem3_mask_1.jpg');
% imwrite(binaryImage2, 'problem3_mask_2.jpg');

image1(:,:,1) = image1(:,:,1) .* uint8(binaryImage1);
image1(:,:,2) = image1(:,:,2) .* uint8(binaryImage1);
image1(:,:,3) = image1(:,:,3) .* uint8(binaryImage1);
% figure,imshow(image1);

imwrite(image1, 'problem3_foreground_1.jpg');
image2(:,:,1) = image2(:,:,1) .* uint8(binaryImage2);
image2(:,:,2) = image2(:,:,2) .* uint8(binaryImage2);
image2(:,:,3) = image2(:,:,3) .* uint8(binaryImage2);
% figure,imshow(image2);
imwrite(image2, 'problem3_foreground_2.jpg');

figure,subplot(1,2,1);
imshow(image1);
subplot(1,2,2);
imshow(image2);

background = imread('image.jpg');
figure,imshow(background);

reverse = false(size(grayImage1,1),size(grayImage1,2));
reverse(:) = 1 - binaryImage1(:);
figure, imshow(reverse);

background(:,:,1) = background(:,:,1) .* uint8(reverse);
background(:,:,2) = background(:,:,2) .* uint8(reverse);
background(:,:,3) = background(:,:,3) .* uint8(reverse);

background(:,:,1) = background(:,:,1) + image1(:,:,1);
background(:,:,2) = background(:,:,2) + image1(:,:,2);
background(:,:,3) = background(:,:,3) + image1(:,:,3);
figure, imshow(background);
imwrite(background, 'problem4_3.jpg');

