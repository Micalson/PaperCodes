clc;
clearvars;
clear all;
close all;

WINDOW_THRESHOLD=20;
T=60;
L_max=17;
height=375;
width=450;

L = imread('L.png');
R = imread('R.png');
dispL = double(imread('dispL.png'))/4;
ddisp = ones(height,width,1)*200;
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
errorNum1=0;
tic;
for i=116:135       %116£¬330 212
%     disp([i-1,(i-1)*450,errorNum,errorNum1]);
    for j=239:403   %239£¬403 165
        disp([i,j,(i-116)*165+j-238,errorNum,errorNum1]);
        for d=0:59
            if(j-d<1)
                break;
            end;
            [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
            [upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j-d,R);
            upper=min(upperL,upperR);
            down =min(downL, downR);

            edsNum=1;
            Edp=0;
            for ud=-upper:down 
                [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,L);
                [leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j-d,R);
                left =min(leftL,leftR);
                right=min(rightL,rightR);
                if(ud==0)   
                     weightUD=1;
                end;
                weightUD=1/abs(ud);
%                 weightUD=1;
                for lr=-left:right
                    if(lr==0)   
                        weightLR=1;
                    end;
                    weightLR=1/abs(lr);
%                     weightLR=1;
                    eds=weightLR*weightUD;
                    Edp(edsNum)=eds;
                    edsNum=edsNum+1;
                end;
            end;
            EEdp(d+1)=sum(Edp);
        end;
%         plot(1:60,EEdp,'*-');
        [unused,bestD]=max(EEdp);
		bestD=bestD-1;
        trueDisp=dispL(i,j,1);
		ddisp(i,j,1)=bestD*4;
%         abs(bestD-trueDisp)
        if(abs(bestD-trueDisp)>2)
            errorNum=errorNum+1;
        end;
        if(abs(bestD-trueDisp)>4)
            errorNum1=errorNum1+1;
        end;
    end;
    
end;
time=toc;