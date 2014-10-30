function [MSD,SD_temp,MSD_rep,err]=simulationMSDplotTimeOnly(filepath)
%[MSD,err]=simulationMSDplot(filepath)
%
%Camille - 10/2012
%
%filepath ='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/MSD';
%filepath ='/Volumes/charvin/paoletti/Simulations/data/MSD';
%
%save MSD for all simulations
%plot :
%  MDS among time
N=30;

filepathSec=strcat(filepath,'/MSD_',num2str(1),'/results/');
directory=dir(filepathSec);
cc=0;

for j=1:length(directory)
    if strfind(directory(j,1).name,'.txt')
        cc=cc+1;
    end
end

%cc=10;

SD_temp=zeros(cc,N);
MSD_rep=zeros(cc,2);
MSD=zeros(cc,1);
err=zeros(cc,1);

for p=1:N
    
    fprintf('processing step %d/%d\n',p,N);
    filepathSec=strcat(filepath,'/MSD_',num2str(p),'/results/');
    
    x=zeros(cc,1);
    y=zeros(cc,1);
    z=zeros(cc,1);
    
    
    for k=0:cc-1
        str=strcat(filepathSec,num2str(k),'.txt');
        data=dlmread(str);
        x(k+1,1)=data(3,1)/1e3;
        y(k+1,1)=data(3,2)/1e3;
        z(k+1,1)=data(3,3)/1e3;
        
        %msd=((x-x0).*(x-x0)+(y-y0).*(y-y0)+(z-z0).*(z-z0));
        %MSD=[MSD,msd];
    end
    

    x0=x(1,1);
    y0=y(1,1);
    z0=z(1,1);
    
    for i=2:cc
        SD_temp(i,p)=(x(i,1)-x0)*(x(i,1)-x0)+(y(i,1)-y0)*(y(i,1)-y0)+(z(i,1)-z0)*(z(i,1)-z0);
    end
    
end


if N~=1
    MSD_rep(:,1)=mean(SD_temp,2);
    MSD_rep(:,2)=ones(cc,1).*N;
end


MSD(:,1)=(MSD_rep(:,1).*MSD_rep(:,2))./(MSD_rep(:,2));

for k=1:cc
    err(k,1)=std(SD_temp(k,:))/sqrt(MSD_rep(k,2));
end


x=[0:0.1:1.4*60]./60;
y=MSD;
y=transpose(y);
y=y(1,1:length(x));
n=1;
[p,S] = polyfit(x,y,n);


n=length(MSD);
X=[0:0.1:0.1*(n-1)]./60;
figure;plot(X,MSD(1:length(X)));%,'LineWidth',2);
hold on;
title('Mean Square Displacement','fontsize',12);
xlabel('time (min)','fontsize',12);
ylabel('mean square displacement (µm^{2})','fontsize',12);
plot(X,p(1,1)*X+p(1,2),'r-');
hold off;

X2=[0:20:0.1*(n-1)]./60;
Y2=[1:200:length(X)];
figure;errorbar(X2,MSD(Y2),err(Y2));%,'LineWidth',2);
hold on;
title('Mean Square Displacement','fontsize',12);
xlabel('time (min)','fontsize',12);
ylabel('mean square displacement (µm^{2})','fontsize',12);
hold off;



end