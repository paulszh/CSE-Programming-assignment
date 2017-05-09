function [output] = central_moment(input,j,k,d)
    x_avg = (moment(input,1,0,d))/(moment(input,0,0,d));
    y_avg = (moment(input,0,1,d))/(moment(input,0,0,d));
    
    [h,w] = size(input);
    M = 0;
    
    for x = 1 : h
        for y = 1 : w
          if input(x,y) == d
            M = M + input(x,y) * (x-x_avg)^j * (y-y_avg)^k;  
          end
        end
    end
    
    output = M;
    
    
end