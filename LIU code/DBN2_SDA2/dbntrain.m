function dbn = dbntrain(dbn, x, opts)
    n = numel(dbn.rbm) ;%2

    disp(['Training RBM ' num2str(1) '/' num2str(n)]);
    dbn.rbm{1} = rbmtrain(dbn.rbm{1}, x, opts);

    for i = 2 : n
        disp(['Training RBM ' num2str(i) '/' num2str(n)]);
        x = rbmup(dbn.rbm{i - 1}, x);  %�� sigm(repmat(rbm.c', size(x, 1), 1) + x * rbm.W'),Ҳ���Ǵ�v��h����һ�Σ���ʽ��Wx+c
        dbn.rbm{i} = rbmtrain(dbn.rbm{i}, x, opts);

    end
    save outputx x%60000*100
end
