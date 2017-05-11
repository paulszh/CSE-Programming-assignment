% This function will recursively find all the connected componnets in the
% image
function [image_out] = find_connected_components(image_in)

   global marker;
   global mark;
   set(0, 'RecursionLimit', 1000);
   [h,w] = size(image_in);
   mark = zeros(h,w);
   marker = 0;
   for x = 1 : h
        for y = 1 : w
            if(image_in(x,y) == 1 && mark(x,y) == 0)
                marker = marker + 1; %update the label
                explore(x,y,image_in); %recursive steps
            end
        end
   end
    
  image_out = mark;
  disp(marker);
    
end

