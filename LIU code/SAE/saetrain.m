function sae = saetrain(sae, x, opts)

    for i = 1 : numel(sae.ae);

        disp(['Training AE ' num2str(i) '/' num2str(numel(sae.ae))]);
        sae.ae{i} = nntrain(sae.ae{i}, x, x, opts);  %ԭ���뾭�Ա�������������Ժ����Ϊԭ����
        t = nnff(sae.ae{i}, x, x);
        x = t.a{2};  %��ŵ����м�㣨����ǰ���е�sae����b'w
        %remove bias term
        x = x(:,2:end); %w
    end
       save x4 x
end
