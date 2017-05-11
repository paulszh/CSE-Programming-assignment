% Problem 1
input_image = rgb2gray(imread('can_pix.png'));
% imshow(input_image);

result = binarization_otus(input_image);

imwrite(result,'otus.png')
% figure,imshow(result);


%Problem 2.1a
set(0, 'RecursionLimit', 1000);


find_connected_components(result);
can_cc = find_connected_components(result);
figure,imagesc(can_cc);

%Problem 2.1b
coin_image = rgb2gray(imread('coins_pix.jpg'));
coin_image = imgaussfilt(coin_image,0.18);
coin_image = binarization_otus(coin_image);
coin_image = imcomplement(imresize(coin_image, 0.245, 'bilinear'));
coin_cc = find_connected_components(coin_image);
figure,imagesc(coin_cc);
% 
image_watch = rgb2gray(imread('watch.png'));
binary_watch = binarization_otus(image_watch);

binary_watch = imcomplement(imresize(binary_watch, 0.25, 'bilinear'));
watch_cc = find_connected_components(binary_watch);
figure,imagesc(watch_cc);

%Problem 2.2
% image_mouse = rgb2gray(imread('mouse.png'));
% % binary_mouse = binarization_otus(image_mouse);
% binary_mouse = imbinarize(image_mouse);
% figure,imshow(binary_mouse);
% binary_mouse = imresize(binary_mouse, 0.6, 'bilinear');
% figure,imshow(binary_mouse);
% mouse_cc = find_connected_components(binary_mouse);
% figure,imagesc(mouse_cc);

% Problem 2.3 calculate the moment: 

% Implement three functions(momemnt, central, normalized)
% take three images with one connected component
% For each image in your set{
%   compute centriod
%   compute eigen vectors
%   plot image
% }

% disp(moment(b,0,0,1));
% disp(moment(binary_mouse,0,0,1));
% binary_mouse = imcomplement(binary_mouse);
% % disp(central_moment(airpod_cc,0,0,1));
% % disp(central_moment(binary_mouse,1,1,1));
% 
% 
% x_avg = double((moment(binary_mouse,1,0,1))/(moment(binary_mouse,0,0,1)));
% y_avg = double((moment(binary_mouse,0,1,1))/(moment(binary_mouse,0,0,1)));
% 
% fprintf('x, y: %d , %d\n', x_avg, y_avg);

watch = imresize(imread('watch.png'), 0.25, 'bilinear');
rec = imresize(imread('rec.png'), 0.5, 'bilinear');
mouse = imread('mouse.png');
watch = rgb2gray(watch);
watch = binarization_otus(watch);
mouse = rgb2gray(mouse);
mouse = binarization_otus(mouse);
rec = rgb2gray(rec);
rec = binarization_otus(rec);
% plot_eigenvectors(watch,1,1);
% plot_eigenvectors(apple,1,1);
% plot_eigenvectors(mouse,1,1);
image_alignment(watch);
image_alignment(rec);
image_alignment(mouse);

% plot_eigenvectors(test,0);
% plot_eigenvectors(test_circle,0);

% disp(normalized_moment(binary_mouse,1,1,1));


% CC = bwconncomp(binary_watch);
% % figure,imagesc(CC);

% CC = bwconncomp(input);
% set(0, 'RecursionLimit', 1000);
% [h,w] = size(input);
% mark = ones(h,w);
% mark = -mark;
% marker = 0;