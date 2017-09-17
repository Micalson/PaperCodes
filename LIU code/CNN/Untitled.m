clc
clear all
% net.o = [0 0 1;0 1 0;1 0 0];
%  y = [0 0 1;0 1 0;0 0 1];
%  max(net.o)
% max(y)
% [~, h] = max(net.o)
%     [~, a] = max(y)
%     bad = find(h ~= a)
    
% a=[1 2 3;4 5 6;7 8 9];
% b=[1 2; 3 4; 5 6;7 8;9 0];
% save mydata2 b

c=load('mydata2.mat');
d=c.b(1:3,:)%你要的一列
pause
e=c.b(1:3,:)