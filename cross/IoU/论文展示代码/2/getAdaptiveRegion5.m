% region is 0/1
function [Window,i,region, pixelIndex,newL] = getAdaptiveRegion5(WINDOW_THRESHOLD,height,width,seed_y,seed_x,pImage_CIELab,pixelIndex,regionIndex,newL,R,G,B)

tempImage=ones(height,width,1)*(200);
Window_j=1;
i_max=1000000;
% the ID of a pixel
region = zeros(height,width);
region(seed_y,seed_x)=1;
pixelIndex(seed_y,seed_x)=regionIndex;

% save all the pixels which meet the requirements of a seed
Window(:,Window_j)=[seed_y;seed_x];
Window_j=Window_j+1;

% save the pixels which meet the requirements of a seed in generation ii
Window_temp(:,1,1)=[seed_y;seed_x];

for i=1:i_max %the generation of the seeds
	temp=size(Window_temp(:,:,i));
%     if(i>1)
%         disp([i,Window_temp_num]);
%     end
    %temp(1,2) is the numbers of generation i
    Window_temp_j=1;
	Window_temp_num=0;
	for ii=1:temp(1,2)%the seeds of generation ii
        
		Position=Window_temp(:,ii,i);
		Position_y=Position(1,1);
		Position_x=Position(2,1);
        
		if(Position_y<1 || Position_y>height || Position_x<1 || Position_x>width)
%             disp([num2str(i),'   jump 1']);
			continue;
		end;
		
		for Wy = -1:1
			for Wx = -1:1
				Ix = Position_x + Wx;
				Iy = Position_y + Wy;
                if(Iy<1 || Iy>height || Ix<1 || Ix>width || region(Iy,Ix)==1)%every pixel belongs to some regions
					continue;
				end;
				dL = ( pImage_CIELab(Iy,Ix,1)-pImage_CIELab(seed_y,seed_x,1) );
                if(dL>-1 && dL<1)    
					Window_temp_num=Window_temp_num+1;% the number of the seeds in generation i
                    tempImage(Iy,Ix,1)=1;
					Window(:,Window_j)=[Iy;Ix];
					Window_j=Window_j+1;
					Window_temp(:,Window_temp_j,i+1)=[Iy;Ix];                    
					Window_temp_j=Window_temp_j+1;
					region(Iy,Ix)=1;
                    pixelIndex(Iy,Ix)=regionIndex;
                    newL(Iy,Ix,1)=R;
                    newL(Iy,Ix,2)=G;
                    newL(Iy,Ix,3)=B;
                else
                    tempImage(Iy,Ix,1)=150;
					region(Iy,Ix)=-1;				
				end;
								
			end;			
		end;		
    end
	if(Window_temp_num==0) 
        break;
    end;
end

end