




if(disp(i,j,1)<d_max*Rt)
{
	tempD=disp(i,j,1);
	while(disp(i+1,j,1)<=d_max*Rt)
		tempD=disp(i+1,j,1);
		i=i+1;
	end;
	tempD=disp(i+1,j,1);

	tempU=disp(i,j,1);
	while(disp(i-1,j,1)<=d_max*Rt)
		tempU=disp(i-1,j,1);
		i=i-1;
	end;
	tempU=disp(i-1,j,1);	
	
	tempR=disp(i,j,1);
	while(disp(i,j+1,1)<=d_max*Rt)
		tempR=disp(i,j+1,1);
		j=j+1;
	end;
	tempR=disp(i,j+1,1);
	
	tempL=disp(i,j,1);
	while(disp(i,j-1,1)<=d_max*Rt)
		tempL=disp(i,j-1,1);
		j=j-1;
	end;
	tempL=disp(i,j-1,1);	
	
	disp(i,j,1)=min( min(tempD,tempU),min(tempL,tempR) );

}