% Perform PCA to get basis vector(1(N-c)
clear
c = 10; 

[trainset, trainlabel]=loadSubset(0);
[testset_1,testlabel_1] = loadSubset(1);
[testset_2,testlabel_2] = loadSubset(2);
[testset_3,testlabel_3] = loadSubset(3);
[testset_4,testlabel_4] = loadSubset(4);

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

%U is the projection matrix and the mu is the global mean
nc = size(trainset,2)-10;
[U,mu] = eigenTrain(trainset,nc);

%project the image to n-c dimesion

sixty_dimension_image = U' * trainset; 

% sixty_dimension_image = project_to_k_dimension(trainset, mu, U);
mu_per_person = zeros(60,10); %each column is the mean image per person

mu_nc = mean(sixty_dimension_image,2);
for i = 1 : 10
    temp = sixty_dimension_image(:,(i-1)*7+1:(i-1)*7+7);
    mu_per_person(:,i) = mean(temp,2);
end


%compute the sb
sb = zeros(nc,nc);  %60 by 60
for i = 1 : 10 
    temp = (mu_per_person(:,i) - mu_nc) * (mu_per_person(:,i) - mu_nc)';
    sb = sb + 7*temp;
end

sw = zeros(nc,nc);

%compute the sw   %60 by 60
for i = 1 : 10 
    for j = 1 : 7
        temp = sixty_dimension_image(:,(i-1)*7+j)-mu_per_person(:,i);
        sw = sw + temp * temp';
    end
end
% 
[V,D] = eig(sw,sb);
[value,idx] = sort(diag(D));
% top_nine = top(1:9);
fld = V(:,idx(1:9));

fisher_face = U * fld;



fisher_image = zeros(450,50);
for i = 1 : 9
    fisher_image((i-1)*50+1:(i-1)*50+50,:) = reshape(fisher_face(:,i),50,50);
end
figure,imagesc(fisher_image),colormap gray;

figure
for i = 1 : 9
    subplot(3,3,i)
    imshow(reshape(fisher_face(:,i),50,50),[]);
end



[predicted1, error_rate_1] = eigenTest(trainset', trainlabel, testset_1',...
     testlabel_1,fisher_face,mu,c-1);
[predicted2, error_rate_2] = eigenTest(trainset', trainlabel, testset_2',...
     testlabel_2,fisher_face,mu,c-1);
[predicted3, error_rate_3] = eigenTest(trainset', trainlabel, testset_3',...
     testlabel_3,fisher_face,mu,c-1);
[predicted4, error_rate_4] = eigenTest(trainset', trainlabel, testset_4',...
     testlabel_4,fisher_face,mu,c-1);

figure,plot(error_rate_1);
axis([1 9 0 1])
hold on
plot(error_rate_2)
hold on
plot(error_rate_3)
hold on 
plot(error_rate_4)
hold off








