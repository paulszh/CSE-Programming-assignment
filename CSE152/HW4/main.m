load ('dino2.mat');

% image = rgb2gray(dino01);
% [h,w] = size(image);
% % Problem 1.1 a applying the gaussian smooth filter
% filtered_image_sigma1 = gaussian_smooth(image,1);
% filtered_image_sigma3 = gaussian_smooth(image,3);
% filtered_image_sigma5 = gaussian_smooth(image,5);
% % imshow(filtered_image_sigma3);
% 
% % Problem 1.1 b  calculating the gradient
% [Ix,Iy] = calculate_gradient(filtered_image_sigma1);
% figure,imagesc(Ix), colormap gray;
% figure,imagesc(Iy), colormap gray;
% [Ix,Iy] = calculate_gradient(filtered_image_sigma3);
% figure,imagesc(Ix), colormap gray;
% figure,imagesc(Iy), colormap gray;
% [Ix,Iy] = calculate_gradient(filtered_image_sigma5);
% figure,imagesc(Ix), colormap gray;
% figure,imagesc(Iy), colormap gray;
% 
% %Problem 1.2a
% Ix = Ix(1:h,1:w);
% Iy = Iy(1:h,1:w);
% w = ones(7,7);
% Ix2 = conv2(Ix.^2,w,'same');
% Iy2 = conv2(Iy.^2,w,'same');
% Ixy2 = conv2(Ix.* Iy, w, 'same');

% C = [Ix2, Ixy2; Ixy2, Iy2];
% [H,V] = eig(C);




%Problem 3:
p1 = cor1;
p2 = cor2;
orig_p1n = zeros(3,13);
orig_p2n = zeros(3,13);
for i = 1 : 13
     orig_p1n(:,i) = [p1(i,:)';1];
     orig_p2n(:,i) = [p2(i,:)';1];
end
f = estimateFundamental(orig_p1n,orig_p2n);

%for testing; 
%for any pairs of points, x'f x should close to 0
result = ones(13,1);
for i = 1 : 13
    result(i) = orig_p2n(:,i)' * f * orig_p1n(:,i);
end


