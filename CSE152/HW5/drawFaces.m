function [ img ] = drawFaces(imgs, cols)
    if nargin < 2, cols = size(imgs,1); end
    w = 50;
    h = 50;
    n = 1;
    
    rows = ceil(size(imgs,1)/cols);
    img = zeros(h*rows, w*cols);
    for i=1:rows
        for j=1:cols
            if n <= size(imgs,1)
                img(((i-1)*h+1):((i)*h), ((j-1)*w+1):((j)*w)) = reshape(imgs(n,:),h,w);
                n = n + 1;
            end
        end
    end
end

