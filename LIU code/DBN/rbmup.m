function x = rbmup(rbm, x)  %����v��h����һ�Σ���ʽ��Wx+c
    x = sigm(repmat(rbm.c', size(x, 1), 1) + x * rbm.W');
end