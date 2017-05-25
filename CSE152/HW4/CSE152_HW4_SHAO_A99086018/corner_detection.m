function [top_n_points] = corner_detection(image, sigma,Ix,Iy,n)
    
[h,w] = size(image);
Ix = Ix(1:h,1:w);
Iy = Iy(1:h,1:w);

width = ones(2*sigma + 1,2*sigma +1);
Ix2 = conv2(Ix.* Ix,width,'same');
Iy2 = conv2(Iy.* Iy,width,'same');
Ixy2 = conv2(Ix.*Iy, width, 'same');

lambda = zeros(h,w);
corner = zeros(0);

for x = 1 : h
    for y = 1 : w
        C = [Ix2(x,y), Ixy2(x,y); Ixy2(x,y), Iy2(x,y)];
        V = eig(C);
        lambda(x,y) = min(V);
    end
end

for x = 1 : h
    for y = 1 : w       
        if(1 == check_neighbor(lambda,x,y))
            %get ride of the points at the corner
            if(y < w-10) && (x < h-10) && (x>10) && (y>10)
                corner = [corner;[lambda(x,y),x,y]];
            end
        end
    end
end

sort_corner = sortrows(corner,-1);

figure,imshow(image);
hold on;
top_n_points = zeros(n,2);

for i = 1 : n
        top_n_points(i,1) = sort_corner(i,2);
        top_n_points(i,2) = sort_corner(i,3);
        drawPoint([sort_corner(i,3),sort_corner(i,2)]);

end

hold off;
    
end
