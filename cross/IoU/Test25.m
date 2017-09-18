clc

L = double(imread('L.png'));
R = double(imread('R.png'));
dispL = double(imread('dispL.png'))/4;
dispR = double(imread('dispR.png'))/4;
temp=size(L);
height=temp(1,1,1);
width=temp(1,2,1);
imageIoU=zeros(height,width,1);
tic

for i=1:height       %shape similarity 
    i
    for j=1:width    %
        imageIoU(i,j,1)=numLR(i,j,1)/numL(i,j,1);
    end;
end;

ii=0;
for i=1:height       %
    i
    for j=1:width    %
        ii=ii+1;
        iimageIoU(ii)=imageIoU(i,j,1);
    end;
end;

figure;plot(1:ii,iimageIoU);


