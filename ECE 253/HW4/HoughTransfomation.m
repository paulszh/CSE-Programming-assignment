function [houghSpace] = HoughTransfomation(testImage,theta, p, a)
    [r,c] = size(testImage);  
    sizeTheta = size(theta,1) * size(theta,2);
    sizeP = size(p,1) * size(p,2);
    houghSpace = uint8(zeros(sizeP, sizeTheta));
    [x,y] = find(testImage);
    for i = 1 : size(x,1)
        angle = 1;
        for j = -(pi*a)/2: pi/180 :(pi*a)/2
            rho = round(x(i).*cos(j) + y(i).*sin(j) + (norm([r,c])) + 1);
            houghSpace(rho,angle) = houghSpace(rho,angle) + 1;
            angle = angle + 1;
        end
    end
end