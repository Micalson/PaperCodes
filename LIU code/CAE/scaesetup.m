function scae = scaesetup(cae, x, opts)

    x = x{1};   %numel(x)  %100��Ϊsetup�ǳ�ʼ��ֵ�ģ�������ֵ��ѡx{i}ֻ��Ϊ�˽����ṹ
                    % x{1}         % [600x28x28 uint8]
%     scae = scae{1};                 
                    
%%
    for l = 1 : numel(cae) %1:1,��scae�м���
        
        cae = cae{l};%��cae��l���ĵ�l��struct��ʼ����cae
        ll= [opts.batchsize size(x{1}, 2) size(x{1}, 3)] + cae.inputkernel - 1;  % [1 28 28]+[1 5 5]-1=[1 32 32]  % ȷ��mapsize
        X = zeros(ll);
%       nbmap(X, cae.scale) % 1*4*266
        cae.M = nbmap(X, cae.scale);  % nbmap function ,�ػ�����,��cae.M(:,:,2) =[1 2 33 34], cae.M(:,:,2) =[3 4 35 36]������ 
        bounds = cae.outputmaps * prod(cae.inputkernel) + numel(x) * prod(cae.outputkernel); %10*25+1*25=275,�൱��CNN�е�fan_out+fan_in
     
        for j = 1 : cae.outputmaps   %  activation maps                                    % ���ȷ��kernel  
%             size(x{1}) + cae.inputkernel - 1     % [600 28 28] + [1 5 5] - 1  = [600 32 32]��
            cae.a{j} = zeros(size(x{1}) + cae.inputkernel - 1); %kernel����ԭͼ����������
            for i = 1 : numel(x)    %  input map
                cae.ik{i}{j}  = (rand(cae.inputkernel)  - 0.5) * 2 * sqrt(6 / bounds);
                cae.ok{i}{j}  = (rand(cae.outputkernel) - 0.5) * 2 * sqrt(6 / bounds);
                cae.vik{i}{j} = zeros(size(cae.ik{i}{j}));
                cae.vok{i}{j} = zeros(size(cae.ok{i}{j}));
            end
            cae.b{j} = 0;                                                                   %��ʼ�����Ӳ�ƫ��b
            cae.vb{j} = zeros(size(cae.b{j}));
        end


        cae.alpha = opts.alpha;      % ��ʼ��ѧϰ�ʣ��������
        cae.i = cell(numel(x), 1);  % 1,1
        cae.o = cae.i;                           %����������ṹ��ͬ

        for i = 1 : numel(cae.o)     %1:1����ʼ�����ز�ƫ��c
            cae.c{i}  = 0;
            cae.vc{i} = zeros(size(cae.c{i}));
        end

        ss = cae.outputkernel; %1 5 5
        cae.edgemask = zeros([opts.batchsize size(x{1}, 2) size(x{1}, 3)]); %1 28 28
        cae.edgemask(ss(1) : end - ss(1) + 1, ...  %��5-24������ά����1*28�ľ��󣨵�5��24��Ԫ�ض�Ϊ1��
                     ss(2) : end - ss(2) + 1, ...
                     ss(3) : end - ss(3) + 1) = 1;

        scae{l} = cae;       
    end
  
    %% �ָ�ػ�����
    function B = nbmap(X,n)
        assert(numel(n)==3,'n should have 3 elements (x,y,z) scaling.');
        X = reshape(1:numel(X),size(X,1),size(X,2),size(X,3)); %(1:1024,1,32,32)
        B = zeros(size(X,1)/n(1),prod(n),size(X,2)*size(X,3)/prod(n(2:3)));%(1/1,1*2*2,32*32/4)
        u=1;
        p=1;
        for m=1:size(X,1)
            B(u,(p-1)*prod(n(2:3))+1:p*prod(n(2:3)),:) = im2col(squeeze(X(m,:,:)),n(2:3),'distinct'); %������A��Ϊm��n���Ӿ����ٽ�ÿ���Ӿ�����ΪB��һ��
            p=p+1;
            if(mod(m,n(1))==0)
                u=u+1;
                p=1;
            end
        end
    end
end