lena = imread('lena512.tif');
diver = imread('diver.tif');

% figure, imshow(lena);
% figure, imshow(diver);
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
%Lena with no histogram equalization
[lenaUniformMSE, lenaLloydMSE] = calculateMSE(lena);
bar_pic = figure;
plot(x, [lenaUniformMSE,lenaLloydMSE]);
title('lena MSE');
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_lena_plot_MSE.jpg')
bar_pic = figure;
bar(x, [lenaUniformMSE,lenaLloydMSE]);
title('lena MSE');
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_lena_bar_MSE.jpg')



[diverUniformMSE, diverLloydMSE] = calculateMSE(diver);
bar_pic = figure;
plot(x, [diverUniformMSE, diverLloydMSE]);
title('diver MSE');
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_diver_plot_MSE.jpg')
bar_pic = figure;
bar(x, [diverUniformMSE, diverLloydMSE]);
title('diver MSE');
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_diver_bar_MSE.jpg')

lenahistEq = histeq(lena,256);
diverhistEq = histeq(diver,256);
[histLenaUniformMSE, histLenaLloydMSE] = calculateMSE(lenahistEq);
bar_pic = figure;
semilogy(x, [histLenaUniformMSE, histLenaLloydMSE]);
title('lena MSE after histeq, scale thh y with log function');
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_lena_plot_hist_MSE.jpg')
bar_pic = figure;
bar(x, [histLenaUniformMSE, histLenaLloydMSE]);
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_lena_bar_hist_MSE.jpg')

[histDiverUniformMSE, histDiverLloydMSE] = calculateMSE(diverhistEq);
bar_pic = figure;
semilogy(x, [histDiverUniformMSE,histDiverLloydMSE]);
title('diver MSE after histeq, scale the y with log function');
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_diver_plot_hist_MSE.jpg')
bar_pic = figure;
bar(x, [histDiverUniformMSE,histDiverLloydMSE]);
legend('uniform', 'Lloyd-max');
saveas(bar_pic ,'p3_diver_bar_hist_MSE.jpg')
