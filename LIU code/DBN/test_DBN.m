
clc
clear
tic
load mnist_uint8;

train_x = double(train_x) / 255;
test_x  = double(test_x)  / 255;
train_y = double(train_y);
test_y  = double(test_y);

%% train a 100 hidden unit RBM and visualize its weights
%   n=3;
% for i=1:n
i=4;
rand('state',0)   %ָ��״̬��������ͬ�������
dbn.sizes = [784 100.*ones(1,i)];
opts.numepochs =   1; %ѵ������
opts.batchsize = 100;
opts.momentum  =   0; %Ȩֵ��������¼����ǰ�ĸ��·��򣬲������ڵķ������£����п��ܼӿ��ٶȵ�ѧϰ
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x, opts);
% numel(dbn.sizes)
dbn = dbntrain(dbn, train_x, opts);
figure ; visualize(dbn.rbm{1}.W');   %  Visualize the RBM weights
pause

%unfold dbn to nn  DBNֻ����ѧϰfeature����˵��ʼ��Weight����һ��unsupervised learning������supervised���ÿ�NN
% nn = dbnunfoldtonn(dbn, 10);
   size = [dbn.sizes 10];
   nn = nnsetup(size);  
    for i = 1 : numel(dbn.rbm)  % 2
        nn.W{i} = [dbn.rbm{i}.c dbn.rbm{i}.W];%w������w.c
    end
nn.activation_function = 'sigm';

%train nn
disp(['Training NN ']);
opts.numepochs =  1;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
disp(['The last accuracy is ' num2str((1-er)*100) '%' ]);

% end
toc
assert(er < 0.10, 'Too big error');
