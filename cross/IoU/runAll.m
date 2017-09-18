clc
clear all;

error=0;
error4=0;
for i=1:50
%     clear all;
%     if(temp=0)
%         i=21;
%     end;
    i
    ii=i;
    iii=i;
    file=['C:\Users\NKU\Desktop\cross\IoU\rc\','matlab',num2str(i),'.mat'];
    load(file); 
    file1=['C:\Users\NKU\Desktop\cross\IoU\right\rc\','dddispR',num2str(ii),'.mat'];
    load(file1);
    run('C:\Users\NKU\Desktop\cross\IoU\LRC.m');
    run('C:\Users\NKU\Desktop\cross\IoU\Test14.m');
    error(iii)=errorNum;
    error4(iii)=errorNum4;
    
    ddisp3=uint8(ddisp1);
    dispFilename=sprintf('disp%d',iii);
    imwrite(ddisp3,['C:\Users\NKU\Desktop\cross\IoU\disp\',dispFilename,'.png']);
    % ddisp2 = double(imread('C:\Users\NKU\Desktop\cross\IoU\disp\disp1.png'));    
end;
figure;plot(1:iii,error,'*-r');
hold on;
% figure;
plot(1:iii,error4,'^-b');
[minErr,bestRC]=min(error)
