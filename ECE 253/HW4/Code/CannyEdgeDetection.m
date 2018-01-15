image = rgb2gray(imread('geisel.jpg'));
% A gaussian kernel with o = 1.4
kernel = double(1/(159)).*[2, 4, 5, 4, 2; 
    4, 9, 12, 9, 4; 
    5, 12, 15, 12, 5; 
    4, 9, 12, 9, 4;
    2, 4, 5, 4, 2];
filtered_image = double(imfilter(image,kernel));
k_x = [-1, 0, 1; -2, 0, 2; -1, 0, 1]; 
k_y = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

g_x = double(imfilter(filtered_image,k_x));
g_y = double(imfilter(filtered_image,k_y));
mag = sqrt(g_x.^2 + g_y.^2);
dir = atan2(g_y,g_x);
neg_dir = (dir./pi) * 180;
% round to cloest 45
% dir = double(136/180) * pi; %for testing
dir(dir<0) = dir(dir<0) + pi;
angle = mod(dir, pi/4);
if (angle > pi / 8) 
    round = (dir - angle) + pi/4; 
else
    round = dir - angle;
end

angle = 180 * round./pi;
tosave = figure;
imshow(uint8(mag));
saveas(tosave, 'magimage_p1.jpg');

% non maximum suppression: 
[row, col] = size(angle);
supImage = zeros(row,col);
for i = 2 : row-1 
    for j = 2 : col-1
        if (angle(i,j) == 0)
            if (mag(i,j) > mag(i,j-1) && mag(i,j) > mag(i,j+1))
                supImage(i,j) = mag(i,j);
            end
        elseif (angle(i,j) == 45)
            if (mag(i,j) > mag(i+1,j-1) && mag(i,j) > mag(i-1,j+1))
                supImage(i,j) = mag(i,j);
            end
        elseif (angle(i,j) == 90)
            if (mag(i,j) > mag(i-1,j) && mag(i,j) > mag(i+1,j))
                supImage(i,j) = mag(i,j);
            end
        elseif (angle(i,j) == 135)
            if (mag(i,j) > mag(i+1,j+1) && mag(i,j) > mag(i-1,j-1))
                supImage(i,j) = mag(i,j);
            end
        end 
    end
end

intImage = uint8(supImage);
threshImage = zeros(row,col);
% supImage = supImage * mag;
tosave = figure;
imshow(uint8(supImage));
saveas(tosave, 'nmsimage_p1.jpg');

for i = 1 : row
    for j = 1 : col
        if (supImage(i,j) > 72) 
            threshImage(i,j) = supImage(i,j);
        end
    end
end
tosave = figure;
imshow(uint8(threshImage));
saveas(tosave, 'theimage_p1.jpg');




        
