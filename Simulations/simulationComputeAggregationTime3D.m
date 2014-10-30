function [t,m,sError,data,per] = simulationComputeAggregationTime3D(filepath);
%
%Camille - 12/2012
%
%read .txt file containing t_agg, compute mean, standard error... and plot
%mustache box

%filepath='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/checkOut_RANDOM/';
%filepath='/Users/camillepaoletti/Simulations/SimulationAggregation/data/checkOut_RANDOM/';

step=[10 20 30 40 50 75 100 150 200 250 300];% 500];
rcell=[650 940 1500 2000 2500];
nbAgg=length(step);
nbCell=length(rcell);
t=cell(nbAgg,nbCell);
per=cell(nbAgg,nbCell);
m=zeros(nbAgg,nbCell);
sError=zeros(nbAgg,nbCell);

lab=cell(length(rcell),1);
cc=0;
for l=rcell
    cc=cc+1;
    filepath_temp=strcat(filepath,'RCELL_',num2str(l),'/');
    %filepath_temp=strcat(filepath,'/');
    j=0;
    for i=step;
        j=j+1;
        filename=strcat(filepath_temp,'R_',num2str(i),'/t_agg.txt');
        a=dlmread(filename);
        t{j,cc}=a;
        m(j,cc)=median(a)/60;%mean(a)/60
        %sError(j,cc)=std(a)/sqrt(50)/60;
        %p= prctile(a,[25 50 75]);
        %per{j,cc}=p;
        %sError(j,cc)=(p(1,3)-p(1,1))/2/60;
        sError(j,cc)=mad(a,1)/60;
    end
end


cc=0;
k=0;
for l=rcell
    cc=cc+1;
    j=0;
    for i=step
        j=j+1;
        k=k+1;
        data(k,1)=i;
        data(k,2)=l;
        data(k,3)=m(j,cc);
        data(k,4)=sError(j,cc);
    end
end

[X,Y]=meshgrid(step,rcell);
Z=ones(nbCell,nbAgg).*90;
j=0;
pl=step;%[200,300];
for i=pl
    j=j+1;
    %X13(1,j)=((4e-21*1300*90)/(i*4*pi^2*0.8e-3))^(1/3)*1e9;
    X13(1,j)=((3*1300e-3*90*60*6e-4*252)/(2*pi*i))^(1/3)*1e3;
end
st=1000;
n=length(pl);
X2=vertcat(X13,X13,X13,X13,X13);
Y2=vertcat(pl,pl,pl,pl,pl);
Z2=vertcat(ones(1,n).*0,ones(1,n).*st,ones(1,n).*(2*st),ones(1,n).*(3*st),ones(1,n).*(4*st));


figure;
%plot3(data(:,1),data(:,2),data(:,3),'b*');
[h]=plot3d_errorbars(data(:,1),data(:,2),data(:,3),data(:,4));
%axis square;
axis normal
hold on;
p=mesh(X,Y,Z);
%set(p,'facecolor','none');
p=mesh(Y2,X2,Z2);
set(p,'facecolor','none');
title(['Distributuion of time to escape from mother in function of cell radius (50 draws)']);
xlabel('aggregate radius (nm)');
ylabel('bud radius (nm)');
zlabel('time to escape (min)');
hold off;


x=[0:10:3000];
y=(pi/(3*650*6e-4)).*(x.*x.*x).*1e-6/60;
figure;plot(x,y,'LineWidth',2);
hold on;
errorbar(rcell,m(10,:),sError(10,:),'r*','LineWidth',2);
xlabel('bud radius (nm)','Fontsize',12);
ylabel('Time to escape (min)','Fontsize',12);
title('Time to escape for an aggregate whose radius is 252 nm','Fontsize',12);
legend('theory T ~R^3','median of 50 simulations','Fontsize',12);
set(gca,'Fontsize',12);
%axis([0  3000  0  2500]);
%line([0 3000], [90 90],'LineWidth',2,'Color',[0 1 0]);
hold off;

x=[0:10:350];
y=(pi*1500^3/(3*650*6e-4*252)).*(x).*1e-6/60;
figure;plot(x,y,'LineWidth',2);
hold on;
errorbar(step,m(:,3),sError(:,3),'r*','LineWidth',2);
%errorbar(step,m(:,1),sError(:,1),'r*','LineWidth',2);
xlabel('aggregate radius (nm)','Fontsize',12);
ylabel('Time to escape (min)','Fontsize',12);
title('Time to escape for an aggregate in a bud whose radius is 1500 nm (50 draws)','Fontsize',12);
legend('theory T~R','median of 50 simulations','Fontsize',12);
set(gca,'Fontsize',12);
%line([0 350], [90 90],'LineWidth',2,'Color',[0 1 0]);
%axis([0  350  0  700]);
hold off;


end