function net = cnnsetup(net, x, y)
    inputmaps = 1;
    
    mapsize = size(squeeze(x(:, :, 1)));  %ȡ��ÿһ��������size����28*28

    for l = 1 : numel(net.layers)   %  layer
       %% ȷ��mapsize����ʼ��ƫ��
        if strcmp(net.layers{l}.type, 's')  % ���������Ӳ�����,strcmp�Ƚ��ַ���
            mapsize = mapsize / net.layers{l}.scale;   %pooling֮��ͼ�Ĵ�С
            for j = 1 : inputmaps %�������inputmaps��outputmaps���
                net.layers{l}.b{j} = 0;  % ��ƫ�ó�ʼ��Ϊ0 
            end
        end
        %% ȷ��mapsize��kernel����ʼ��ƫ��
        if strcmp(net.layers{l}.type, 'c')  % �������Ǿ����
            mapsize = mapsize - net.layers{l}.kernelsize + 1;  % kernelsize*kernelsize��С�ľ���˾����һ�������map�󣬵õ����µ�map�Ĵ�С
             fan_out = net.layers{l}.outputmaps * net.layers{l}.kernelsize ^ 2;    %ÿһ����ǰ�������ж��ٸ�������Ȩֵw��ƫ��b������������棩���ӵ���һ��
             
            for j = 1 : net.layers{l}.outputmaps  % ��Ϊ������������������һ������������������ͬ������outputmaps��Ϊ��ǰ�����������
                fan_in = inputmaps * net.layers{l}.kernelsize ^ 2;  % ÿһ����ǰ�������ж��ٸ��������ӵ�ǰһ��
                for i = 1 : inputmaps  
                    net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize) - 0.5) * 2 * sqrt(6 / (fan_in + fan_out)); % ����inputmaps * outputmaps ������ˣ��Լ���������Ԫ��
                end
                net.layers{l}.b{j} = 0;  % ��ƫ�ó�ʼ��Ϊ0  
            end
            inputmaps = net.layers{l}.outputmaps;  %��ʼinputmapsΪ1��ÿ����һ����������һ��inputmaps
        end
    end
    
%%
    fvnum = prod(mapsize) * inputmaps;  % ������ǰ��һ�����Ԫ������
    onum = size(y, 1);  % ��ǩ�ĸ�����Ҳ�����������Ԫ�ĸ���

    net.ffb = zeros(onum, 1);  %�����ÿ����Ԫ��Ӧ�Ļ�
    net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));   %�����ǰһ������������ӵ�Ȩֵ��������֮����ȫ���ӵ�
end
