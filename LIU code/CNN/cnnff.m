function net = cnnff(net, x)  %feedforwardǰ�򴫲��ڵ�ǰ��Ȩֵ�������¼�����������
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    inputmaps = 1;

    for l = 2 : n   
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : net.layers{l}.outputmaps   
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]); %���ò�������mapsize����
                for i = 1 : inputmaps  
                    z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{i}{j}, 'valid');%��ǰ���һ������map������һ�־�����ȥ������һ�������е�����map��
                                                                                          %Ȼ����������map��Ӧλ�õľ���ֵ�ĺ�
                end
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});  % ���϶�Ӧλ�õĻ�b��Ȼ������sigmoid�����������map��ÿ��λ�õļ���ֵ����Ϊ�ò����������
            end

            inputmaps = net.layers{l}.outputmaps;
        elseif strcmp(net.layers{l}.type, 's')
            for j = 1 : inputmaps
%                 ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2)
                z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');   %mean pooling,������ΪԪ�ؾ�Ϊ1/4��2*2����
                net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :); % ��Ϊconvn������Ĭ�Ͼ�������Ϊ1����pooling����������û���ص��ģ�
                                                                  %���Զ�������ľ����������pooling�Ľ����Ҫ������õ��ľ����������scale=2Ϊ���������Ű�mean pooling��ֵ������                   
            end
        end
    end

    net.fv = [];     % feature vector�������һ��õ�������map����һ����������Ϊ������ȡ������������
    for j = 1 : numel(net.layers{n}.a)  % ���һ�������map�ĸ���
        sa = size(net.layers{n}.a{j});  % ��j������map�Ĵ�С
        net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))];  % �����е�����map����һ��������������һά���Ƕ�Ӧ������������ÿ������һ�У�ÿ��Ϊ��Ӧ����������
    end
    % net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));�����ǰһ������������ӵ�Ȩֵ��������֮����ȫ���ӵ�
    net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)));    % ����������������ֵ��sigmoid(W*X + b)��ע����ͬʱ������batchsize�����������ֵ
end

