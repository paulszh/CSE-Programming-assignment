function [uniformMSE, lloydMSE] = calculateMSE(inputImage)
    image = double(inputImage);
    [r1,c1] = size(image);

    uniformMSE = zeros(7,1);
    lloydMSE =zeros(7,1);
    trainSet = reshape(image, r1*c1, 1);

    for i = 1 : 7
        % perform the uniform Quantization for Lena      
        uniImage = uniformQuantization(image,i);
        diff = (double(uniImage) - image).^2;
        uniformMSE(i,1) = sum(diff(:))/(r1*c1);
         % perform the Lloyds for Lena and calcuate    
        [partition, codebook] = lloyds(trainSet, 2^i);
        Lloyds = imquantize(image, partition,codebook);
        diff = (Lloyds - image).^2;
        lloydMSE(i,1) = sum(diff(:)/(r1*c1));

    end
end