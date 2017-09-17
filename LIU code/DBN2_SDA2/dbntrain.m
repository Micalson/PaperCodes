function dbn = dbntrain(dbn, x, opts)
    n = numel(dbn.rbm) ;%2

    disp(['Training RBM ' num2str(1) '/' num2str(n)]);
    dbn.rbm{1} = rbmtrain(dbn.rbm{1}, x, opts);

    for i = 2 : n
        disp(['Training RBM ' num2str(i) '/' num2str(n)]);
        x = rbmup(dbn.rbm{i - 1}, x);  %即 sigm(repmat(rbm.c', size(x, 1), 1) + x * rbm.W'),也就是从v到h计算一次，公式是Wx+c
        dbn.rbm{i} = rbmtrain(dbn.rbm{i}, x, opts);

    end
    save outputx x%60000*100
end
