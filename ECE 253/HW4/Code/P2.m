clear
testImage = false(11,11);
testImage(1,1) = 1;  %1
testImage(1,11) = 1; %2
testImage(6,6) = 1;  %3
testImage(11,1) = 1; %4
testImage(11,11) = 1;%5
tosave = figure;
imagesc(testImage),colorbar,colormap gray;
saveas(tosave,'testImage.jpg');

[r,c] = size(testImage);
theta = (-pi/2: pi/180 :pi/2);
p = (-norm([r,c]): 1 : norm([r,c]));
houghSpace = HoughTransfomation(testImage,theta,p,1);
HT = false(size(houghSpace,1), size(houghSpace,2));
HT((houghSpace(:) > 0)) = 1;
tosave = figure;
imagesc(HT),colorbar, colormap gray;
saveas(tosave,'HT_testImage.jpg');
%Problem 1, only looking for any (?, ?) cells that contains more than 2 votes
thesImage = (houghSpace > 2);
[ro,t] = find(thesImage);
tosave = figure;
imagesc(testImage),colormap gray;
hold on
for i = 1 : size(t,1)
    th = theta(t(i));
    rh = p(ro(i));
    hold on;
    plot(-cos(th)/sin(th)*(1 : c)+rh/sin(th),1 : c);
end
hold off;
saveas(tosave,'testImagewithLine.jpg');
%% ii
im = imread('lane.png');
im = rgb2gray(im);
tosave = figure;
imshow(im);
saveas(tosave,'original.jpg');

E = edge(im,'sobel');
tosave = figure;
imshow(E);
saveas(tosave,'original_edge_image.jpg');

[r,c] = size(E);
theta = (-pi: pi/180 :pi);
p = (-norm([r,c]): 1 : norm([r,c]));
houghSpace = HoughTransfomation(E,theta,p,2);


%% iii
tosave = figure;
imagesc(houghSpace),colorbar, colormap gray;
saveas(tosave, 'HT_E_P2.jpg');

threshold = 0.75 * max(houghSpace(:));
thresImage = (houghSpace > threshold);
[ro,t] = find(thresImage);
tosave = figure;
imagesc(im),colormap gray;
hold on
for i = 1 : size(t,1)
    th = theta(t(i));
    rh = p(ro(i));
    hold on;
    plot(-cos(th)/sin(th)*(1 : c)+rh/sin(th),1 : c, 'linewidth', 3);
end
hold off;
saveas(tosave, 'imagewithline_iii.jpg');

%% iv 
tosave = figure;
imagesc(im),colormap gray;
hold on
for i = 1 : size(t,1)
    th = theta(t(i));
    rh = p(ro(i));
    hold on;
    if (th > -1 && th < -0.62)
        plot(-cos(th)/sin(th)*(1 : c)+rh/sin(th),1 : c, 'linewidth', 3);
    end 
    if (th > 0.63 && th < 1)
        plot(-cos(th)/sin(th)*(1 : c)+rh/sin(th),1 : c, 'linewidth', 3);
    end 
end
hold off;

saveas(tosave, 'imagewithline_iv.jpg');
