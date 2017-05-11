function [output] = central_moment(input,j,k,d)
    x_avg = double((moment(input,1,0,d))/(moment(input,0,0,d)));
    y_avg = double((moment(input,0,1,d))/(moment(input,0,0,d)));
    
    [h,w] = size(input);
    M = 0;
    
    for x = 1 : h
        for y = 1 : w
          if input(x,y) == d
            M = M + input(x,y) * (x-x_avg)^j * (y-y_avg)^k;  
          end
        end
    end
    
    fprintf('x_avg,y_avg %d, %d\n', x_avg,y_avg);
    output = M;
    
   
end