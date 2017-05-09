% Problem 1
input_image = rgb2gray(imread('can_pix.png'));
% imshow(input_image);

result = binarization_otus(input_image);

imwrite(result,'otus.png')
% figure,imshow(result);


%starting the problem 2 here

set(0, 'RecursionLimit', 1000);


find_connected_components(result);
can_cc = find_connected_components(result);
figure,imagesc(can_cc);


input = rgb2gray(imread('coins_pix.jpg'));
input = imgaussfilt(input,0.18);



input = binarization_otus(input);
input = imresize(input, 0.245, 'bilinear');
input = imcomplement(input);

coin_cc = find_connected_components(input);

figure,imagesc(coin_cc);
% 
% image_watch = rgb2gray(imread('watch.png'));
% binary_watch = binarization_otus(image_watch);
% % imshow(binary_watch);
% 
% watch_cc = find_connected_components(binary_watch);
% % figure,imagesc(watch_cc);



image_airpod = rgb2gray(imread('mouse.png'));
binary_airpod = binarization_otus(image_airpod);
binary_airpod = imresize(binary_airpod, 0.75, 'bilinear');
figure,imshow(binary_airpod);

airpod_cc = find_connected_components(binary_airpod);
% figure,imagesc(airpod_cc);

% calculate the moment: 

% Implement three functions(momemnt, central, normalized)
% take three images with one connected component
% For each image in your set{
%   compute centriod
%   compute eigen vectors
%   plot image
% }

disp(moment(airpod_cc,0,0,1));
disp(moment(binary_airpod,0,0,1));

disp(central_moment(airpod_cc,0,0,1));
disp(central_moment(binary_airpod,0,0,1));



% CC = bwconncomp(binary_watch);
% figure,imagesc(CC);

% CC = bwconncomp(input);
% set(0, 'RecursionLimit', 1000);
% [h,w] = size(input);
% mark = ones(h,w);
% mark = -mark;
% marker = 0;