clc;

errorNum=0;
errorNum4=0;
for i=1:375       %212
    i
    for j=1:450   %165
        
        trueDisp=dispR(i,j,1);
		bestD=ddisp(i,j,1);
%         abs(bestD-trueDisp)
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
disp([errorNum,errorNum4]);