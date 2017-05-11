%Car1
input1 = imread('car1.jpg');
original1 = input1;
filter = imread('cartemplate.jpg');
input1 = im2double(mat2gray(input1));
filter1 = im2double(mat2gray(imgaussfilt(filter)));
bound1 = [180,145,520,245];
It = input1 - mean2(input1);
filter1 = imresize(filter1, [bound1(4)-bound1(2), bound1(3)-bound1(1)]);
[h, w] = size(filter1);
rotated = zeros(h, w);
for i=1:h
    for j=1:w
        rotated(h-i+1, w-j+1) = filter1(i,j);
    end
end
rotated = rotated - mean2(rotated);
output = imfilter(It, rotated,'conv');
[y, x] = find(output == max(output(:)));

figure,imagesc(output), colormap jet;
figure, imshow(original1),hold on;
for i = 1:length(y)
    rectangle('Position', [x(i)-w/2 y(i)-h/2 w h],'EdgeColor', 'b', 'LineWidth', 2);
end
hold off;

rectangle('Position',[bound1(1),bound1(2),bound1(3)-bound1(1),bound1(4)-bound1(2)],'edgecolor','g', 'LineWidth', 2);

rate1 = cal_overlap(x-w/2,x+w/2,y-h/2,y+h/2,bound1(1),bound1(3),bound1(2),bound1(4))

rectangle('Position',[bound1(1),y(i)-h/2,w-bound1(1)+x(i)-w/2,h+bound1(2)-y(i)+h/2],'edgecolor','m', 'LineWidth', 2);

%Car2
input2 = imread('car2.jpg');
original2 = input2;
filter2 = fliplr(filter1);
input2 = mat2gray(input2);
input2 = im2double(input2);
filter2 = mat2gray(filter2);
filter2 = im2double(filter2);
bound2 = [65,205,495,355];

It = input2 - mean2(input2);
filter2 = imresize(filter2, [bound2(4)-bound2(2), bound2(3)-bound2(1)]);
[h2, w2] = size(filter2);
rotated = zeros(h2,w2);
for i=1:h2
    for j=1:w2
        rotated(h2-i+1, w2-j+1) = filter2(i,j);
    end
end
rotated = rotated - mean2(rotated);
output = imfilter(It, rotated,'conv');
[y2, x2] = find(output == max(output(:)));

figure,imagesc(output), colormap jet;
figure, imshow(original2),hold on;
for i = 1:length(y2)
    rectangle('Position', [x2(i)-w2/2 y2(i)-h2/2 w2 h2],'EdgeColor', 'b', 'LineWidth', 2);
end
hold off;

rectangle('Position',[bound2(1),bound2(2),bound2(3)-bound2(1),bound2(4)-bound2(2)],'edgecolor','g', 'LineWidth', 2);
hold off;
rate2 = cal_overlap(x2-w2/2,x2+w2/2,y2-h2/2,y2+h2/2,bound2(1),bound2(3),bound2(2),bound2(4))
rectangle('Position',[bound2(1),bound2(2),w2-bound2(1)+x2(i)-w2/2,h2-bound2(2)+y2(i)-h2/2],'edgecolor','m', 'LineWidth', 2);

%Car3
input3 = imread('car3.jpg');
original3 = input3;
filter3 = fliplr(filter);
input3 = mat2gray(input3);
input3 = im2double(input3);
filter3 = mat2gray(filter3);
filter3 = im2double(filter3);
bound3 = [330, 251, 480, 345];
filter3 = imresize(filter3, [bound3(4)-bound3(2), bound3(3)-bound3(1)]);
It = input3 - mean2(input3);
[h3, w3] = size(filter3);
rotated = zeros(h3,w3);
for i=1:h3
    for j=1:w3
        rotated(h3-i+1, w3-j+1) = filter3(i,j);
    end
end
rotated = rotated - mean2(rotated);
output = imfilter(It, rotated,'conv');
[y3, x3] = find(output == max(output(:)));

figure,imagesc(output), colormap jet;
figure, imshow(original3),hold on;
for i = 1:length(y)
    rectangle('Position', [x3(i)-w3/2 y3(i)-h3/2 w3 h3],'EdgeColor', 'b', 'LineWidth', 2);
end
hold off;
rectangle('Position',[bound3(1),bound3(2),bound3(3)-bound3(1),bound3(4)-bound3(2)],'edgecolor','g', 'LineWidth', 2);
hold off;
rate3 = cal_overlap(x3-w3/2,x3+w3/2,y3-h3/2,y3+h3/2,bound3(1),bound3(3),bound3(2),bound3(4))
rectangle('Position',[x3(i)-w3/2,y3(i)-h3/2,w3+bound3(1)-x3(i)+w3/2,h3+bound3(2)-y3(i)+h3/2],'edgecolor','m', 'LineWidth', 2);