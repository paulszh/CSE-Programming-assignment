im = imread('white-tower.png');

% Create DataSet part
feature = createDataset(im);
rng(5);
nclusters = 7;
id = randi(size(feature, 1), 1, nclusters);
centers = feature(id, :);

%  KMeansClusters
[idx, centers] = kMeansCluster(feature, centers);

%  mapValues
im_seg = mapValues(im, idx);
tosave = figure;
imshow(uint8(im_seg));
saveas(tosave,'segImage_P3.jpg');
