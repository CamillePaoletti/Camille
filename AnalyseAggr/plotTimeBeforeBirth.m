function [t,f,d]=plotTimeBeforeBirth
%Camille Paoletti -05/2012
%plot time between detection frame and first appearance of foci for each cell

global segmentation

n=[segmentation.tcells1.N];
pix=find(n~=0);

n=length(pix);
t=zeros(3,n);
c=1;
for k=pix
    a=[segmentation.tcells1(1,k).Obj.vx];
    if find(a)
        cc=1;
        while(segmentation.tcells1(1,k).Obj(1,cc).vx==0);
            cc=cc+1;
        end
        t(1,c)=cc;
        t(2,c)=segmentation.tcells1(1,k).detectionFrame;
        if numel(segmentation.tcells1(1,k).daughterList);
            t(3,c)=segmentation.tcells1(1,segmentation.tcells1(1,k).daughterList(1)).detectionFrame;
        else 
            t(3,c)=NaN;
        end
    else
        t(1,c)=0;
        %t(2,c)=0;
    end
    c=c+1;
end
f=t;
t=t.*3;

d=t(3,:)-t(2,:)-t(1,:);
pix2=isfinite(d);
pix2=find(pix2==1);
d=d(pix2);

figure;
hold on;
plot(pix,t(1,:),'b*');
xlabel('cell number');
ylabel('time (min)');
title(['timing of the first focus appearance (',num2str(length(t(1,:))),' cells)']);

a=get(gcf,'CurrentAxes');
ax=floor(axis(a));
b=30;
e=80;

str='time beetween detection frame and appearance';
str1=['mean: ',num2str(mean(t(1,:)))];
str2=['sdt error: ',num2str(std(t(1,:))/sqrt(length(t(1,:))))];
text(ax(3)+e,ax(2)+b,str);
text(ax(3)+e+3,ax(2)+b-10,str1);
text(ax(3)+e+3,ax(2)+b-20,str2);
plot(pix(pix2),d,'r+');
str='time between appearance and daughters detection';
str1=['mean: ',num2str(mean(d))];
str2=['sdt error: ',num2str(std(d)/sqrt(length(d)))];
text(ax(3)+e,ax(2)+b-40,str);
text(ax(3)+e+3,ax(2)+b-50,str1);
text(ax(3)+e+3,ax(2)+b-60,str2);
legend('time beetween detection frame and appearance', 'time between appearance and daughters detection');
hold off;

end