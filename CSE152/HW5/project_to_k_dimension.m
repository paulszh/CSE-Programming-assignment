function [reduced_image] = project_to_k_dimension(imageset,mu,U)
    [h,w] = size(imageset);
    D = zeros(h,w);
    for i = 1 : w
        D(:,i) = imageset(:,i) - mu;   %substracing the mean image for each column
    end
    
    reduced_image = U' * D; 
end