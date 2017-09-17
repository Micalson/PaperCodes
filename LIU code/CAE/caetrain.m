function cae = caetrain(cae, x, opts)
%     global xx
    n = cae.inputkernel(1); % 1
    cae.rL = [];

    for m = 1 : opts.rounds
%         tic;
        disp([num2str(m) '/' num2str(opts.rounds) ' rounds']);
        i1 = randi(numel(x)); %产生一个1-100之间的随机数，即100个cell之间任取一个
        l  = randi(size(x{i1}{1},1) - opts.batchsize - n + 1); % 600-1-1+1   
        x1{1} = double(x{i1}{1}(l : l + opts.batchsize - 1, :, :)) / 255; % 28*28 因为batchsize为1，相当于每次循环随机取出100个x.cell之中600个unit中的一个
                                                                                              %x1为1*28*28，相当于每幅图
        if n == 1   %Auto Encoder
            x2{1} = x1{1};
        else        %Predictive Encoder
            x2{1} = double(x{i1}{1}(l + n : l + n + opts.batchsize - 1, :, :)) / 255;
        end
        %  Add noise to input, for denoising stacked autoenoder

        x1{1} = x1{1} .* (rand(size(x1{1})) > cae.noise);

%       nn=1;
%       for epoch = 1 : nn
%         disp([ '   epochs' num2str(epoch) '/' num2str(nn)]);
        cae = caeup(cae, x1);
        cae = caedown(cae);
        cae = caebp(cae, x2);
        cae = caesdlm(cae, opts, m);
%       caenumgradcheck(cae,x1,x2);
        cae = caeapplygrads(cae);
%         x1 = cae.o;
%        end

        if m == 1
            cae.rL(1) = cae.L;
        end
        cae.rL(m + 1) = 0.99 * cae.rL(m) + 0.01 * cae.L;
%         cae.rL(m + 1) = cae.L;
%         if cae.sv < 1e-10
%             disp('Converged');
%             break;
%         end
%         toc;
%         pause
    end

end
