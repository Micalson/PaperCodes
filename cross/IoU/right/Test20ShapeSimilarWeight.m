clc;
clearvars;
close all;
clear all;

L = double(imread('L.png'));
R = double(imread('R.png'));
dispL = double(imread('dispL.png'))/8;
dispR = double(imread('dispR.png'))/8;

% L1=L(:,:,1);
% L2=L(:,:,2);
% L3=L(:,:,3);
% LL1 = medfilt2(L1, [3 3]);
% LL2 = medfilt2(L2, [3 3]);
% LL3 = medfilt2(L3, [3 3]);
% L(:,:,1)=LL1;
% L(:,:,2)=LL2;
% L(:,:,3)=LL3;
% R1=R(:,:,1);
% R2=R(:,:,2);
% R3=R(:,:,3);
% RR1 = medfilt2(R1, [3 3]);
% RR2 = medfilt2(R2, [3 3]);
% RR3 = medfilt2(R3, [3 3]);
% R(:,:,1)=RR1;
% R(:,:,2)=RR2;
% R(:,:,3)=RR3;

temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
WINDOW_THRESHOLD=20;
T=60;
Ts=0.9;
L_max=1700;

d_max=19;
errorNum=0;
errorNum4=0;
jumpNum=0;
temp=0;
temp4=0;
ddisp=zeros(height,width,1);
errorDisp = ones(height,width,1)*(63);
errorDisp4 = ones(height,width,1)*(63);


for rc=31:50
    rc
    tic
    for i=1:height       %
        disp([i-1,(i-1)*width,errorNum,errorNum4,errorNum-temp,errorNum4-temp4]);
%         disp([i-1,jumpNum,(i-1)*width,errorNum,errorNum4,errorNum-temp,errorNum4-temp4]);
        temp=errorNum;
        temp4=errorNum4;
        for j=1:width    %
            [upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,R);
            Edp_max=0;
    %         bestD=0;
            for d=0:d_max
                if(j+d>width)
                    continue;
                end;
                [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j+d,L);
                if( (upperR+downR+1)*(1+Ts) < (upperL+downL+1) || (upperR+downR+1)*(1-Ts) > (upperL+downL+1) ) %shape similarity   
                    jumpNum=jumpNum+1;
                    continue;
                end;            
                upper=min(upperL,upperR);
                down =min(downL, downR);

                Edp=0;
                sumUD=0;
                for ud=-upper:down			
                    sumLR=0;
                    [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j+d,L);
                    [leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,R);
                    left =min(leftL,leftR);
                    right=min(rightL,rightR);
                    for lr=-left:right
                        dL = double(abs( L(i+ud,j+lr+d,1)-R(i+ud,j+lr,1)) );
                        da = double(abs( L(i+ud,j+lr+d,2)-R(i+ud,j+lr,2)) );
                        db = double(abs( L(i+ud,j+lr+d,3)-R(i+ud,j+lr,3)) );
    %                     eds=exp( -(sqrt(lr*lr+ud*ud)/17.5)-(dL+da+db)/5 );
                        eds=exp(-(sqrt(dL*dL+da*da+db*db)/rc));
                        sumLR=sumLR+eds;
                    end;
                    % sumLR=left+right+1;
                    sumUD=sumUD+sumLR;
                end;
                EEdp=sumUD;
                if(EEdp>Edp_max)
                    Edp_max=EEdp;
                    bestD=d;
                end;
            end;
            ddisp(i,j,1)=bestD;
            trueDisp=dispR(i,j,1);
            if(abs(bestD-trueDisp)>2)
                errorNum=errorNum+1;
                errorDisp(i,j,1)=bestD;
            end;
           if(abs(bestD-trueDisp)>4)
                errorNum4=errorNum4+1;
                errorDisp4(i,j,1)=bestD;
            end;
        end;    
    end;
    disp([rc,i,i*width,errorNum,errorNum4]);
    rcc=rc;
    run('C:\Users\NKU\Desktop\cross\IoU\right\Test22.m');
    file=['rc\','matlab',num2str(rc),'.mat']; 
    save(file);
    file1=['C:\Users\NKU\Desktop\cross\IoU\right\rc\','dddispR',num2str(rcc),'.mat'];
    save(file1, 'dddispR');    
    % sum(errorDisp~=63,2)
    % sum( sum(errorDisp~=63,2))
    time=toc
end;