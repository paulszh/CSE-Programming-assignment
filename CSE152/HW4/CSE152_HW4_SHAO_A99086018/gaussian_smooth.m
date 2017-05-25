function [filtered_image] = gaussian_smooth(image,sigma)
    
    [x,y] = meshgrid(-sigma*3:sigma*3, -sigma*3:sigma*3);

    kernel = exp(-(x.^2+y.^2)/(2*sigma*sigma))/(2* pi * sigma * sigma);
    
    sum(kernel(:)); %should be around 99.7%
    
% %     filtered_image=conv2(image,kernel,'same');
    filtered_image = imfilter(image,kernel,'conv','replicate');
end 
