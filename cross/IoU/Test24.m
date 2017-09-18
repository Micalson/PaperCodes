clc

L = double(imread('L.png'));
R = double(imread('R.png'));
dispL = double(imread('dispL.png'))/4;
dispR = double(imread('dispR.png'))/4;
temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
imageTs=zeros(height,width,1);
imageRowTs=zeros(height,width,1);
tic

for i=1:height       %shape similarity 
    i
    for j=1:width    %
        
        d=dispL(i,j,1);
        d=round(d);
        if(j-d<1)
            continue;
        end;
        imageTs(i,j,1)=numR(i,j-d,1)/numL(i,j,1);
        imageRowTs(i,j,1)=numRowR(i,j-d,1)/numRowL(i,j,1);
    end;
end;

ii=0;
for i=1:height       %
    i
    for j=1:width    %
        ii=ii+1;
        imageT(ii)=imageTs(i,j,1);
        imageRowT(ii)=imageRowTs(i,j,1);
    end;
end;

figure;plot(1:ii,imageT);
figure;plot(1:ii,imageRowT);


