clc;
clearvars;
clear all;
close all;

WINDOW_THRESHOLD=20;
T=60;
L_max=17;
temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);

d_max=59;
L = double(imread('L.png'));
R = double(imread('R.png'));
% L = imread('L.png');
% R = imread('R.png');
dispL = double(imread('dispL.png'))/4;
dispR = double(imread('dispR.png'))/4;
ddisp = zeros(height,width,1);
errorDisp = ones(height,width,1)*(256);
errorDisp4 = ones(height,width,1)*(256);

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

i=210;
j=344;
errorNum=0;
errorNum4=0;
tic;
for i=1:height       %212
    disp([i-1,(i-1)*width,errorNum,errorNum4]);
    for j=1:width   %165
%         disp([i,j,(i-116)*165+j-238,errorNum,errorNum4]);
        EEdp=0;
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
        for d=0:d_max
            if(j-d<1)
                break;
            end;
            
            [upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j-d,R);
            upper=min(upperL,upperR);
            down =min(downL, downR);

            edsNum=0;
            Edp=0;
            for ud=-upper:down 
                [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,L);
                [leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j-d,R);
                left =min(leftL,leftR);
                right=min(rightL,rightR);
                for lr=-left:right
                    dL = abs( L(i+ud,j+lr,1)-R(i+ud,j-d+lr,1) );
                    da = abs( L(i+ud,j+lr,2)-R(i+ud,j-d+lr,2) );
                    db = abs( L(i+ud,j+lr,3)-R(i+ud,j-d+lr,3) );
                    eds=min(dL+da+db,T);
                    edsNum=edsNum+1;
                    Edp(edsNum)=eds;                  
                end;
            end;           
            temp1=size(Edp);
%             disp([i,j,d,sum(Edp),temp1(1,2),edsNum]);
%             disp([sum(Edp)/(edsNum)]);
%             EEdp(d+1)=sum(Edp)/temp1(1,2);
            EEdp(d+1)=sum(Edp)/(edsNum);
%             pause
        end;
%         plot(1:60,EEdp,'*-');
        [unused,bestD]=min(EEdp);
		bestD=bestD-1;
%         disp([i,j,bestD]);
        trueDisp=dispL(i,j,1);
		ddisp(i,j,1)=bestD;
        if(abs(bestD-trueDisp)>2)
            errorNum=errorNum+1;
            errorDisp(i,j,1)=bestD*4;
        end;
        if(abs(bestD-trueDisp)>4)
            errorNum4=errorNum4+1;
            errorDisp4(i,j,1)=bestD*4;
        end;
    end;
    
end;
disp([i,i*width,errorNum,errorNum4]);
time=toc;