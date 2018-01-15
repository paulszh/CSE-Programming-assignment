function [im_seg] = mapValues(im, idx)
    feature = createDataset(im);
    %recalculating the centers
    calCenter = zeros(7,3);
    for j = 1 : 7 
        class = find(idx(:,1) == j); 
        calCenter(j,:) = mean(feature(class,:));
    end

    newImage = zeros(size(feature,1),size(feature,2));
    for i = 1 : 7
        seg = find(idx(:,1) == i); 
        for k = 1 : size(seg)
            newImage(seg(k),:)= calCenter(i,:);
        end
    end
    im_seg= reshape(newImage, [size(im,1),size(im,2),3]);
end