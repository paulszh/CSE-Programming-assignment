function [output] = gaussianUnblur(im_in, sigma, max_iter, t)
    k = 0;
    im_prev = im_in;
    [r,c] = size(im_in);
    while(k < max_iter)
        A = gaussianBlur(im_prev,sigma);
        B = im_in./A;
        C = gaussianBlur(B,sigma);
        im_curr = im_prev .* C;
        k = k + 1;
        MSE = sum(sum((im_curr - im_prev).^2))/(r*c);
        if (MSE < t)
            disp('converge')
            break;
        end 
        im_prev = im_curr;
    end
    output = im_curr;
end