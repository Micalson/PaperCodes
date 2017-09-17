function net = cnntrain(net, x, y, opts)
    m = size(x, 3); %样本个数
    numbatches = m / opts.batchsize; %样本批数
    if rem(numbatches, 1) ~= 0  %求余
        error('numbatches not integer');
    end
    net.rL = []; %只是为了平滑那条误差或者代价函数的曲线。因为程序跑完后，那个误差随迭代次数的变化过程是通过它画出来的，
                 %而net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L; 就相当于平滑的作用，也就是低通滤波，削弱高频抖动
    
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]); %即epoch/numepochs
%         tic;
        kk = randperm(m);  % 这样就相当于把原来的样本排列打乱，再挑出一些样本来训练
        for l = 1 : numbatches
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize)); %1--b；b+1--2b；2b+1--3b...
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            net = cnnff(net, batch_x);   % 在当前的网络权值和网络输入下计算网络的输出 
            net = cnnbp(net, batch_y);   % 得到上面的网络输出后，通过对应的样本标签用bp算法来得到误差对网络权值（也就是那些卷积核的元素）的导数  
            net = cnnapplygrads(net, opts);   % 得到误差对权值的导数后，就通过权值更新方法去更新权值
            if isempty(net.rL)
                net.rL(1) = net.L; % 代价函数值，也就是误差值
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;  % 保存历史的误差值，以便画图分析
            ll = numbatches - l;
            disp(['The remaining numbatches is  ' num2str(ll)]); 
        end
%         toc;
%         ii = opts.numepochs - i;
%         disp(['The remaining numepochs is  ' num2str(ii)]); 
    end
end
