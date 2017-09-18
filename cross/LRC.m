% function [dispLRC] = LRC_Check(height,width,dispL,dispR);
clc
% clear all

temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
errorNum0=0;
errorNum1=0;
errorNum2=0;
dispR = double(imread('dispR.png'))/8;
% disp=disp*4;
for i=1:height
	for j=1:width
        if(abs(dddisp(i,j,1)-dispL(i,j,1))>2)
			errorNum0=errorNum0+1;            
        end
	end;
end;
errorNum0

for i=1:height
	for j=1:width
        if(abs(dddispR(i,j,1)-dispR(i,j,1))>2)
			errorNum1=errorNum1+1;            
        end
	end;
end;
errorNum1

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
temp1=sum(sum(dispLRC==100,2))

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
temp2=sum(sum(dispLRC==100,2))

for i=1:height
	for j=1:width
        if(abs(dispL(i,j,1)-dispLRC(i,j,1))>2)
			errorNum2=errorNum2+1;            
        end
	end;
end;
errorNum2
figure;imshow(dispLRC,[]);		