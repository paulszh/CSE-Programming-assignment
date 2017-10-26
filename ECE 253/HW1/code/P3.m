clear
image = double(imread('geisel.jpg'));

result = compute_norm_rgb_histogram(image);
redX = 1 : 32;
redY = result(1:32);
greenX = 33 : 64; 
greenY = result(33:64);
blueX = 65 : 96;
blueY = result(65:96);
%Plot the graph
figure,bar(redX,redY,'r');
hold on
bar(greenX, greenY, 'g');
hold on
bar(blueX, blueY, 'b');
xlabel('bin numbers') % x-axis label
ylabel('normalized intensity') % y-axis label
title('Histogram');