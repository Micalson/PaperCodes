
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
numlayer=2;
rand('state',0)
sae = saesetup([784 100.*ones(1,numlayer)]);
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.learningRate              = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;
opts.numepochs =   1;
opts.batchsize = 100;
sae = saetrain(sae, train_x, opts);
load outputx;
train_x1 = x;

%%

i=2;
rand('state',0)   %指定状态，产生相同的随机数
dbn.sizes = [100 100.*ones(1,i)];
opts.numepochs =   1; %训练代数
opts.batchsize = 100;
opts.momentum  =   0; %权值动量：记录下以前的更新方向，并与现在的方向结合下，更有可能加快速度的学习
opts.alpha     =   1;
dbn = dbnsetup(dbn, train_x1, opts);
dbn = dbntrain(dbn, train_x1, opts);
% % figure ; visualize(dbn.rbm{1}.W');   %  Visualize the RBM weights
% % pause

%%
%unfold dbn to nn  
    nn = nnsetup([784 100 100 100 100 10]);

        for i = 1 : numlayer
        nn.W{i} = sae.ae{i}.W{1};%W{1}即784到100之间的w.c
        end

    for j = 1 : numel(dbn.rbm)  % 2
        nn.W{j+2} = [dbn.rbm{j}.c dbn.rbm{j}.W];%w包含有w.c
    end

nn.activation_function              = 'sigm';
nn.learningRate                     = 1;

%train nn
disp(['Training NN ']);
opts.numepochs =  5;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, train_x, train_y);
disp(['The last accuracy is ' num2str((1-er)*100) '%' ]);

% end
toc
% assert(er < 0.10, 'Too big error');
