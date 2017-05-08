function [image_out] = find_connected_components(image_in)
%    set(0, 'RecursionLimit', 1000);
   global marker;
   global mark;
   [h,w] = size(image_in);
   mark = ones(h,w);
   mark = -mark;
   marker = 0;
   for x = 1 : h
        for y = 1 : w
            if(image_in(x,y) == 1 && mark(x,y) == -1)
                marker = marker + 1;
                disp(marker);
                explore(x,y,image_in);
            end
        end
   end
    
  image_out = mark;
    
end

