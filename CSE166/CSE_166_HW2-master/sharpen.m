function [ result ] = sharpen (image)
F1=[0 1 0;1 -4 1; 0 1 0];
I = imfilter(image,F1);
result = image-I;
end

