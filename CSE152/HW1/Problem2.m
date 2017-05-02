logo = imread('vertical.jpeg');

%rotating 0 degrees
rotate0 =  rotate_img(logo, 0);
figure, imshow(rotate0);
imwrite(rotate0,'rotated0.png');

%rotating 90 degrees;
rotate90 = rotate_img(logo, pi/2);
figure, imshow(rotate90);
imwrite(rotate90,'rotated90.png');

%rotating 180 degrees;
rotate180 = rotate_img(logo, pi);
figure, imshow(rotate180);
imwrite(rotate180,'rotated180.png');

%rotating 270 degrees;
rotate270 = rotate_img(logo, pi*3/2);
imwrite(rotate270,'rotated270.png');
figure, imshow(rotate270);