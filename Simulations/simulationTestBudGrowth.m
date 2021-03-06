function []=simulationTestBudGrowth(filename)
%Camille Paoletti - 10/2012
%plot evolution of total volume

data=dlmread(filename);
t=data(:,1)./60;
rbud=data(:,2)/1e3;

ouv=650;
Rcell=2500;
%Rbud=940;

V=zeros(length(t),1);

hauteur=@(r,a) sqrt(r^2-a^2);
volume=@(r,h,a) 2*pi/3*(r^3+r^2*h)+pi/3*a^2*h;

hmother=hauteur(Rcell,ouv);
Vmother=volume(Rcell,hmother,ouv);

for i=1:length(t)
    hbud=hauteur(rbud(i,1),ouv);
    V(i,1)=Vmother+volume(rbud(i,1),hbud,ouv);

end

plot(V);
figure;
plot(t,log(V./V(1,1)));
hold on;
title('Evolution of the total volume','fontsize',12);
xlabel('time (min) ','fontsize',12);
ylabel('volume - log(V/V0)','fontsize',12);
hold off;

end