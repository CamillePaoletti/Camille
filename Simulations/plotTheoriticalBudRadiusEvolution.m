function []=plotTheoriticalBudRadiusEvolution(R0,T,Rm)
%Camille Paoletti - 01/13
%plot theoritical radius evolution for an exponential growth of a sphere
%with initial radius R0 and doubling time T(min) from a mother of initial
%radius Rm

t=[0:1:T];

radius=@(x) ((3*x)/(4*pi))^(1/3);
volume=@(x) 4/3*pi*x^3;
evolutionVolume=@(x) volume(R0)+volume(Rm)*(exp(log(2)*x/T)-1);

evV=zeros(length(t),1);
evR=zeros(length(t),1);

cc=0;
for i =t
    cc=cc+1;
    evV(cc,1)=evolutionVolume(i);
    evR(cc,1)=radius(evV(cc));
end


%figure;
%plot(t,evV);
figure;
plot(t,evR,'LineWidth',2);
hold on;
xlabel('time (min)','Fontsize',12);
ylabel('bud radius (nm)','Fontsize',12);
title('Evolution of bud radius with time','Fontsize',12);
hold off;


x=evR;
y=(pi/(3*650*6e-4)).*(x.*x.*x).*1e-6/60;
figure;plot(t,y,'LineWidth',2);
hold on;
plot(t,t+37.17,'LineWidth',2,'Color','r');
%errorbar(rcell,m(10,:),sError(10,:),'r*','LineWidth',2);
xlabel('time (min)','Fontsize',12);
ylabel('Time to escape (min)','Fontsize',12);
title('Time to escape for an aggregate whose radius is 252 nm','Fontsize',12);
legend('theoritical escaping time','y=x','Fontsize',12);
set(gca,'Fontsize',12);
%axis([0  3000  0  2500]);
%line([0 3000], [90 90],'LineWidth',2,'Color',[0 1 0]);
hold off;

end