function [result] = l2_norm(v1, v2)
    result = sqrt(sum((v1 - v2).^2)); 
end