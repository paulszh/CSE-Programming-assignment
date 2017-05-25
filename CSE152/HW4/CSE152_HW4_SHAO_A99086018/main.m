load ('dino2.mat');
image = rgb2gray(dino01);
image2 = rgb2gray(dino02);

% Problem 1.1 a applying the gaussian smooth filter
filtered_image_sigma1 = gaussian_smooth(image,1);
filtered_image_sigma3 = gaussian_smooth(image,3);
filtered_image_sigma5 = gaussian_smooth(image,5);
% figure,imshow(filtered_image_sigma1);
% figure,imshow(filtered_image_sigma3);
% figure,imshow(filtered_image_sigma5);

% Problem 1.1 b  calculating the gradient
[Ix1,Iy1] = calculate_gradient(filtered_image_sigma1);
% figure,imagesc(Ix1), colormap gray;
% figure,imagesc(Iy1), colormap gray;

[Ix2,Iy2] = calculate_gradient(filtered_image_sigma3);
% figure,imagesc(Ix2), colormap gray;
% figure,imagesc(Iy2), colormap gray;

[Ix3,Iy3] = calculate_gradient(filtered_image_sigma5);
% figure,imagesc(Ix3), colormap gray;
% figure,imagesc(Iy3), colormap gray;

% Problem 1.2
% apply gussian filter on the second image and run the corner detection
% algorithm
n = 50;
top_n_points_1 = corner_detection(filtered_image_sigma1,1,Ix1,Iy1,n);
top_n_points_2 = corner_detection(filtered_image_sigma3,3,Ix2,Iy2,n);
top_n_points_3 = corner_detection(filtered_image_sigma5,5,Ix3,Iy3,n);







% %Problem 3:
% p1 = cor1;
% p2 = cor2;
% orig_p1n = zeros(3,13);
% orig_p2n = zeros(3,13);
% for i = 1 : 13
%      orig_p1n(:,i) = [p1(i,:)';1];
%      orig_p2n(:,i) = [p2(i,:)';1];
% end
% f = estimateFundamental(orig_p1n,orig_p2n);
% 
% %for testing; 
% %for any pairs of points, x'f x should close to 0
% result = ones(13,1);
% for i = 1 : 13
%     result(i) = orig_p2n(:,i)' * f * orig_p1n(:,i);
% end
% % 
% %pick three points 
% pt1 = [692,1022,1]';
% pt2 = [1269,1105,1]';
% pt3 = [739,190,1]';
% pt1_1 = f * pt1;
% pt2_1 = f * pt2;
% pt3_1 = f * pt3;
% 
% figure,imshow(dino02);
% hold on;
% drawLine(pt1_1);
% drawLine(pt2_1);
% drawLine(pt3_1);
% hold off;
% figure,imshow(dino01);
% point1 = [692,1022];
% point2 = [1269,1105];
% point3 = [739,190];
% hold on;
% drawPoint(point1);
% drawPoint(point2);
% drawPoint(point3);
% hold off;


