A=imread('logo.jpg');
%First, convert the picture to grey scale
I = rgb2gray(A);
%imshow(I);
whos I
dim=size(I);
format shortg
rotateAboutCenterTransformation(640,480,pi/6)
T=rotateAboutCenterTransformation(dim(1),dim(2),pi/2);
%A scale matrix(for testing)
scale = [3 0 0; 0 2 0; 0 0 1];
Result = transformImageNearestNeighbor(I, T);
Result_1 = transformImageLinear(I,T);
imshow(Result);
figure
imshow(Result_1);
%imshow(Result_1);
    
  
