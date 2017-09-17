function net = cnnsetup(net, x, y)
    inputmaps = 1;
    
    mapsize = size(squeeze(x(:, :, 1)));  %取出每一个样本的size，即28*28

    for l = 1 : numel(net.layers)   %  layer
       %% 确定mapsize、初始化偏置
        if strcmp(net.layers{l}.type, 's')  % 如果这层是子采样层,strcmp比较字符串
            mapsize = mapsize / net.layers{l}.scale;   %pooling之后图的大小
            for j = 1 : inputmaps %采样层的inputmaps和outputmaps相等
                net.layers{l}.b{j} = 0;  % 将偏置初始化为0 
            end
        end
        %% 确定mapsize、kernel、初始化偏置
        if strcmp(net.layers{l}.type, 'c')  % 如果这层是卷积层
            mapsize = mapsize - net.layers{l}.kernelsize + 1;  % kernelsize*kernelsize大小的卷积核卷积上一层的特征map后，得到的新的map的大小
             fan_out = net.layers{l}.outputmaps * net.layers{l}.kernelsize ^ 2;    %每一个当前特征层有多少个参数（权值w，偏置b在下面独立保存）链接到下一层
             
            for j = 1 : net.layers{l}.outputmaps  % 因为卷积层的特征层数与下一层采样层的特征层数相同，所以outputmaps即为当前层的特征层数
                fan_in = inputmaps * net.layers{l}.kernelsize ^ 2;  % 每一个当前特征层有多少个参数链接到前一层
                for i = 1 : inputmaps  
                    net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize) - 0.5) * 2 * sqrt(6 / (fan_in + fan_out)); % 共有inputmaps * outputmaps 个卷积核，以及保存卷积核元素
                end
                net.layers{l}.b{j} = 0;  % 将偏置初始化为0  
            end
            inputmaps = net.layers{l}.outputmaps;  %初始inputmaps为1，每经历一个卷积层更新一次inputmaps
        end
    end
    
%%
    fvnum = prod(mapsize) * inputmaps;  % 输出层的前面一层的神经元个数。
    onum = size(y, 1);  % 标签的个数，也就是输出层神经元的个数

    net.ffb = zeros(onum, 1);  %输出层每个神经元对应的基
    net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));   %输出层前一层与输出层连接的权值，这两层之间是全连接的
end
