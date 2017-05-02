function [result] = rotate_img(src, r)
    dim = size(src);
    h = dim(1);
    w = dim(2); 
    
    if r == pi/2    %rotating 90 degrees
        for i = 1 : 3
            for x = 1 : h
                for y = 1 : w
                    result(w-y+1,x,i) = src(x,y,i);
                end
            end
        end
    elseif r == pi  %rotating 180 degrees
        for i = 1 : 3
            for x = 1 : h
                for y = 1 : w  
                    result(h-x+1,w-y+1,i)=src(x,y,i);
                end
            end
        end
    elseif r == (pi*3)/2  %rotating 180 degrees
        for i = 1 : 3
            for x = 1 : h
                for y = 1 : w
                    result(y, h - x + 1,i) = src(x,y,i);
                end
            end
        end
    else %default case: the image remains the same
        for i = 1 : 3
            for x = 1 : h
                for y = 1 : w
                    result(x,y,i) = src(x,y,i); %make a copy of source img
                end
            end
        end
    end
end