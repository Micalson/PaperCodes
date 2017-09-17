%%  mnist data
clear all; close all; clc;
tic
load mnist_uint8;
x = cell(100, 1); % struct
N = 600;
for i = 1 : 100  %100*(600*28*28)即每600个为一小cell，每一小cell（1*1）为一大cell（100*1），共100大cell
    x{i}{1} = reshape(train_x(((i - 1) * N + 1) : (i) * N, :), N, 28, 28) * 255;%1:600；601：1200...
end
% global xx
%   numel(x)  %100
%   x{1} % [600x28x28 uint8]
%% 
% layers = 3;
% for l = 1:layers
scae = {
    struct('outputmaps', 10, 'inputkernel', [1 5 5], 'outputkernel', [1 5 5], 'scale', [1 2 2], 'sigma', 0.1, 'momentum', 0.9, 'noise', 0)
          };
      
opts.rounds     = 10;
opts.batchsize  =    1;
opts.alpha      = 0.01;
opts.ddinterval =   10;
opts.ddhist     =  0.5;

scae = scaesetup(scae, x, opts);
scae = scaetrain(scae, x, opts);
% scae.i = scae.o;
% end


cae = scae{1};  %scae的第一个struct

%Visualize the average reconstruction error
plot(cae.rL);
sum(cae.rL)

%Visualize the output kernels
% ff=[];
% for i=1:numel(cae.ok{1}); 
%     mm = cae.ok{1}{i}(1,:,:); 
%     ff(i,:) = mm(:); 
% end; 
% toc
% figure;
% visualize(ff')
% % 
