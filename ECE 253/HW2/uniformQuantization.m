function [compressedImage] = uniformQuantization(inputImage, s)
%     inputImage = double(inputImage);
    interval = 2^8/2^s;
    [h,w] = size(inputImage);
    compressedImage = zeros(h,w);
    for x = 1 : size(inputImage,1)
        for y = 1 : size(inputImage,2)
            compressedImage(x,y) = floor(inputImage(x,y)/interval) * interval + 0.5 * interval; 
        end
    end
    compressedImage = uint8(compressedImage);
end