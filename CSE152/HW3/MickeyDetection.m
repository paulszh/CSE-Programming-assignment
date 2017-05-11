micky = imread('toy.png');
original = micky;
filter = imread('filter.jpg');

% convert micky to double image
micky = mat2gray(micky);
micky = im2double(micky);

% convert filter to double image
filter = mat2gray(filter);
filter = im2double(filter);

It = micky - mean2(micky);
[h, w] = size(filter);
rotated = zeros(h,w);
for x=1:h
	for y=1:w
		rotated(h-x+1, w-y+1) = filter(x,y);
	end
end
rotated = rotated - mean2(rotated);
output = imfilter(It, rotated,'conv');
[y, x] = find(output == max(output(:)));

figure,imagesc(output), colormap jet;
figure,imshow(original);
for i = 1:length(y)
	rectangle('Position', [x(i)-w/2 y(i)-h/2 w h],'EdgeColor', 'b', 'LineWidth', 2);
end

%Problem 3.2
figure,imshow(original),hold on;
for i = 1:length(y)
	rectangle('Position', [x(i)-w/2 y(i)-h/2 w h],'EdgeColor', 'b', 'LineWidth', 2);
end
box1 = [110,140,190,220];
rectangle('Position',[box1(1),box1(2),box1(3)-box1(1),box1(4)-box1(2)],'edgecolor','c');
rate1 = overlap_rate(x(1)-w/2,x(1)+w/2,y(1)-h/2,y(1)+h/2,box1(1),box1(3),box1(2),box1(4));

box2 = [90,140,200,230];
rectangle('Position',[box2(1),box2(2),box2(3)-box2(1),box2(4)-box2(2)],'edgecolor','c');
rate2 = overlap_rate(x(1)-w/2,x(1)+w/2,y(1)-h/2,y(1)+h/2,box2(1),box2(3),box2(2),box2(4));

box3 = [70,100,250,270];
rectangle('Position',[box3(1),box3(2),box3(3)-box3(1),box3(4)-box3(2)],'edgecolor','c');
rate3 = overlap_rate(x(1)-w/2,x(1)+w/2,y(1)-h/2,y(1)+h/2,box3(1),box3(3),box3(2),box3(4));