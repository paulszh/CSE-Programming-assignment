function gaussianUnblurHelper(orig, im_in, sigma, max_iter, t)
    k = 1;
    im_prev = im_in;
    [r,c] = size(im_in);
    while(k <= max_iter)
        A = gaussianBlur(im_prev,sigma);
        B = im_in./A;
        C = gaussianBlur(B,sigma);
        im_curr = im_prev .* C;
      
        MSE = sum(sum((im_curr - im_prev).^2))/(r*c);
        res_l(k) = MSE;
        mse_l(k) = sum(sum((im_curr - orig).^2))/(r*c);
        k = k + 1;
        if (MSE < t)
            disp('converge')
            break;
        end 
        im_prev = im_curr;
    end
    
    %plot
    figure,semilogy(1:k-1, res_l)
    hold on;
    semilogy(1:k-1, mse_l);
    legend ('Residual','MSE') ;
    hold off;
end