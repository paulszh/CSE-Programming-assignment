%Problem 2 
clear;
load ('dino2.mat');
image = rgb2gray(dino01);
image2 = rgb2gray(dino02);


filtered_image_sigma5_dino1 = gaussian_smooth(image,5);
[Ix1,Iy1] = calculate_gradient(filtered_image_sigma5_dino1);

filtered_image_sigma5_dino2 = gaussian_smooth(image2,5);
[Ix2,Iy2] = calculate_gradient(filtered_image_sigma5_dino2);

n = 50; 
top_n_points_dino1 = corner_detection(filtered_image_sigma5_dino1,5,Ix1,Iy1,n);
top_n_points_dino2 = corner_detection(filtered_image_sigma5_dino2,5,Ix2,Iy2,n);

% % threshold = 0;
% % ratio = 0; 
% matched_points = zeros(50,2);

best_match = Inf(50);

for i = 1 : n  %for each corners in dino1
    x1 = top_n_points_dino1(i,1);
    y1 = top_n_points_dino1(i,2);
    for j = 1 : n
        x2 = top_n_points_dino2(j,1);
        y2 = top_n_points_dino2(j,2);
        m1 = filtered_image_sigma5_dino1(x1-5:x1+5,y1-5:y1+5);
        m2 = filtered_image_sigma5_dino2(x2-5:x2+5,y2-5:y2+5);
        best_match(i,j) = NSSD(m1,m2,11);            
    end
end
best_match = best_match/100;

num_c = 50;
record_idx = zeros(num_c,2);
idx = 1;
% find top 20 correspondence
for k = 1 : num_c
    [v,i] = min(best_match(:));
    if(v < 0.08)
        [x,y] = ind2sub(size(best_match),i); %x , y is the index of global min
        best_match(x,y) = Inf;
    end
    v1 = min(best_match(x,:));
    v2 = min(best_match(:,y));
    if(v/v1<0.6) && (v/v2<0.6)
        record_idx(idx,1) = x;
        record_idx(idx,2) = y;
        best_match(x,:) = Inf;
        best_match(:,y) = Inf;
        idx = idx + 1;
    end
end

pad_image2 = zeros(1500,2000);
pad_image2(1:1450,1:1900) = image2;
figure,imshow([image pad_image2])
hold on;
for i = 1 : num_c
    if(record_idx(i,1) ~= 0) && (record_idx(i,2)~=0)
       pt1_idx = record_idx(i,1);
       pt2_idx = record_idx(i,2);
       x1 = top_n_points_dino1(pt1_idx,1);
       y1 = top_n_points_dino1(pt1_idx,2);
       x2 = top_n_points_dino2(pt2_idx,1);
       y2 = top_n_points_dino2(pt2_idx,2);
       drawPoint([y2+2000,x2]);
       drawPoint([y1,x1]);
       line([y1, y2+2000],[x1,x2]);
    end
end
hold off;

%  ;
%         pt2 = top_n_points_dino2(record_idx(i,2));
%         line([pt1(1),pt2(1)], [pt2(1), pt2(2)]);
