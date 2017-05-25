function [isMax] = check_neighbor(lambda,x,y)
    [h,w] = size(lambda);
    maximum = lambda(x,y);
    count = 0;
    for i = -1 : 1
        for j = -1 : 1
            if(i == 0 && j ==0) 
                continue;
            else
                if(x + i > 0) && (y+j> 0) && (x + i <= h) && (y+j <= w)
                    if(lambda(x+i,y+j) <= maximum)
                       count = count +1;
                    end
                end
            end
        end
        
    end
    if(count == 8)
        isMax = 1;
    else
        isMax = 0;
    end
    

end