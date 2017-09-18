clc;

tic;
errorNum=0;
errorNum4=0;
dddisp = ddisp;
for i=1:height       %212
    disp([i-1,(i-1)*width,errorNum,errorNum4]);
    for j=1:width   %165
%         disp([i,j]);
        [upperL,downL]=getRegionUD(WINDOW_THRESHOLD,L_max,height,width,i,j,R);

        edsNum=1;
        dTemp=0;
        for ud=-upperL:downL 
            [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,i+ud,j,R);
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
        trueDisp=dispR(i,j,1);		
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