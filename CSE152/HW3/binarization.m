input_image = rgb2gray(imread('can_pix.png'));
imshow(input_image);

result = binarization_otus(input_image);

imwrite(result,'otus.png')
figure,imshow(result);


%starting the problem 2 here

set(0, 'RecursionLimit', 1000);


find_connected_components(result);
can_cc = find_connected_components(result);
figure,imagesc(can_cc);


input = rgb2gray(imread('coins_pix.jpg'));
input = binarization_otus(input);
input = imresize(input, 0.25, 'bilinear');
% imshow(input);

coin_cc = find_connected_components(input);
figure,imagesc(coin_cc);





% CC = bwconncomp(input);
% set(0, 'RecursionLimit', 1000);
% [h,w] = size(input);
% mark = ones(h,w);
% mark = -mark;
% marker = 0;