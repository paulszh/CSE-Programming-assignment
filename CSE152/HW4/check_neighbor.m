function [isMax] = check_neighbor(lambda,x,y)
    [h,w] = size(lambda);
    maximum = 0;
    for i = -1 : 1
        for j = -1 : 1
            if(i == 0 && j ==0) 
                continue;
            else
                if(x + i > 0) && (y+j> 0) && (x + i <= h) && (y+j <= w)
                    if(lambda(x+i,y+j) > maximum)
                        maximum = lambda(x+i,y+j);
                    end
                end
            end
        end
        
    end
    
    if(maximum == lambda(x,y))
        isMax = 1;
    else
        isMax = 0;
    end

end