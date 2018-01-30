function [ result ] = histogramEqualization(image)
dim = size(image);
w=dim(2); % w_1 -> y value
h=dim(1); % h_1 -> x value
numberOfPixel = w * h;
result = uint8(zeros(h,w));
pixelIntensityArray = zeros(1,256);
newPixelArray = zeros(1,256);
pdf = zeros(1,256);
cdf = zeros(1,256);

    for x=1:h
        for y=1:w
            pixelIntensityArray(1,(image(x,y)+1)) =  pixelIntensityArray(1,(image(x,y)+1)) + 1;
        end
    end
    
    for i=1:256
        pdf(1,i) = pixelIntensityArray(1,i)./numberOfPixel;
    end
    
     sum = 0;  
     for k=1:256
        cdf(1,k) = sum + pdf(1,k);
        sum = cdf(1,k); 
        newPixelArray(1,k) = round(cdf(1,k) * 255);
     end
     
    for a=1:h
        for b=1:w
            result(a,b) =  newPixelArray(1,(image(a,b)+1));
        end
        
    end
    
    
end

