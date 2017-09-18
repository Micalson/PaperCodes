%选定区域（左右支持区域的最小区域）作为支持区域，整幅图版求IoU，region is 0/1
clc;
clearvars;
close all;
clear all;

L = imread('L.png');
newL = L;
newLL = L;
temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
WINDOW_THRESHOLD=40;

ones(height,width,1)*200;
ones(height,width,3)*200;
ones(height,width,3)*200;
L1=ones(height,width,1)*220;
L2=ones(height,width,1)*220;
L3=ones(height,width,1)*220;
newLL(:,:,1)=L1;
newLL(:,:,2)=L2;
newLL(:,:,3)=L3;


tic



pixelIndexL = zeros(height,width);%to judge the pixel whether has already belong to a region,if yes,jump it
regionIndexL=1;

i=31;
j=31;
R=unifrnd(0,255);
G=unifrnd(0,255);
B=unifrnd(0,255);
seed_y=i;
seed_x=j; 
for d=0:59
    d
    newL = newLL;
    [WindowL, numL, regionL, pixelIndexL,newL]=getAdaptiveRegion4(WINDOW_THRESHOLD,height,width,seed_y,seed_x+d,L,pixelIndexL,regionIndexL,newL,R,G,B);
    regionIndexL=regionIndexL+1;
%     L1=newL(:,:,1);
%     L2=newL(:,:,2);
%     L3=newL(:,:,3);
%     LL1 = L1/max(max(L1));
%     LL2 = L2/max(max(L2));
%     LL3 = L3/max(max(L3));
%     newL1(:,:,1)=LL1;
%     newL1(:,:,2)=LL2;
%     newL1(:,:,3)=LL3;
%     figure;
    imshow(newL);
    dispFilename=sprintf('disp%d',d);
    imwrite(newL,['C:\Users\NKU\Desktop\cross\IoU\论文展示代码\3\',dispFilename,'.png']);
    
end;    
    
    
                

% pixelIndexL = zeros(height,width);%to judge the pixel whether has already belong to a region,if yes,jump it
% regionIndexL=1;
% for i=1:375
%     disp(['getAdaptiveRegionDisp ',num2str(i)])
% 	for j=1:450
%         
%         R=unifrnd(0,255);
%         G=unifrnd(0,255);
%         B=unifrnd(0,255);
% 		seed_y=i;
% 		seed_x=j;
%         if(pixelIndexL(i,j)~=0)
%             continue;
%         end;       
%         [WindowL, numL, regionL, pixelIndexL,newL]=getAdaptiveRegion5(WINDOW_THRESHOLD,height,width,seed_y,seed_x,dispL,pixelIndexL,regionIndexL,newL,R,G,B);
%         regionIndexL=regionIndexL+1;
%                 
% 	end;
% end



time=toc

