%选定区域（左右支持区域的最小区域）作为支持区域，整幅图版求IoU，region is 0/1
clc;
clearvars;
close all;
clear all;

L = double(imread('L.png'));
dispL = double(imread('dispL.png'))/4;
% L1=L(:,:,1);
% L2=L(:,:,2);
% L3=L(:,:,3);
% LL1 = medfilt2(L1, [3 3]);
% LL2 = medfilt2(L2, [3 3]);
% LL3 = medfilt2(L3, [3 3]);
% L(:,:,1)=LL1;
% L(:,:,2)=LL2;
% L(:,:,3)=LL3;
newL = L;
newL1 = L;

tic
height=375;
width=450;
WINDOW_THRESHOLD=40;

pixelIndexL = zeros(height,width);%to judge the pixel whether has already belong to a region,if yes,jump it
regionIndexL=1;

for i=1:375
    disp(['getAdaptiveRegion ',num2str(i)])
	for j=1:450
        
        R=unifrnd(0,255);
        G=unifrnd(0,255);
        B=unifrnd(0,255);
		seed_y=i;
		seed_x=j;
        if(pixelIndexL(i,j)~=0)
            continue;
        end;       
        [WindowL, numL, regionL, pixelIndexL,newL]=getAdaptiveRegion4(WINDOW_THRESHOLD,height,width,seed_y,seed_x,L,pixelIndexL,regionIndexL,newL,R,G,B);
        regionIndexL=regionIndexL+1;
                
	end;
end

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

L1=newL(:,:,1);
L2=newL(:,:,2);
L3=newL(:,:,3);
LL1 = L1/max(max(L1));
LL2 = L2/max(max(L2));
LL3 = L3/max(max(L3));
newL1(:,:,1)=LL1;
newL1(:,:,2)=LL2;
newL1(:,:,3)=LL3;
figure;
imshow(newL1);
imwrite(newL1,['C:\Users\NKU\Desktop\cross\IoU\论文展示代码\2\','dispFilename','.png']);

time=toc

