function [output] = blueOrSharpen(in_im, w, sigma)
    if(w < -1 || w > 1)
        disp('Invalid w value');
        output = in_im;
    end
    input = in_im;
    output = (1 + w).*input - w.* gaussianBlur(input,sigma);
end