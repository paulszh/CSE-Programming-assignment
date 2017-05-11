% This function takes in an binary image and calculate it's raw moment
function [output] = moment(input,j,k,d)
  [h,w] = size(input);
   M = 0;
    
    for x = 1 : h
        for y = 1 : w
             if input(x,y) == d
                M = M + (input(x,y) * x^j * y^k);  
             end
        end
    end
    
%     fprintf('height, width: %d, %d\n',h,w);   
    output = M;


end