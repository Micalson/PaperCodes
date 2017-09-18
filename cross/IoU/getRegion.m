
function [] = getRegion(WINDOW_THRESHOLD,L_max,height,width,seed_y,seed_x,pImage_CIELab,upper,down)
% regionImage=ones(height,width,1)*(200);
regionImage=rgb2gray(pImage_CIELab);

for LL=-upper:down
    
	newSeed_y=seed_y+LL;
	
	 [leftL,rightL] = getRegionLR(WINDOW_THRESHOLD,L_max,height,width,newSeed_y,seed_x,pImage_CIELab);
	
	for LR=-leftL:rightL
		regionImage(newSeed_y,seed_x+LR,1)=1;
        if(newSeed_y==seed_y && seed_x+LR==seed_x)
            regionImage(newSeed_y,seed_x+LR,1)=255;
        end;
	end;
	
end;

figure;
imshow(regionImage,[]);