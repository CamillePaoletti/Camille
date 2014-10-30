function []=simulationFindBudRadius()

b=500;
R=[0:1:2500];
n=length(R);
A=zeros(n,1);
T=5400;
t=[0:1:5400];

h=@(x) (b^2*pi)/(12)*x*sqrt(1-(b/(2*x))^2)+2*pi*x^3*(sqrt(1-(b/(2*x))^2)+1);

[Vi,RatioV,Vcelli,Vbudi]=computeCellTotvolume(2500,940,650);
evolutionVolume=@(x) Vi*2^(x/T);
for i=1:length(t)
   Vtot(i)=evolutionVolume(t(i)); 
end

cc=0;
for k=R
    cc=cc+1;
   [VtotB(cc)]=computeCellTotVolume(2500,k,650);
end


for i=1:n
    A(i)=h(R(i));
end


figure;
plot(R,A);
figure;
plot(t,Vtot);
figure;
plot(R,VtotB);
end