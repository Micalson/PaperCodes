clc;
clearvars;
close all;
clear all;

L = double(imread('L.png'));
R = double(imread('R.png'));
% L = imread('L.png');
% R = imread('R.png');
dispL = double(imread('dispL.png'))/16;
dispR = double(imread('dispR.png'))/16;
% figure;imshow(L);
% imshow(R);
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
% figure;imshow(L);

temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
WINDOW_THRESHOLD=20;
T=60;
L_max=17;

d_max=15;
errorNum=0;
errorNum4=0;
ddisp=zeros(height,width,1);

tic
for i=1:height       %212
    disp([i-1,(i-1)*width,errorNum,errorNum4]);
    for j=1:width   %165
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
        Edp_min=100000000;
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
                for lr=-left:right
                    dL = double(abs( L(i+ud,j+lr,1)-R(i+ud,j-d+lr,1)) );
                    da = double(abs( L(i+ud,j+lr,2)-R(i+ud,j-d+lr,2)) );
                    db = double(abs( L(i+ud,j+lr,3)-R(i+ud,j-d+lr,3)) );
                    eds=min(dL+da+db,T);
                    Edp=Edp+eds;
                end;
                sumUD=sumUD+sumLR;
            end;
            EEdp=Edp/sumUD;
            if(EEdp<Edp_min)
                Edp_min=EEdp;
                bestD=d;
            end;
%             disp([i,j,d,Edp,sumUD,bestD]);
%             disp([EEdp]);
        end;
%         disp([i,j,bestD]);
        ddisp(i,j,1)=bestD;
        trueDisp=dispL(i,j,1);
        if(abs(bestD-trueDisp)>2)
            errorNum=errorNum+1;
        end;
       if(abs(bestD-trueDisp)>4)
            errorNum4=errorNum4+1;
        end;
%         disp([i,j,abs(bestD*4-trueDisp),errorNum]);        
%         plot(1:d_max+1,lll);
	end;    
%     disp([i,errorNum/(i*450),time]);
end;
disp([i,i*width,errorNum,errorNum4]);
time=toc