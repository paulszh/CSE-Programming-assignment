function [result] = l1_norm(v1, v2)
    result = sqrt(sum(abs(v1 - v2))); 
end