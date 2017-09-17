function [nn, L]  = nntrain(nn, train_x, train_y, opts, val_x, val_y)

assert(isfloat(train_x), 'train_x must be a float');
assert(nargin == 4 || nargin == 6,'number ofinput arguments must be 4 or 6')

loss.train.e               = [];
loss.train.e_frac          = [];
loss.val.e                 = [];
loss.val.e_frac            = [];
opts.validation = 0;
    if nargin == 6
       opts.validation = 1;
    end

fhandle = [];
    if isfield(opts,'plot') && opts.plot == 1
       fhandle = figure();
    end

m = size(train_x, 1);  %训练样本的数量 
batchsize = opts.batchsize; %批次大小
numepochs = opts.numepochs;   %迭代数
numbatches = m / batchsize;   %批次数

assert(rem(numbatches, 1) == 0, 'numbatches must be a integer');

L = zeros(numepochs*numbatches,1);   % the sum squared error for each training minibatch.
n = 1;

 for i = 1 : numepochs
    tic;    
    kk = randperm(m);
    
    for l = 1 : numbatches
           batch_x = train_x(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        %Add noise to input (for use in denoising autoencoder),具体加入的方法就是把训练样例中的一些数据调整变为0，inputZeroMaskedFraction表示了调整的比例.  
        if(nn.inputZeroMaskedFraction ~= 0)
            batch_x = batch_x.*(rand(size(batch_x))>nn.inputZeroMaskedFraction);
        end
            batch_y = train_y(kk((l - 1) * batchsize + 1 : l * batchsize), :);
        
        nn = nnff(nn, batch_x, batch_y); %进行前向传播
        nn = nnbp(nn);                   %进行后向传播
        nn = nnapplygrads(nn);           %进行梯度下降
        
        L(n) = nn.L;
        n = n + 1;
    end
    t = toc; 

    if opts.validation == 1
        loss = nneval(nn, loss, train_x, train_y, val_x, val_y);
        str_perf = sprintf('; Full-batch train mse = %f, val mse = %f', loss.train.e(end), loss.val.e(end));
    else
        loss = nneval(nn, loss, train_x, train_y);
        str_perf = sprintf('; Full-batch train err = %f', loss.train.e(end));
    end
    
    if ishandle(fhandle)
        nnupdatefigures(nn, fhandle, loss, opts, i);
    end
        
    disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds' '. Mini-batch mean squared error on training set is ' num2str(mean(L((n-numbatches):(n-1)))) str_perf]);
    nn.learningRate = nn.learningRate * nn.scaling_learningRate;
 end
end

