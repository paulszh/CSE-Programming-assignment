car = imread('car.tif');
tosave = figure;
imagesc(uint8(car));colormap gray;colorbar;
saveas(tosave, 'origin_car.jpg')
uk = [-90,-91,-85,-83];
vk = [-81,-168,86,171];
[imFFT, filteredImage, notchFilter, filterSpatialImage] = BNRFilter(3,25,uk,vk,car);
tosave = figure;
imagesc(-256:255,-256:255,log(abs(imFFT))); colorbar;
xlabel('u'); ylabel('v');
saveas(tosave,'imFFT_car.jpg');
tosave = figure;
imagesc(filterSpatialImage);colorbar
saveas(tosave,'filterSpatialImage_car.jpg');
tosave = figure;
imagesc(filterSpatialImage);colormap gray;colorbar;
saveas(tosave,'filterSpatialImage_car_gray.jpg');
tosave = figure;
imagesc(-256:255,-256:255,log(abs(notchFilter))); colorbar;
saveas(tosave,'notchFilter_car.jpg');
tosave = figure;
imagesc(-256:255,-256:255,log(abs(fftshift(filteredImage)))); colorbar;
saveas(tosave,'filteredImage_car.jpg');


street = imread('street.png');
tosave = figure;
imagesc(street);colormap gray;colorbar;
saveas(tosave, 'origin_street.jpg')
uk = [0,166];
vk = [-170,0];
[imFFT, filteredImage, notchFilter, filterSpatialImage] = BNRFilter(4,30,uk,vk,street);

tosave = figure;
imagesc(-256:255,-256:255,log(abs(imFFT))); colorbar;
xlabel('u'); ylabel('v');
saveas(tosave,'imFFT_street.jpg');
tosave = figure;
imagesc(filterSpatialImage);colorbar
saveas(tosave,'filterSpatialImage_street.jpg');
tosave = figure;
imagesc(filterSpatialImage);colormap gray;colorbar;
saveas(tosave,'filterSpatialImage_street_gray.jpg');
tosave = figure;
imagesc(-256:255,-256:255,log(abs(notchFilter))); colorbar;
saveas(tosave,'notchFilter_street.jpg');
tosave = figure;
imagesc(-256:255,-256:255,log(abs(fftshift(filteredImage)))); colorbar;
saveas(tosave,'filteredImage_street.jpg');

