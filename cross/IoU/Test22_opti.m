% clc;

% tic;
errorNum=0;
errorNum4=0;
temp=0;
temp4=0;
% L_max=1700;

dddisp = ddisp;
for i=1:height       %212
%     disp([i-1,(i-1)*width,errorNum,errorNum4,errorNum-temp,errorNum4-temp4]);
    temp=errorNum;
    temp4=errorNum4;
    for j=1:width   %165
%         disp([i,j]);
        ttemp1=pixelL_UD{i,j};
		upperL=ttemp1(1,1);
        downL =ttemp1(2,1);

        edsNum=1;
        dTemp=0;
        numL_UD=1;
        for ud=-upperL:downL
            temppixelL_LR=pixelL_LR{i,j};
            ttemp3=temppixelL_LR(:,numL_UD);
            numL_UD=numL_UD+1;
            leftL =ttemp3(1,1); 
            rightL=ttemp3(2,1); 
            for lr=-leftL:rightL
                dTemp(edsNum) = ddisp(i+ud,j+lr,1);
                edsNum=edsNum+1;
            end;
        end;
        dTempMax=max(dTemp);
        
%         cc = histc(dTemp,0:dTempMax);
%         [max_num, max_index] = max(cc);
%         bestD=max_index-1;
        
        cc = histc(dTemp,1:dTempMax);
        [max_num, max_index] = max(cc);
        bestD=max_index;
        if (isempty(bestD))
%             bestD=0;
            bestD=ddisp(i,j,1);
        end;
        dddisp(i,j,1)=bestD;
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
% time=toc