function [predicted_label,error_rate] = eigen_naive_recognition_error_rate(...
    trainset, trainlabel,testset, testlabel,k)
  
    testset_k = testset(:,1:k);
    trainset_k = trainset(:,1:k);
    H = size(trainset_k,1);
    h1 = size(testset_k,1);
    predicted_label = zeros(h1,1);
   

    for i = 1 : h1   %for each image in testset
       min = Inf;
       for j = 1 : H
           l2 = l2_norm(testset_k(i,:), trainset_k(j,:));
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