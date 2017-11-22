function [filteredImage] = multiFreq(image, template)
     rotTemplate = imrotate(template,180);
    % multiply in the spatial
    [rl, cl] = size(image);
    [rt, ct] = size(template);
    fftImage = fft2(image, rl+ rt - 1, cl + ct - 1);
    fftTemplate = fft2(rotTemplate, rl + rt - 1, cl + ct - 1);
    ffImage = fftImage .* fftTemplate;
    filteredImage = ifft2(ffImage);
end