function nn = dbnunfoldtonn(dbn, outputsize)  %ÿһ��ѵ����ɺ�Ѳ������ݸ�һ�����NN
    if(exist('outputsize','var'))  %checks only for variables
        size = [dbn.sizes outputsize];
%        dbn.sizes  784 100 100
%        outputsize 10
%        size 784 100 100 10
    else
        size = [dbn.sizes];
%         dbn.sizes
%         size
    end
%        size 784 100 100 10
    nn = nnsetup(size);
   
    for i = 1 : numel(dbn.rbm)  % 3
        nn.W{i} = [dbn.rbm{i}.c dbn.rbm{i}.W];%w������w.c
    end
end

