clc;
clearvars;
close all;
clear all;

L = double(imread('L.png'));
R = double(imread('R.png'));
dispL = double(imread('dispL.png'))/4;

L1=L(:,:,1);
L2=L(:,:,2);
L3=L(:,:,3);
LL1 = medfilt2(L1, [3 3]);
LL2 = medfilt2(L2, [3 3]);
LL3 = medfilt2(L3, [3 3]);
L(:,:,1)=LL1;
L(:,:,2)=LL2;
L(:,:,3)=LL3;
R1=R(:,:,1);
R2=R(:,:,2);
R3=R(:,:,3);
RR1 = medfilt2(R1, [3 3]);
RR2 = medfilt2(R2, [3 3]);
RR3 = medfilt2(R3, [3 3]);
R(:,:,1)=RR1;
R(:,:,2)=RR2;
R(:,:,3)=RR3;

temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
WINDOW_THRESHOLD=20;
T=60;
L_max=1700;

d_max=59;
errorNum=0;
errorNum4=0;
jumpNum=0;

numL=zeros(height,width,1);
numR=zeros(height,width,1);
numLR=zeros(height,width,1);
numRowL=zeros(height,width,1);
numRowR=zeros(height,width,1);

tic
for i=1:height       %
    i
    for j=1:width    %
        %%
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
        sumUD=0;
        for ud=-upperL:downL
            sumLR=0;
            [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,L);
            sumLR=leftL+rightL+1;
            sumUD=sumUD+sumLR;
        end;
        numL(i,j,1)=sumUD;
        numRowL(i,j,1)=upperL+downL+1;
         %%       
        [upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,R);
        sumUD=0;
        for ud=-upperR:downR			
            sumLR=0;
            [leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,R);
            sumLR=leftR+rightR+1;
            sumUD=sumUD+sumLR;
        end;
        numR(i,j,1)=sumUD;
        numRowR(i,j,1)=upperR+downR+1;
        %%
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
        d=dispL(i,j,1);
        d=round(d);
        if(j-d<1)
            continue;
        end;
        [upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j-d,R);
        upper=min(upperL,upperR);
        down =min(downL, downR);
        sumUDnum=0;
        for ud=-upper:down
            sumLRnum=0;
            [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,L);
            [leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j-d,R);
            left =min(leftL,leftR);
            right=min(rightL,rightR);
            sumLRnum=left+right+1;
            sumUDnum=sumUDnum+sumLRnum;  
        end;
        numLR(i,j,1)=sumUDnum;
        %%
        if( numL(i,j,1)-numLR(i,j,1)<0)
            disp([i,j,numL(i,j,1),numLR(i,j,1)]);
        end;
    end;    
end;
time=toc