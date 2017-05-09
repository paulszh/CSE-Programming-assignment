function [] = explore(x,y,image)
   global marker;
   global mark;
  
   set(0, 'RecursionLimit', 1000);
   [h,w] = size(image);
   mark(x,y) = marker;
 
   %iterate through the neighbors
   for i = -1 : 1
        for j = -1 : 1
            if(i == 0) && (j == 0)
                continue;
            else 
                if(x + i > 0) && (y + j > 0) && (x + i <= h) && (y + j <= w)
                    if(image(x+i,y+j) == 1 && mark(x+i,y+j) == 0)
                        explore(x+i,y+j,image);
                    end
                end
            end
        end
        
   end
    
   return;
end 