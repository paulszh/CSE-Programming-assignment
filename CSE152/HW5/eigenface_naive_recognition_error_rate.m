%This function takes in both the label and image data of both training and
%testing images. The function returns a list of predicted labels as well as
%the test error rates. Within naive implementation, this method only use
%one nearest neighbor to label the image. 
function [predicted_label, error_rate] = eigenface_naive_recognition_error_rate(...
    trainset, trainlabel,testset, testlabel)
[H,W] = size(trainset);
[h1,w1] = size(testset);

predicted_label = zeros(h1,1);

for i = 1 : h1   %for each image in testset
   min = Inf;
   for j = 1 : H
       l2 = l2_norm(testset(i,:), trainset(j,:));
       %find the label with least l2 norm
       if(l2 < min)
            min = l2;
            predicted_label(i) = trainlabel(j);
       end
   end
end

%calcluate the error rate
error = 0;
for i = 1 : h1
    if(predicted_label(i) ~= testlabel(i))
       error = error + 1; 
    end
end

error_rate = double(error/h1);

end