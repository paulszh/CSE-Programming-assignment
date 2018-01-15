function [feature] = createDataset(im)
    [row,col,rgb] = size(im);
    feature = reshape(im, [row*col,3]);
end 