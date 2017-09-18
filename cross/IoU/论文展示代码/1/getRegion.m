clc
clear all;

L = double(imread('L.png'));
newL = L;

temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
WINDOW_THRESHOLD=50;
L_max=1700;

regionIndex = zeros(height,width,1);

for i=1:height
    i
    for j=1:width
        R=unifrnd(0,255);
        G=unifrnd(0,255);
        B=unifrnd(0,255);
        if(regionIndex(i,j,1) == 1)
            continue;
        end;
        
        seed_y=i;
        seed_x=j;
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,seed_y,seed_x,L);
        
        for LL=-upperL:downL           
            newSeed_y=seed_y+LL;
            newSeed_x=seed_x;
            [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,newSeed_y,newSeed_x,L);
            for LR=-leftL:rightL
                newL(newSeed_y,seed_x+LR,1)=R;
                newL(newSeed_y,seed_x+LR,2)=G;
                newL(newSeed_y,seed_x+LR,3)=B;
                regionIndex(newSeed_y,seed_x+LR,1) = 1;
            end;
        end;
        
    end;
end;

L1=newL(:,:,1);
L2=newL(:,:,2);
L3=newL(:,:,3);
LL1 = L1/max(max(L1));
LL2 = L2/max(max(L2));
LL3 = L3/max(max(L3));
newL(:,:,1)=LL1;
newL(:,:,2)=LL2;
newL(:,:,3)=LL3;
figure;
imshow(newL);
imwrite(newL,['C:\Users\NKU\Desktop\cross\IoU\论文展示代码\1\','dispFilename','.png']);

% imshow(newL,[]);