function [er, bad] = cnntest(net, x, y)
    %  feedforward
    net = cnnff(net, x);
    [~, h] = max(net.o); %h为每一行（每一行只有一个1）中1所在的列号
    [~, a] = max(y);
    bad = find(h ~= a);

    er = numel(bad) / size(y, 2);
end
