
function [upper,down] = getRegionUD(WINDOW_THRESHOLD,L_max,height,width,seed_y,seed_x,pImage_CIELab)
upper=0;
down=0;
for L=1:L_max
	Position_y=seed_y-L;
	Position_x=seed_x;
	if(Position_y<1)
		break;
	end;
	dL = abs( pImage_CIELab(seed_y,seed_x,1)-pImage_CIELab(Position_y,Position_x,1) );
	da = abs( pImage_CIELab(seed_y,seed_x,2)-pImage_CIELab(Position_y,Position_x,2) );
	db = abs( pImage_CIELab(seed_y,seed_x,3)-pImage_CIELab(Position_y,Position_x,3) );
	if(max(max(dL,da),db) < WINDOW_THRESHOLD)
		upper=L;
	else
		break;
	end;
end;

for L=1:L_max
	Position_y=seed_y+L;
	Position_x=seed_x;
	if(Position_y>height)
		break;
	end;
	dL = abs( pImage_CIELab(seed_y,seed_x,1)-pImage_CIELab(Position_y,Position_x,1) );
	da = abs( pImage_CIELab(seed_y,seed_x,2)-pImage_CIELab(Position_y,Position_x,2) );
	db = abs( pImage_CIELab(seed_y,seed_x,3)-pImage_CIELab(Position_y,Position_x,3) );
	if(max(max(dL,da),db) < WINDOW_THRESHOLD)
		down=L;
	else
		break;
	end;
end;
		