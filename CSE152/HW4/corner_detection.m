function [] = corner_detection(image, num, Ix, Iy, w)
    
    window = ones(w,w);
    Ix2 = conv2(Ix.^2,w,'same');
    Iy2 = conv2(Iy.^2,w,'same');
    Ixy2 = conv2(Ix.* Iy, w, 'same');
    
    C = [Ix2, Ixy2; Iy^2, Ixy2];
    
    [H,V] = eig(C);
    
    
    
    
end
