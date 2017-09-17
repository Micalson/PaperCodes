%function test_SAE

clc
clear all
load mnist_uint8;
tic
train_x = double(train_x)/255;
test_x  = double(test_x)/255;
train_y = double(train_y);
test_y  = double(test_y);

%%  ex1 train a 100 hidden unit SDAE and use it to initialize a FFNN
%  Setup and train a stacked denoising autoencoder (SDAE)
% n=3;
% for numlayer=1:n  %sae个数
numlayer=2;
rand('state',0)
sae = saesetup([784 100.*ones(1,numlayer)]);
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.learningRate              = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;
opts.numepochs =   1;
opts.batchsize = 100;

sae = saetrain(sae, train_x, opts);

% visualize(sae.ae{1}.W{1}(:,2:end)')

% Use the SDAE to initialize a FFNN(feedforward neural network)
nn = nnsetup([784 100.*ones(1,numlayer) 10]);
% nn.W{1} = sae.ae{1}.W{1};
    for i = 1 : numlayer 
        nn.W{i} = sae.ae{i}.W{1};%W{1}即784到100之间的w.c
    end
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;

% Train the FFNN
disp(['Training NN ']);
opts.numepochs =   1;
opts.batchsize = 100;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
disp(['The last accuracy is ' num2str((1-er)*100) '%' ]);
% end
toc
% assert(er < 0.16, 'Too big error');



