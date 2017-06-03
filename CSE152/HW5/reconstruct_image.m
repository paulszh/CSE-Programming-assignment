function [result] = reconstruct_image(U, k, mu,pc)
    
    temp = mu;
    for i = 1 : k
        temp = temp + pc(i)*U(:,i);        
    end
    result = reshape(temp,50,50);
end 