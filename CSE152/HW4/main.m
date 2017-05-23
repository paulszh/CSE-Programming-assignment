load ('dino2.mat');
image = rgb2gray(dino01);
[h,w] = size(image);
% Problem 1.1 a applying the gaussian smooth filter
filtered_image_sigma1 = gaussian_smooth(image,1);
filtered_image_sigma3 = gaussian_smooth(image,3);
filtered_image_sigma5 = gaussian_smooth(image,5);
% imshow(filtered_image_sigma3);

% Problem 1.1 b  calculating the gradient
[Ix,Iy] = calculate_gradient(filtered_image_sigma1);
figure,imagesc(Ix), colormap gray;
figure,imagesc(Iy), colormap gray;
[Ix,Iy] = calculate_gradient(filtered_image_sigma3);
figure,imagesc(Ix), colormap gray;
figure,imagesc(Iy), colormap gray;
[Ix,Iy] = calculate_gradient(filtered_image_sigma5);
figure,imagesc(Ix), colormap gray;
figure,imagesc(Iy), colormap gray;

% Problem 1.2a
Ix = Ix(1:h,1:w);
Iy = Iy(1:h,1:w);
width = ones(7,7);
Ix2 = conv2(Ix.* Ix,width,'same');
Iy2 = conv2(Iy.* Iy,width,'same');
Ixy2 = conv2(Ix.*Iy, width, 'same');

lambda = zeros(h,w);a
corner = cell(0);
idx = 0;


for x = 1 : h
    for y = 1 : w
        C = [Ix2(x,y), Ixy2(x,y); Ixy2(x,y), Iy2(x,y)];
        V = eig(C);
        lambda(x,y) = min(V);
    end
end
% 
figure,imshow(lambda, []);

for x = 1 : h
    for y = 1 : w       
        if(1 == check_neighbor(lambda,x,y))
             corner{end+1} = [x y double(lambda(x,y))];
        end
    end
end



%Problem 3:
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
% 
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


