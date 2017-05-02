input_image = rgb2gray(imread('can_pix.png'));
imshow(input_image);

result = binarization_otus(input_image);

imwrite(result,'otus.png')
figure,imshow(result);