function scae = scaesetup(cae, x, opts)

    x = x{1};   %numel(x)  %100因为setup是初始化值的，并不赋值，选x{i}只是为了建立结构
                    % x{1}         % [600x28x28 uint8]
%     scae = scae{1};                 
                    
%%
    for l = 1 : numel(cae) %1:1,即scae有几层
        
        cae = cae{l};%从cae（l）的第l个struct开始赋给cae
        ll= [opts.batchsize size(x{1}, 2) size(x{1}, 3)] + cae.inputkernel - 1;  % [1 28 28]+[1 5 5]-1=[1 32 32]  % 确定mapsize
        X = zeros(ll);
%       nbmap(X, cae.scale) % 1*4*266
        cae.M = nbmap(X, cae.scale);  % nbmap function ,池化区域,如cae.M(:,:,2) =[1 2 33 34], cae.M(:,:,2) =[3 4 35 36]。。。 
        bounds = cae.outputmaps * prod(cae.inputkernel) + numel(x) * prod(cae.outputkernel); %10*25+1*25=275,相当于CNN中的fan_out+fan_in
     
        for j = 1 : cae.outputmaps   %  activation maps                                    % 针对确定kernel  
%             size(x{1}) + cae.inputkernel - 1     % [600 28 28] + [1 5 5] - 1  = [600 32 32]，
            cae.a{j} = zeros(size(x{1}) + cae.inputkernel - 1); %kernel卷积原图像后的特征层
            for i = 1 : numel(x)    %  input map
                cae.ik{i}{j}  = (rand(cae.inputkernel)  - 0.5) * 2 * sqrt(6 / bounds);
                cae.ok{i}{j}  = (rand(cae.outputkernel) - 0.5) * 2 * sqrt(6 / bounds);
                cae.vik{i}{j} = zeros(size(cae.ik{i}{j}));
                cae.vok{i}{j} = zeros(size(cae.ok{i}{j}));
            end
            cae.b{j} = 0;                                                                   %初始化可视层偏置b
            cae.vb{j} = zeros(size(cae.b{j}));
        end


        cae.alpha = opts.alpha;      % 初始化学习率，输入输出
        cae.i = cell(numel(x), 1);  % 1,1
        cae.o = cae.i;                           %即输入输出结构相同

        for i = 1 : numel(cae.o)     %1:1，初始化隐藏层偏置c
            cae.c{i}  = 0;
            cae.vc{i} = zeros(size(cae.c{i}));
        end

        ss = cae.outputkernel; %1 5 5
        cae.edgemask = zeros([opts.batchsize size(x{1}, 2) size(x{1}, 3)]); %1 28 28
        cae.edgemask(ss(1) : end - ss(1) + 1, ...  %第5-24（第三维）个1*28的矩阵（第5—24个元素都为1）
                     ss(2) : end - ss(2) + 1, ...
                     ss(3) : end - ss(3) + 1) = 1;

        scae{l} = cae;       
    end
  
    %% 分割池化区域
    function B = nbmap(X,n)
        assert(numel(n)==3,'n should have 3 elements (x,y,z) scaling.');
        X = reshape(1:numel(X),size(X,1),size(X,2),size(X,3)); %(1:1024,1,32,32)
        B = zeros(size(X,1)/n(1),prod(n),size(X,2)*size(X,3)/prod(n(2:3)));%(1/1,1*2*2,32*32/4)
        u=1;
        p=1;
        for m=1:size(X,1)
            B(u,(p-1)*prod(n(2:3))+1:p*prod(n(2:3)),:) = im2col(squeeze(X(m,:,:)),n(2:3),'distinct'); %将矩阵A分为m×n的子矩阵，再将每个子矩阵作为B的一列
            p=p+1;
            if(mod(m,n(1))==0)
                u=u+1;
                p=1;
            end
        end
    end
end
