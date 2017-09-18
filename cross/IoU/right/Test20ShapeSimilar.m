clc;
clearvars;
close all;
clear all;

L = double(imread('L.png'));
R = double(imread('R.png'));
dispL = double(imread('dispL.png'))/4;
dispR = double(imread('dispR.png'))/4;

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
ddisp=zeros(height,width,1);

tic
for i=1:height       %
    disp([i-1,(i-1)*width,errorNum,errorNum4]);
    for j=1:width    %
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
        Edp_max=0;
        for d=0:d_max
            if(j-d<1)
                continue;
            end;
            [upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j-d,R);
            upper=min(upperL,upperR);
            down =min(downL, downR);
            
            Edp=0;
            sumUD=0;
            for ud=-upper:down			
                sumLR=0;
                [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,L);
                [leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j-d,R);
                left =min(leftL,leftR);
                right=min(rightL,rightR);
                sumLR=left+right+1;
                sumUD=sumUD+sumLR;
            end;
            EEdp=sumUD;
            if(EEdp>Edp_max)
                Edp_max=EEdp;
                bestD=d;
            end;
        end;
        ddisp(i,j,1)=bestD;
        trueDisp=dispL(i,j,1);
        if(abs(bestD-trueDisp)>2)
            errorNum=errorNum+1;
        end;
       if(abs(bestD-trueDisp)>4)
            errorNum4=errorNum4+1;
        end;
	end;    
end;
disp([i,i*width,errorNum,errorNum4]);
time=toc