function x = rbmup(rbm, x)  %即从v到h计算一次，公式是Wx+c
    x = sigm(repmat(rbm.c', size(x, 1), 1) + x * rbm.W');
end
