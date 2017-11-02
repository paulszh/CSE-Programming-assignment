lena = imread('lena512.tif');
diver = imread('diver.tif');

figure, imshow(lena);
figure, imshow(diver);
% figure,imshow(uniformQuantization(lena,4));
% figure, imshow(uniformQuantization(diver,4));

% temp = uniformQuantization(lena,4);
% lena = double(lena);
% [r1,c1] = size(lena);
% 
% lenaUniformMSE = zeros(7,1);
% lenaLloydMSE =zeros(7,1);
% trainSetLena = reshape(lena, r1*c1, 1);
% 
% for i = 1 : 7
%     % perform the uniform Quantization for Lena      
%     uniImageLena = uniformQuantization(lena,i);
%     diff = (double(uniImageLena) - lena).^2;
%     lenaUniformMSE(i,1) = sum(diff(:))/(r1*c1);
%      % perform the Lloyds for Lena and calcuate    
%     [partition, codebook] = lloyds(trainSetLena, 2^i);
%     lenaLloyds = imquantize(lena, partition,codebook);
%     diff = (lenaLloyds - lena).^2;
%     lenaLloydMSE(i,1) = sum(diff(:)/(r1*c1));
%      
% end
x = 1 : 1 :7;
[lenaUniformMSE, lenaLloydMSE] = calculateMSE(lena);
figure,bar(x, [lenaUniformMSE, lenaLloydMSE]);
title('lena MSE');
[diverUniformMSE, diverLloydMSE] = calculateMSE(diver);
figure,bar(x, [diverUniformMSE, diverLloydMSE]);
title('diver MSE');

lenahistEq = histeq(lena,256);
diverhistEq = histeq(diver,256);
[histLenaUniformMSE, histLenaLloydMSE] = calculateMSE(lenahistEq);
figure,bar(x, [histLenaUniformMSE, histLenaLloydMSE]);
title('lena MSE after histeq');
[histDiverUniformMSE, histDiverLloydMSE] = calculateMSE(diverhistEq);
figure,bar(x, [histDiverUniformMSE, histDiverLloydMSE]);
title('diver MSE after histeq');


% trainSet1 = reshape(lena, Size(lena,1) * Size(lena,2), );
% trainSet2 = reshape(lena, Size(driver,1) * );