%This follwoing function takes in a ratation angle(in radian), calculate 
% the rotational matrix and apply it to the original image. 
%The function will output a rotated image at the end

function [ result ] = rotateAboutCenter(src, r)

dim  = size(src);
h = dim(1);
w = dim(2);
theta = r;

R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
t_x = -h/2 - 0.5; %calculating the offset of the origin
t_y = -w/2 - 0.5;
t = [t_x t_y]';
t = (R*t) - t;

% T is the rotational matrix
T = [cos(theta) -sin(theta) t(1); sin(theta) cos(theta) t(2); 0 0 1];


result = uint8(zeros(h,w,3));


for i = 1:3
    for x=1:h
        for y=1:w
                vec=[x;y;1];
                newVec= T\vec;
                x_n = round(newVec(1,1));
                y_n = round(newVec(2,1));
                
                if x_n > 0 && y_n > 0 && x_n <= h  && y_n <= w
                       result(x,y,i) = src(x_n, y_n, i);
                end
             

        end
    end 
end 
   
end
