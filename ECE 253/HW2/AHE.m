% This function is designed to perform the adaptive histgram equalization
% Before the operation, it will first pad the image based on the window
% size
% for each pixel, it will perform histogram equalization around the certain
% regions. The region is defined to be a square , it's size always equals
% to win_size
function [output] = AHE(image, win_size)
    %pad the image based on the window size
    pad_size = floor(win_size/2);
    paddedImage = padarray(image, [pad_size,pad_size], 'symmetric');
    [height,width] = size(paddedImage);
    output= uint8(zeros(size(image,1), size(image, 2)));
    %perform Adaptive histogram equalization
    for x =  1 + pad_size : height - pad_size
        for y = 1 + pad_size  : width - pad_size
            rank = 0;
            %iterate through the window around certer pixel
            for i = x - pad_size :  x + pad_size
                for j = y - pad_size : y + pad_size
                    if paddedImage(x,y) > paddedImage(i,j)
                        rank = rank + 1;
                    end
                end 
            end
            intensity = 255 * (rank/(win_size * win_size));
            output(x- pad_size, y - pad_size) = intensity;
        end
    end
end