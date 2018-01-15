function [idx, centers] = kMeansCluster(features, centers)

maxIter = 100;
[num,rgb] = size(features);
class = zeros(num,1);
dist = zeros(num,7);
newCenter = zeros(7,3);
for i = 1 : maxIter
    dist(:,1:7) = pdist2(double(features(:,:)),double(centers(1:7,:)));
    [val, col]= min(dist, [], 2);
    class(:,1) = col(:);
  
    for j = 1 : 7
        index = find(class(:,1) == j); 
        newCenter(j,:) = mean(features(index,:));
    end 
    if (isequal(centers,newCenter))
        display(i);
        break;
    end
    centers = newCenter;
end

idx = class;
end