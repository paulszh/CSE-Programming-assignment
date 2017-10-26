function [result] = compute_norm_rgb_histogram(image)
    rgbChannel = zeros(32,3);
    [m,n,rgb] = size(image);
    for x = 1 : size(image,1)
        for y = 1 : size(image,2)
            for i = 1 : 3
                bin = floor(image(x,y,i)/8);
                rgbChannel(bin+1,i) = rgbChannel(bin+1,i) + 1;
            end
        end
    end
    normalized = rgbChannel/(m*n*rgb);
    result  = reshape(normalized, 1, 96);
end