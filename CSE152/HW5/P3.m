clear; 
%load the data from input file
[trainset, trainlabel]=loadSubset(0);
[testset_1,testlabel_1] = loadSubset(1);
[testset_2,testlabel_2] = loadSubset(2);
[testset_3,testlabel_3] = loadSubset(3);
[testset_4,testlabel_4] = loadSubset(4);

%for this calculating all the images are represented as column vector
trainset = trainset';
trainlabel = trainlabel';
testset_1 = testset_1';
testlabel_1 = testlabel_1';
testset_2 = testset_2';
testlabel_2 = testlabel_2';
testset_3 = testset_3';
testlabel_3 = testlabel_3';
testset_4 = testset_4';
testlabel_4 = testlabel_4';

%problem 3.1 
[U,mu] = eigenTrain(trainset,20);       %1/n-1???

combined_image = zeros(500,100);

%Problem 3.2 calculating the eigenfaces
count = 1;
for i = 1 : 10
    combined_image((i-1)*50+1:i*50,1:50) = reshape(U(:,count),50,50);
    combined_image((i-1)*50+1:i*50,51:100) = reshape(U(:,count+1),50,50);
    count = count + 2;
end
%display the eigenfaces
figure,imshow(combined_image,[]);

%Problem 3.3
%reconstructing the faces for each person in subset 0
% person1 = trainset(:,1)-mu; %person 1 
% person2 = trainset(:,8)-mu; %person 2 
% person3 = trainset(:,15)-mu; %person 3 
% person4 = trainset(:,22)-mu; %person 4
% person5 = trainset(:,29)-mu; %person 5
% person6 = trainset(:,36)-mu; %person 6
% person7 = trainset(:,43)-mu; %person 7 
% person8 = trainset(:,50)-mu; %person 8 
% person9 = trainset(:,57)-mu; %person 9 
% person10 = trainset(:,64)-mu; %person 10 
% 
% 
% %U is the projection matrix, plot the reconstructed image for each person
% plot_image(person1,U,mu);
% plot_image(person2,U,mu);
% plot_image(person3,U,mu);
% plot_image(person4,U,mu);
% plot_image(person5,U,mu);
% plot_image(person6,U,mu);
% plot_image(person7,U,mu);
% plot_image(person8,U,mu);
% plot_image(person9,U,mu);
% plot_image(person10,U,mu);


%test labels
W = U';
%first project image into k dimension
k_testset1 = W * testset_1;
k_trainset = W * trainset;



[H,W] = size(k_trainset);
[h1,w1] = size(k_testset);

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

temp = mu;
for i = 1 : k
   temp = temp + pc(i)*U(:,i);        
end

