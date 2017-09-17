function net = cnntrain(net, x, y, opts)
    m = size(x, 3); %��������
    numbatches = m / opts.batchsize; %��������
    if rem(numbatches, 1) ~= 0  %����
        error('numbatches not integer');
    end
    net.rL = []; %ֻ��Ϊ��ƽ�����������ߴ��ۺ��������ߡ���Ϊ����������Ǹ��������������ı仯������ͨ�����������ģ�
                 %��net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L; ���൱��ƽ�������ã�Ҳ���ǵ�ͨ�˲���������Ƶ����
    
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]); %��epoch/numepochs
%         tic;
        kk = randperm(m);  % �������൱�ڰ�ԭ�����������д��ң�������һЩ������ѵ��
        for l = 1 : numbatches
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize)); %1--b��b+1--2b��2b+1--3b...
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            net = cnnff(net, batch_x);   % �ڵ�ǰ������Ȩֵ�����������¼����������� 
            net = cnnbp(net, batch_y);   % �õ���������������ͨ����Ӧ��������ǩ��bp�㷨���õ���������Ȩֵ��Ҳ������Щ����˵�Ԫ�أ��ĵ���  
            net = cnnapplygrads(net, opts);   % �õ�����Ȩֵ�ĵ����󣬾�ͨ��Ȩֵ���·���ȥ����Ȩֵ
            if isempty(net.rL)
                net.rL(1) = net.L; % ���ۺ���ֵ��Ҳ�������ֵ
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;  % ������ʷ�����ֵ���Ա㻭ͼ����
            ll = numbatches - l;
            disp(['The remaining numbatches is  ' num2str(ll)]); 
        end
%         toc;
%         ii = opts.numepochs - i;
%         disp(['The remaining numepochs is  ' num2str(ii)]); 
    end
end
