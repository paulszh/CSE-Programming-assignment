%The function that using otus method to binarize an input image
function [ result_image] = binarization_otus(input_image)
 
w = histcounts(input_image,256);
[height,width] = size(input_image);
pixel_number = height * width;
result_image = false(height,width); %initalize the result_image to black

w0 = 0;
maximum = 0.0;
sum = 0;
sum0 = 0;
level = 0;
%calculaing sum i * p(i)
for i = 1 : 256
   sum = sum + w(i) * (i-1);
end

for t=1:256
    w0 = w0 + w(t);
    if (w0 == 0)
        continue;
    end
    w1 = pixel_number - w0;

    sum0 = sum0 +  (t-1) * w(t);
    mu0 = sum0 / w0;
    mu1 = (sum - sum0) / w1;
    threshold = w0 * w1 * (mu0 - mu1)^2;
    %update the threshold 
    if (threshold >= maximum)
        level = t;
        maximum =  threshold;
    end
end

% disp(level);
% disp(maximum);

%set all the pixel less than the threshold to 0 
for x = 1 : height
    for y = 1 : width
        if(input_image(x,y) < level)
            result_image(x,y) = 0;
        else
            result_image(x,y) = 1;
        end
    end
end

end

