function compareMSDcomputation(path)

%Camille Paoletti - 01/2014

N=1;

pixel=1e-3
pixel2=pixel*pixel;

data=load(path);
x=data(1:N:end,1);
y=data(1:N:end,2);
z=data(1:N:end,3);


[MSD_O,err_O]=computeMSD3D_woOverlap(x,y,z,0);
[MSD,err]=computeMSD3D(x,y,z,0);


figure;
% errorbar(xd,yd,errd,'g+','LineWidth',2);
plot(MSD(:,1)*pixel2,'k-');
hold on;
plot(MSD_O(:,1)*pixel2,'b-');
% plot(xd,yfit,'g-');
%ylim([0 5e5]);
legend('3D-classic','3D-wo Overlap');
hold off;

end