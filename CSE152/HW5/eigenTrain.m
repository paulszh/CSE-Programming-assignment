function [W,mu]=eigenTrain(trainset,k)
    %find the mena accross the row, mu is a column vector
    mu = mean(trainset,2); 
    [h,w] = size(trainset);

    mu_image = reshape(mu, 50,50);
    figure, imshow(mu_image,[]);

    n = size(trainset,2);
    D = zeros(h,w);
    for i = 1 : w
        D(:,i) = trainset(:,i) - mu;   %substracing the mean image for each column
    end

    [U,S,V] = svds(D,k);  
    W = U;
end