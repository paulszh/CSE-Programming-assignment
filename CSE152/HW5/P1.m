clear;
[trainset, trainlabel]=loadSubset(0);
[testset_1,testlabel_1] = loadSubset(1);
[testset_2,testlabel_2] = loadSubset(2);
[testset_3,testlabel_3] = loadSubset(3);
[testset_4,testlabel_4] = loadSubset(4);

[predicted1, error_rate_1] = naive_recognition_error_rate(trainset, trainlabel, testset_1,...
    testlabel_1);

[predicted2, error_rate_2] = naive_recognition_error_rate(trainset, trainlabel, testset_2,...
    testlabel_2);

[predicted3, error_rate_3] = naive_recognition_error_rate(trainset, trainlabel, testset_3,...
    testlabel_3);

[predicted4, error_rate_4] = naive_recognition_error_rate(trainset, trainlabel, testset_4,...
    testlabel_4);

person01_32 = imread('person01_32.png');
person04_02_train = imread('person04_02.png');
imshow([person04_02_train person01_32])
person01_31 = imread('person01_31.png');
person04_01_train = imread('person04_01.png');
imshow([person04_01_train person01_31])

