clc;
% clearvars;
% close all;
% clear all;

L = double(imread('L.png'));
R = double(imread('R.png'));
dispL = double(imread('dispL.png'))/4;
dispR = double(imread('dispR.png'))/4;

% mf=3;
% L1=L(:,:,1);
% L2=L(:,:,2);
% L3=L(:,:,3);
% LL1 = medfilt2(L1, [mf mf]);
% LL2 = medfilt2(L2, [mf mf]);
% LL3 = medfilt2(L3, [mf mf]);
% L(:,:,1)=LL1;
% L(:,:,2)=LL2;
% L(:,:,3)=LL3;
% R1=R(:,:,1);
% R2=R(:,:,2);
% R3=R(:,:,3);
% RR1 = medfilt2(R1, [mf mf]);
% RR2 = medfilt2(R2, [mf mf]);
% RR3 = medfilt2(R3, [mf mf]);
% R(:,:,1)=RR1;
% R(:,:,2)=RR2;
% R(:,:,3)=RR3;

temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
WINDOW_THRESHOLD=20;
T=60;
Ts=0.9;
T_IoU=0.1;
L_max=1700;

d_max=59;
errorNum=0;
errorNum4=0;
jumpNum=0;
jumpNum1=0;
temp=0;
temp4=0;
ddisp=zeros(height,width,1);
errorDisp = ones(height,width,1)*(63);
errorDisp4 = ones(height,width,1)*(63);
rc=10;

tic
for i=1:height       %
    i
	for j=1:width    %        
        %%
		[upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,L);
		pixelL_UD{i,j}=[upperL;downL];
		
		numUD=0;
		temppixelL_LR=[];
		for ud=-upperL:downL
			numUD=numUD+1;
			[leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,L);
			temppixelL_LR(:,numUD)=[leftL;rightL];		
		end;
		pixelL_LR{i,j}=temppixelL_LR;      
        %%
		[upperR,downR]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,R);
		pixelR_UD{i,j}=[upperR;downR];
		
		numUD=0;
		temppixelR_LR=[];
		for ud=-upperR:downR
			numUD=numUD+1;
			[leftR,rightR] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,R);
			temppixelR_LR(:,numUD)=[leftR;rightR];		
		end;
		pixelR_LR{i,j}=temppixelR_LR;         
    end;	
end;

for i=1:height       %
        disp([i-1,(i-1)*width,errorNum,errorNum4,errorNum-temp,errorNum4-temp4]);
%         disp([i-1,jumpNum,jumpNum1,(i-1)*width,errorNum,errorNum4,errorNum-temp,errorNum4-temp4]);
	temp=errorNum;
    temp4=errorNum4;
	for j=1:width    % 
        ttemp1=pixelL_UD{i,j};
		upperL=ttemp1(1,1);
        downL =ttemp1(2,1);
        Edp_max=0;
        for d=0:d_max
			if(j-d<1)
				continue;
			end;
            ttemp2=pixelR_UD{i,j-d};
			upperR=ttemp2(1,1);
            downR =ttemp2(2,1);
			if( (upperL+downL+1)*(1+Ts) < (upperR+downR+1) || (upperL+downL+1)*(1-Ts) > (upperR+downR+1) ) %shape similarity   
				jumpNum=jumpNum+1;
				continue;
			end;
			upper=min(upperL,upperR);
			down =min(downL, downR);
			numL_UD=((upperL-upper)+1);
			numR_UD=((upperR-upper)+1);

			Edp=0;
			sumUD=0;
			sumUDnum=0;
			temppixelL_LR=[];
			temppixelR_LR=[];
			for ud=-upper:down
%                 disp([i,j,d,upper,down,ud,numL_UD,numR_UD]);
				sumLR=0;
				sumLRnum=0;
				temppixelL_LR=pixelL_LR{i,j};
				temppixelR_LR=pixelR_LR{i,j-d};
                ttemp3=temppixelL_LR(:,numL_UD);
                ttemp4=temppixelR_LR(:,numR_UD);
				leftL =ttemp3(1,1); 
                rightL=ttemp3(2,1); 
				leftR =ttemp4(1,1); 
                rightR=ttemp4(2,1); 
				numL_UD=numL_UD+1;
				numR_UD=numR_UD+1;
				left =min(leftL,leftR);
				right=min(rightL,rightR);
				sumLRnum=left+right+1;
				sumUDnum=sumUDnum+sumLRnum;
				for lr=-left:right
					dL = double(abs( L(i+ud,j+lr,1)-R(i+ud,j-d+lr,1)) );
					da = double(abs( L(i+ud,j+lr,2)-R(i+ud,j-d+lr,2)) );
					db = double(abs( L(i+ud,j+lr,3)-R(i+ud,j-d+lr,3)) );
					eds=exp( -(sqrt(dL*dL+da*da+db*db)/rc) );                                      
					sumLR=sumLR+eds;
				end;
				% sumLR=left+right+1;
				sumUD=sumUD+sumLR;
			end;

%             if(  sumUDnum<numL(i,j,1)*T_IoU )   %IoU   
%                 jumpNum1=jumpNum1+1;
%                 continue;
%             end; 

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
			errorDisp(i,j,1)=bestD;
		end;
	   if(abs(bestD-trueDisp)>4)
			errorNum4=errorNum4+1;
			errorDisp4(i,j,1)=bestD;
		end;
    end;	
end;
disp([rc,i,i*width,errorNum,errorNum4]);
run('C:\Users\NKU\Desktop\cross\IoU\optimization\Test22.m');
% run('C:\Users\NKU\Desktop\cross\IoU\Test22.m');
% file=['rc\','matlab',num2str(rc),'.mat']; 
% save(file);
% sum(errorDisp~=63,2)
% sum( sum(errorDisp~=63,2))
time=toc
