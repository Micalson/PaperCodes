
clc
clear
tic
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%% train a 100 hidden unit RBM and visualize its weights
rand('state',0)   %ָ��״̬��������ͬ�������
dbn.sizes = [784 100 100 100];
opts.numepochs =   1; %ѵ������
opts.batchsize = 100;
opts.momentum  =   0; %Ȩֵ��������¼����ǰ�ĸ��·��򣬲������ڵķ������£����п��ܼӿ��ٶȵ�ѧϰ
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
% numel(dbn.sizes)
dbn = dbntrain(dbn, train_x, opts);
% rand('state',0) 
% dbn = dbnsetup(dbn, train_x, opts);
% dbn = dbntrain(dbn, train_x, opts);
% figure ; visualize(dbn.rbm{1}.W');   %  Visualize the RBM weights
% pause
%% train a 100-100 hidden unit DBN and use its weights to initialize a NN
% rand('state',0)
% %train dbn
% dbn.sizes = [100 100];
% opts.numepochs =   1;
% opts.batchsize = 100;
% opts.momentum  =   0;
% opts.alpha     =   1;
% dbn = dbnsetup(dbn, train_x, opts);
% numel(dbn.sizes)
% dbn = dbntrain(dbn, train_x, opts);

%unfold dbn to nn  DBNֻ����ѧϰfeature����˵��ʼ��Weight����һ��unsupervised learning������supervised���ÿ�NN
nn = dbnunfoldtonn(dbn, 10);
nn.activation_function = 'sigm';

%train nn
opts.numepochs =  1;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
er
toc
assert(er < 0.10, 'Too big error');
