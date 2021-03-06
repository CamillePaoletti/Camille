function [] = simulationTestCrossing(filename)
%
%Camille - 12/2012
%
%read txtfiles of simulation3D and plot evolution of number of aggregates
%in bud and mother

%filename='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/results';


n=100;
nBud=zeros(1,n+1);
nCell=zeros(1,n+1);
rBud=zeros(1,n+1);
rCell=zeros(1,n+1);
rBudMin=zeros(1,n+1);
rCellMin=zeros(1,n+1);
rBudMax=zeros(1,n+1);
rCellMax=zeros(1,n+1);
rBudSderr=zeros(1,n+1);
rCellSderr=zeros(1,n+1);
time=[0:0.1:0.1*n];

for i=0:n
filename_temp=strcat(filename,'/',num2str(i),'.txt');
data=dlmread(filename_temp);
x=data(3:end,1);
y=data(3:end,2);
radius=data(3:end,4);
z=data(3:end,3);
Rcell=data(1,4);
Rbud=data(2,4);
Xbud=data(2,1);
Rcontact=650;
Xcontact=sqrt(Rcell^2-Rcontact^2);

numel1=find(x<=Xcontact);
numel2=find(x>Xcontact);
nBud(i+1)=length(numel2);
nCell(i+1)=length(numel1);
rBud(i+1)=mean(radius(numel2));
rCell(i+1)=mean(radius(numel1));
rBudMin(i+1)=min(radius(numel2));
rCellMin(i+1)=min(radius(numel1));
rBudMax(i+1)=max(radius(numel2));
rCellMax(i+1)=max(radius(numel1));
rBudSderr(i+1)=std(radius(numel2))/sqrt(nBud(i+1));
rCellSderr(i+1)=std(radius(numel1))/sqrt(nCell(i+1));

end

figure;
plot(time,nBud,'r+','LineWidth',2);
hold on;
plot(time,nCell,'b+','LineWidth',2);
set(gca, 'FontSize', 12);
legend('Bud','Mother');
title('Evolution of number of aggregates in bud and in mother');
xlabel('Time (sec)');
ylabel('Number of aggregates');
hold off;

figure;
plot(time,nBud./nBud(1),'r+','LineWidth',2);
hold on;
plot(time,nCell./nCell(1),'b+','LineWidth',2);
set(gca, 'FontSize', 12);
legend('Bud','Mother');
title('Evolution of number of aggregates in bud and in mother');
xlabel('Time (sec)');
ylabel('Number of aggregates/Initial number');
hold off;

figure;
errorbar(time,rBud,rBudSderr,'r+','LineWidth',2);
hold on;
errorbar(time,rCell,rCellSderr,'b+', 'LineWidth',2);
plot(time,rBudMin,'m+','LineWidth',2);
plot(time,rCellMin,'g+','LineWidth',2);
plot(time,rBudMax,'m+','LineWidth',2);
plot(time,rCellMax,'g+','LineWidth',2);
set(gca, 'FontSize', 12);
legend('Bud','Mother','Bud extrema', 'Mother extrema');
title('Evolution of radius of aggregates in bud and in mother');
xlabel('Time (sec)');
ylabel('Mean radius (nm) ');
hold off;

end