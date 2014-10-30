function [out,zout] = simulationTestDensityX(filename);
%
%Camille - 10/2012
%
%read first txtfile of simulation3D and plot concentration for several
%stacks in z


data=dlmread(filename);
x=data(:,1);
y=data(:,2);
radius=data(:,4);
z=data(:,3);
R=2500;
Rbud=940;
step=200;
out=[];
zout=[];

numel1=find(x<=R);
numel2=find(x>=R);
z1=x(numel1);
z2=x(numel2);
size(z1)
size(z2)


for i=0:step-1
    zi_start=-R+2*R/step*i;
    zi_end=zi_start+2*R/step;
    numel=find(zi_start<z1 & z1<zi_end);
    r2=R^2-((zi_end+zi_start)/2)^2;
    concentration=length(numel)/(pi*r2*R/step);
    out=[out concentration];
    zout=[zout (zi_end+zi_start)/2];
end

a=strfind(filename,'_R');
str=filename(a+1:end);

% figure;
% plot(zout, out);
% hold on;
% title({'concentration of aggregates at t=0 in function of z stacks';[str,' - step=',num2str(step)]},'fontsize',12);
% xlabel('z (µm)','fontsize',12);
% ylabel('concentration of aggregates (µm^{-3})','fontsize',12);
% hold off;


for i=0:step-1
    zi_start=-R+2*R/step*i;
    zi_end=zi_start+2*R/step;
    numel=find(zi_start<z2 & z2<zi_end);
    r2=Rbud^2-((zi_end+zi_start)/2)^2;
    concentration=length(numel)/(pi*r2*R/step);
    out=[out concentration];
    zout=[zout (zi_end+zi_start)/2];
end

a=strfind(filename,'_R');
str=filename(a+1:end);

figure;
plot(zout,out,'b-');
hold on;
plot(zout(1,1:200),out(1,1:200),'r-');
%plot(zout(1,n1+1:n2), out(1,n1+1:n2),'r-');
title({'concentration of aggregates at t=0 in function of z stacks';[str,' - step=',num2str(step)]},'fontsize',12);
xlabel('z (µm)','fontsize',12);
ylabel('concentration of aggregates (µm^{-3})','fontsize',12);
legend('bud','mother');
hold off;


end

