%This function takes in both the label and image data of both training and
%testing images. The function returns a list of predicted labels as well as
%the test error rates. Within naive implementation, this method only use
%one nearest neighbor to label the image. 
function [predicted_label_k, error_rate_k] = eigenTest(...
    trainset, trainlabel,testset,testlabel,U,mu,k)

    pc_score_train = project_to_k_dimension(trainset',mu,U);
    pc_score_test = project_to_k_dimension(testset',mu,U);
    
    %The predicted labels for k 1 : 20, labels are stored as column vectors
    predicted_label_k = zeros(size(testlabel,2),k); 
%     disp(size(predicted_label_k));
    error_rate_k = zeros(k,1); %an array holding all the error rate for k = 1 : 20    
    
    for i = 1 : k
       
        [labels, error] = eigen_naive_recognition_error_rate(pc_score_train',trainlabel,pc_score_test',testlabel,i);
        predicted_label_k(:,i) = labels;
        error_rate_k(i) = error;
    end
end