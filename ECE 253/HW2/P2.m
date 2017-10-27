image = imread('circles_lines.jpg');
image = rgb2gray(image);        %do we need to convert to gray scale first?
imshow(image);

SE = strel('disk',5);
circle = imopen(image,SE);
figure,imshow(circle);

%find the connected components
ccCircles = bwlabel(circle);

%calculate the area for each connected componenets
numElement = max(ccCircles(:));
circleArea = zeros(numElement,1);
circleCentroid = zeros(numElement,2);

%looping through the circle image and find the area for each connected
%componenets
for x = 1 : size(ccCircles,1)
    for y = 1 : size(ccCircles, 2)
        if ccCircles(x,y) ~= 0
            circleArea(ccCircles(x,y),1) = circleArea(ccCircles(x,y),1) + 1;
            circleCentroid(ccCircles(x,y),1) =  circleCentroid(ccCircles(x,y),1) + x;
            circleCentroid(ccCircles(x,y),2) =  circleCentroid(ccCircles(x,y),2) + y;
        end
    end
end

% calculating the centroid
for i = 1 : numElement
   circleCentroid(i,1) =  circleCentroid(i,1)/circleArea(i,1);
   circleCentroid(i,2) =  circleCentroid(i,2)/circleArea(i,1);
end
    
    

