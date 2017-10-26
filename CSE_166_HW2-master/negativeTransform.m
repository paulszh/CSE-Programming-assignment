function [ result ] = negativeTransform(image, L)
dim = size(image);
w_1 = dim(2); % w_1 -> y value
h_1 = dim(1); % h_1 -> x value
result = uint8(zeros(h_1,w_1));
disp(h_1);
disp(w_1);
for x=1:h_1
    for y=1:w_1
        result(x,y) = L - 1 - image(x,y);
    end 
end

end

