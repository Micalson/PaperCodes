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


rand('state',0)  %resets the generator to its initial stateָ��״̬��������ͬ�������

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};

cnn = cnnsetup(cnn, train_x, train_y); %��������

opts.alpha = 1; %ѧϰ��   
opts.batchsize = 50; %���δ�С��ÿ������һ��batchsize��batch��ѵ����Ҳ����ÿ��batchsize�������͵���һ��Ȩֵ�������ǰ����������������ˣ�������������������˲ŵ���һ��Ȩֵ
opts.numepochs = 2; %ѵ������

cnn = cnntrain(cnn, train_x, train_y, opts);% ѵ������
[er, bad] = cnntest(cnn, test_x, test_y);%�������磬ͨ����cnnff�ıȽϼ��������


%plot mean squared error
figure; plot(cnn.rL);
%show test error
disp([num2str(er*100) '% error']); 

assert(er<0.12, 'Too big error');
