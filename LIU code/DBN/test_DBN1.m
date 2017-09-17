
clc
clear
tic
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%% train a 100 hidden unit RBM and visualize its weights
rand('state',0)   %指定状态，产生相同的随机数
dbn.sizes = [784 100 100 100];
opts.numepochs =   1; %训练代数
opts.batchsize = 100;
opts.momentum  =   0; %权值动量：记录下以前的更新方向，并与现在的方向结合下，更有可能加快速度的学习
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

%unfold dbn to nn  DBN只负责学习feature或者说初始化Weight，是一个unsupervised learning，最后的supervised还得靠NN
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
