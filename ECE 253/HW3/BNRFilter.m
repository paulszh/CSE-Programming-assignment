function [imFFT, filteredImage, notchFilter,filterSpatialImage] = BNRFilter(n,r,uk,vk,input)
    fftCar = fft2(input,512,512);
    imFFT = fftshift(fftCar);
    [u,v] = meshgrid(-256:255);

    notchFilter = ones(size(u,1),size(u,2));
    for i = 1 : size(uk,2)
        dkPos = sqrt((u-uk(i)).^2 + (v-vk(i)).^2);
        dkNeg = sqrt((u+uk(i)).^2 + (v+vk(i)).^2);
        notchFilter = notchFilter .* (1./(1+((r./dkPos).^(2*n)))) .* (1./(1+((r./dkNeg)).^(2*n)));
    end

    % filter the image in frequency domain
    filteredImage = fftCar .* fftshift(notchFilter);
    filterSpatialImage = ifft2(filteredImage);
    maxIntensity = max(filterSpatialImage( : ));
    filterSpatialImage = uint8((filterSpatialImage./maxIntensity)*255);
    filterSpatialImage = filterSpatialImage(1 : size(input,1),1:size(input,2));
end