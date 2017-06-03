%This function takes in both the label and image data of both training and
%testing images. The function returns a list of predicted labels as well as
%the predictiion error rate. Unlike the naive implementation, this function
%uses more than one neighbors to label the images, resulting in a lower test
%error in practice. Also this function can use either l2 or l1 norm during 
%it calculation

function [predicted_label, error_rate] = knn_recognition_error_rate(trainset, trainlabel,testset, testlabel,k,l)
[H,W] = size(trainset);
[h1,w1] = size(testset);

predicted_label = zeros(h1,1);
temp_label = zeros(H,2);
top_k = zeros(k,1);

for i = 1 : h1 
   for j = 1 : H
%        record the Euclidean distance as well as it's corresponding image
%        label in train set
       if l == 2
            temp_label(j,1) = l2_norm(testset(i,:), trainset(j,:));
       else 
            temp_label(j,1) = l1_norm(testset(i,:), trainset(j,:));
       end
       temp_label(j,2) = trainlabel(j);
   end
   temp_label = sortrows(temp_label,1);
   for t = 1 : k
       top_k(t) = temp_label(t,2);
   end
   predicted_label(i) = mode(top_k(:));     
end

error = 0;
for i = 1 : h1
    if(predicted_label(i) ~= testlabel(i))
       error = error + 1; 
    end
end
disp(error);
error_rate = double(error/h1);

end