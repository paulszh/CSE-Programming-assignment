function  [result] = gussianBlur(im_in, sigma)
    h = fspecial('gaussian', 6*sigma, sigma);
    result = imfilter(im_in, h, 'conv', 'circular');
end