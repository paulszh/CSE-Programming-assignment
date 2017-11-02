image = imread('circles_lines.jpg');
image = rgb2gray(image);        %do we need to convert to gray scale first?
image = imbinarize(image);
imshow(image);

SE = strel('disk',5);
circle = imopen(image,SE);
write = figure;
imshow(circle);
saveas(write,'circle_only.jpg')

%find the connected components
ccCircles = bwlabel(circle);
write = figure;
imagesc(ccCircles);
saveas(write,'connect_component_circles.jpg');

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


imageLine = imread('lines.jpg');
imageLine = imbinarize(rgb2gray(imageLine),0.4);
SE = strel('line',20,90);
line = imopen(imageLine,SE);
write = figure;
imshow(line);
saveas(write, 'line_only.jpg');

ccLines = bwlabel(line);
write = figure;
imagesc(ccLines);
saveas(write, 'connected_component_lines.jpg');

%calculate the area for each connected componenets
numElement = max(ccLines(:));
lineArea = zeros(numElement,1);
lineLength = zeros(numElement,3);

%looping through the line image and find the area for each connected
%componenets
for x = 1 : size(ccLines,1)
    for y = 1 : size(ccLines, 2)
        if ccLines(x,y) ~= 0
            lineArea(ccLines(x,y),1) = lineArea(ccLines(x,y),1) + 1;
            if lineLength(ccLines(x,y),1) == 0 
                lineLength(ccLines(x,y),1) = x;
                lineLength(ccLines(x,y),2) = x;
            else
                if(x < lineLength(ccLines(x,y),1))
                    lineLength(ccLines(x,y),1) = x;
                else
                    lineLength(ccLines(x,y),2) = x;
                end
            end
        end
    end
end
% 
% calculating the length
for i = 1 : numElement
    lineLength(i,3) = lineLength(i,2) - lineLength(i,1);
end

