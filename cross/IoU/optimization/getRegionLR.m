
function [left,right] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,seed_y,seed_x,pImage_CIELab)
left=0;
right=0;
for L=1:L_max
	Position_y=seed_y;
	Position_x=seed_x-L;
	if(Position_x<1)
		break;
	end;
	dL = abs( pImage_CIELab(seed_y,seed_x,1)-pImage_CIELab(Position_y,Position_x,1) );
	da = abs( pImage_CIELab(seed_y,seed_x,2)-pImage_CIELab(Position_y,Position_x,2) );
	db = abs( pImage_CIELab(seed_y,seed_x,3)-pImage_CIELab(Position_y,Position_x,3) );
	if(max(max(dL,da),db) < WINDOW_THRESHOLD)
		left=L;
	else
		break;
	end;
end;

for L=1:L_max
	Position_y=seed_y;
	Position_x=seed_x+L;
	if(Position_x>width)
		break;
	end;
	dL = abs( pImage_CIELab(seed_y,seed_x,1)-pImage_CIELab(Position_y,Position_x,1) );
	da = abs( pImage_CIELab(seed_y,seed_x,2)-pImage_CIELab(Position_y,Position_x,2) );
	db = abs( pImage_CIELab(seed_y,seed_x,3)-pImage_CIELab(Position_y,Position_x,3) );
	if(max(max(dL,da),db) < WINDOW_THRESHOLD)
		right=L;
	else
		break;
	end;
end;
		