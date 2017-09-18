% clc;

errorNum=0;
errorNum4=0;
for i=1:height
	for j=1:width
        
        trueDisp=dispR(i,j,1);
% 		bestD=dispLRC(i,j,1);
        bestD=dddispR(i,j,1);
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

%%ONLY FOR TSUKUBA
% errorNum=0;
% errorNum4=0;
% for i=19:270	
% 	for j=19:366
%         
%         trueDisp=dispL(i,j,1);
% % 		bestD=dispLRC(i,j,1);
%         bestD=ddisp1(i,j,1);
%         if(abs(bestD-trueDisp)>2)
%             errorNum=errorNum+1;
%             errorDisp(i,j,1)=bestD*4;
%         end;
%         if(abs(bestD-trueDisp)>4)
%             errorNum4=errorNum4+1;
%             errorDisp4(i,j,1)=bestD*4;
%         end;        
%        
%     end;    
% end;
% disp([errorNum,errorNum4]);