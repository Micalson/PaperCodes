% function [dispLRC] = LRC_Check(height,width,dispL,dispR);
% clc
% clear all

temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
errorNum=0;
errorNum4=0;

for i=1:height
	for j=1:width
        if(abs(dddisp(i,j,1)-dispL(i,j,1))>2)
			errorNum=errorNum+1;            
        end
         if(abs(dddisp(i,j,1)-dispL(i,j,1))>4)
			errorNum4=errorNum4+1;            
        end       
	end;    
end;
disp([errorNum,errorNum4]);

errorNum=0;
errorNum4=0;
for i=1:height
	for j=1:width
        if(abs(dddispR(i,j,1)-dispR(i,j,1))>2)
			errorNum=errorNum+1;            
        end
        if(abs(dddispR(i,j,1)-dispR(i,j,1))>4)
			errorNum4=errorNum4+1;            
        end        
	end;
end;
disp([errorNum,errorNum4]);

for i=1:height
	for j=1:width
	
		dL=dddisp(i,j,1);		
		if(j-dL<=0)%
			dispLRC(i,j,1)=100;
			continue;
		end;
				
		if(abs(dL-dddispR(i,j-dL,1))>1)
			dispLRC(i,j,1)=100;
		else
			dispLRC(i,j,1)=dL;
		end;
	
	end;
end;
temp1=sum(sum(dispLRC==100,2));

for i=1:height
	for j=1:width
		lj=j;
		rj=j;
		lp=100;
		rp=100;
		if(dispLRC(i,j,1)==100)
			
			if(lj-1<0)
				lp=dispLRC(i,j,1);
			end;
			while((lp==100)&&(lj-1>0))
				lj=lj-1;
				lp=dispLRC(i,lj,1);
			end;

			if(rj+1>height)
				rp=dispLRC(i,j,1);
			end;
			while((rp==100)&&(rj+1<height))
				rj=rj+1;
				rp=dispLRC(i,rj,1);
			end;
            
			dispLRC(i,j,1)=min(lp,rp);
% 			dispLRC(i,j,1)=(lp+rp)/2;
			
		end;
	end;
end;
temp2=sum(sum(dispLRC==100,2));

errorNum=0;
errorNum4=0;
for i=1:height
	for j=1:width
        if(abs(dispL(i,j,1)-dispLRC(i,j,1))>2)
			errorNum=errorNum+1;            
        end
        if(abs(dispL(i,j,1)-dispLRC(i,j,1))>4)
			errorNum4=errorNum4+1;            
        end
	end;
end;
disp([errorNum,errorNum4]);
% figure;imshow(dispLRC,[]);		