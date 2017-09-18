% clc
errorDisp1 = ones(height,width,1)*(256);

errorNumMF=0;
mf_max=30;
m=0;
for mf=1:2:mf_max
    m=m+1;
    ddisp1 = medfilt2(dispLRC, [mf mf]);
    errorNum1=0; 
    for i=1:height
        for j=1:width
            trueDisp=dispL(i,j,1);
            bestDisp=ddisp1(i,j,1);
            if(abs(bestDisp-trueDisp)>2)
                errorDisp1(i,j,1)=bestDisp*4;
                errorWindow1(:,errorNum1+1)=[i;j];
                errorNum1=errorNum1+1;            
            end;           
        end;
    end; 
    errorNumMF(m)=errorNum1;
%     disp([mf,errorNum1]);
end;
% figure;plot(1:2:mf_max,errorNumMF,'-*');
[minNum index]=min(errorNumMF);

mf=2*index-1;
ddisp1 = medfilt2(dispLRC, [mf mf]);
errorNum=0; 
errorNum4=0;
for i=1:height
    for j=1:width
        trueDisp=dispL(i,j,1);
        bestDisp=ddisp1(i,j,1);
        if(abs(bestDisp-trueDisp)>2)
            errorDisp1(i,j,1)=bestDisp*4;
            errorWindow1(:,errorNum+1)=[i;j];
            errorNum=errorNum+1;            
        end;
        if(abs(bestDisp-trueDisp)>4)
            errorNum4=errorNum4+1;
            errorDisp4(i,j,1)=bestD*4;
        end; 
    end;
end; 
disp([mf,errorNum,errorNum4]);
% ddisp1=ddisp1*4;
% figure;imshow(ddisp1,[]);