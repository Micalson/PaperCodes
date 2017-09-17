function net = cnnff(net, x)  %feedforward前向传播在当前的权值和输入下计算网络的输出
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    inputmaps = 1;

    for l = 2 : n   
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : net.layers{l}.outputmaps   
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]); %即该层特征层mapsize置零
                for i = 1 : inputmaps  
                    z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{i}{j}, 'valid');%当前层的一张特征map，是用一种卷积核去卷积上一层中所有的特征map，
                                                                                          %然后所有特征map对应位置的卷积值的和
                end
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});  % 加上对应位置的基b，然后再用sigmoid函数算出特征map中每个位置的激活值，作为该层输出特征层
            end

            inputmaps = net.layers{l}.outputmaps;
        elseif strcmp(net.layers{l}.type, 's')
            for j = 1 : inputmaps
%                 ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2)
                z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');   %mean pooling,卷积核为元素均为1/4的2*2矩阵
                net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :); % 因为convn函数的默认卷积步长为1，而pooling操作的域是没有重叠的，
                                                                  %所以对于上面的卷积结果最终pooling的结果需要从上面得到的卷积结果中以scale=2为步长，跳着把mean pooling的值读出来                   
            end
        end
    end

    net.fv = [];     % feature vector，把最后一层得到的特征map拉成一条向量，作为最终提取到的特征向量
    for j = 1 : numel(net.layers{n}.a)  % 最后一层的特征map的个数
        sa = size(net.layers{n}.a{j});  % 第j个特征map的大小
        net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))];  % 将所有的特征map拉成一条列向量。还有一维就是对应的样本索引。每个样本一列，每列为对应的特征向量
    end
    % net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));输出层前一层与输出层连接的权值，这两层之间是全连接的
    net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)));    % 计算网络的最终输出值。sigmoid(W*X + b)，注意是同时计算了batchsize个样本的输出值
end


