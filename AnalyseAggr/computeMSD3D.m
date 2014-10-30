function [MSD,err]=computeMSD3D(x,y,z,experimental)
%
%Camille Paoletti - 06/2013
%
%compute MSD by averaging over time the displacement of a molecule whose
%coordinates are x, y and z


display=0;
if experimental
    pixel=0.083;
else
    pixel=1e-3;
end


cc=length(x);

MSD_temp=cell(cc-5,1);
MSD=zeros(cc-5,2);
err=zeros(cc,1);

MSD_temp{1,1}=[0];
MSD(1,2)=1;

for i=1:cc-6
    x0=x(1:end-i);
    x1=x(i+1:end);
    y0=y(1:end-i);
    y1=y(i+1:end);
    z0=z(1:end-i);
    z1=z(i+1:end);
    MSD_temp{i+1,1}=(x1-x0).*(x1-x0)+(y1-y0).*(y1-y0)+(z1-z0).*(z1-z0);
    MSD(i+1,1)=mean((x1-x0).*(x1-x0)+(y1-y0).*(y1-y0)+(z1-z0).*(z1-z0));
    MSD(i+1,2)=length(x0);
end


err(1,1)=0;
for k=2:cc-6+1
    err(k,1)=std(MSD_temp{k,1})/sqrt(MSD(k,2));
end


if display
    step=15;
    xp=[0:step:(cc-6+1-1)*step]
    yp=MSD
    yp=transpose(yp)
    yp=yp(1,1:length(xp))
    n=1;
    %nmax=
    [p,S] = polyfit(xp,yp,n);
    
    
    figure;plot(xp,MSD(1:length(xp))*pixel*pixel);%,'LineWidth',2);
    hold on;
    title('Mean Square Displacement','fontsize',12);
    xlabel('time (s)','fontsize',12);
    ylabel('mean square displacement (µm^{2})','fontsize',12);
    %plot(xp,p(1,1)*xp+p(1,2),'r-');
    hold off;
end



%loglog(x,y)


end