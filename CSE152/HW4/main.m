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

% calculating normalization matrix for p1 and p2 
N1 = dataTransformMatrix(p1);
N2 = dataTransformMatrix(p2);

%p1n and p2n are sets of normalized homogenous points
p1n = zeros(3,13);
p2n = zeros(3,13);
orig_p1n = zeros(3,13);
orig_p2n = zeros(3,13);

for i = 1 : 13
    vec1 = [p1(i,:)';1];
    vec2 = [p2(i,:)';1];
    p1n(:,i) = N1 * vec1; 
    p2n(:,i) = N2 * vec2;
    orig_p1n(:,i) = vec1;
    orig_p2n(:,i) = vec2;
end

x1 = p1n(1,:)';
y1 = p1n(2,:)';
z1 = p1n(3,:)';

x2 = p2n(1,:)';
y2 = p2n(2,:)';
z2 = p2n(3,:)';

%Now constructing a 13 * 9 matrix
A = [x1.* x2 y2.*x2 z2.*x2 x1.*y2 y1.*y2 z1.*y2 x1.*z2 y1.*z2 z1.*z2];
%Need to calculate f so that Af = 0, perform svd on A
[U1,S1,V1] = svd(A); 
%V is a 9 * 9 matrix, need to reshape the last column of V into 3*3 matrix
% disp(V(:,9));
f = reshape(V1(:,9),3,3)';
%perform svd on reshape_V
[U2,S2,V2] = svd(f);
%s2 is a 3 * 3, set its last row to 0, so that our f only has rank 2 
S2(3,:) = 0;
f = U2* S2 *V2'

f = N2' * f * N1; %denormalization

%for testing;
result = ones(13,1);
for i = 1 : 13
    result(i) = orig_p2n(:,i)' * f * orig_p1n(:,i);
end


