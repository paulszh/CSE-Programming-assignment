result_image = uint8(zeros(512,512,3));

%read and resize the image
I = imread('cleese.JPG');
%resize the image with bilinear interpolation to size 256 * 256
resize_image = imresize(I, [256,256],'bilinear');

%concatenating the resized image to the result image
result_image(1:256,1:256,:)=resize_image;
result_image(257:512,1:256,1)=resize_image(:,:,1); %Red

result_image(1:256,257:512,2)=resize_image(:,:,2); %Green

result_image(257:512,257:512,3)=resize_image(:,:,3); %Blue

figure,imshow(result_image);
imwrite(result_image,'modified_cleese.png') %write an output image