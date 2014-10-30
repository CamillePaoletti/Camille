function simulation_plateauFunctionOfRadius
%Camille Paoletti - 01/2014
%plot plateau in function of radius for 1D simulation


r=[1:10];
plateau=zeros(1,length(r));

for R=r
   MSD=diffusion1D(10000,1000,1,1,R);
   plateau(1,R)=mean(MSD(400:500));
   err(1,R)=std(MSD(400:500));
end


figure;
subplot(1,2,1);
errorbar(r,plateau,err,'b+');
hold on;
xlabel('Radius');
ylabel('Plateau');
title('Plateau in function of the radius');
hold off;

x=r.*r;
y=plateau;
p=polyfit(x,y,1);
disp(p);
val=polyval(p,x);
subplot(1,2,2);
errorbar(x,y,err,'b+');
hold on;
plot(x,val,'r-');
xlabel('Squared Radius');
ylabel('Plateau');
hold off;

end