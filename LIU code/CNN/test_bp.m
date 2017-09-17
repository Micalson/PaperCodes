clc
clear all

load mnist_uint8;

train_xx = double(reshape(train_x',28,28,60000))/255;
train_yy = double(train_y');
test_xx = double(reshape(test_x',28,28,10000))/255;
test_yy = double(test_y');

train_x = train_xx(:,:,1:100:60000);
train_y = train_yy(:,1:100:60000);
test_x = test_xx(:,:,1:100:10000);
test_y = test_yy(:,1:100:10000);

pause

%% Train a 6c-2s-12c-2s Convolutional neural network 


rand('state',0)  %resets the generator to its initial state指定状态，产生相同的随机数

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};

cnn = cnnsetup(cnn, train_x, train_y); %构建网络

opts.alpha = 1; %学习率   
opts.batchsize = 50; %批次大小，每次挑出一个batchsize的batch来训练，也就是每用batchsize个样本就调整一次权值，而不是把所有样本都输入了，计算所有样本的误差了才调整一次权值
opts.numepochs = 2; %训练次数

cnn = cnntrain(cnn, train_x, train_y, opts);% 训练网络
[er, bad] = cnntest(cnn, test_x, test_y);%测试网络，通过与cnnff的比较检出错误率


%plot mean squared error
figure; plot(cnn.rL);
%show test error
disp([num2str(er*100) '% error']); 

assert(er<0.12, 'Too big error');
