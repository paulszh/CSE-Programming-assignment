function [Ix,Iy] = calculate_gradient(blurred_image)
    
    dx = [-0.5, 0, 0.5];
    dy = [-0.5, 0, 0.5]';
    
    Ix = xcorr2(blurred_image,dx);
    Iy = xcorr2(blurred_image,dy);
   
end