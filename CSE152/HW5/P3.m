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


%image in trainset and testset are both row vectors
[predicted1, error_rate_1] = eigenTest(trainset', trainlabel, testset_1',...
     testlabel_1,U,mu,20);
 [predicted2, error_rate_2] = eigenTest(trainset', trainlabel, testset_2',...
     testlabel_2,U,mu,20);
 [predicted3, error_rate_3] = eigenTest(trainset', trainlabel, testset_3',...
     testlabel_3,U,mu,20);
[predicted4, error_rate_4] = eigenTest(trainset', trainlabel, testset_4',...
     testlabel_4,U,mu,20);

%discard top 4 eigenvectors
U1 = U(:,5:20);

[predicted1_1, error_rate_1_1] = eigenTest(trainset', trainlabel, testset_1',...
     testlabel_1,U1,mu,16);
 [predicted2_2, error_rate_2_2] = eigenTest(trainset', trainlabel, testset_2',...
     testlabel_2,U1,mu,16);
 [predicted3_3, error_rate_3_3] = eigenTest(trainset', trainlabel, testset_3',...
     testlabel_3,U1,mu,16);
[predicted4_4, error_rate_4_4] = eigenTest(trainset', trainlabel, testset_4',...
     testlabel_4,U1,mu,16);


figure,plot(error_rate_1_1);
hold on
plot(error_rate_2_2)
hold on
plot(error_rate_3_3)
hold on 
plot(error_rate_4_4)
hold off

