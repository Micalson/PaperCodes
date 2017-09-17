function sae = saetrain(sae, x, opts)

    for i = 1 : numel(sae.ae);

        disp(['Training AE ' num2str(i) '/' num2str(numel(sae.ae))]);
        sae.ae{i} = nntrain(sae.ae{i}, x, x, opts);  %原输入经自编码器编码解码以后，输出为原输入
        t = nnff(sae.ae{i}, x, x);
        x = t.a{2};  %存放的是中间层（即当前运行的sae）的b'w
        %remove bias term
        x = x(:,2:end); %w
    end
       save x4 x
end
