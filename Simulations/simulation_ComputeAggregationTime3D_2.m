function [t,m,sError,data,per] = simulation_ComputeAggregationTime3D_2(filepath);
%
%Camille Paoletti - 02/2014 - adapted from simulationComputeAggregationTime3D 12/2012
%
%read .txt file containing exit timing, compute mean & standard error... and plot

%filepath='/Volumes/data7/paoletti/Simulations/data/probaExit/';

ragg=[8 20 50 100 250];
rcell=[940 1500 2000 2300 2500];
rcontact=[650 775 900];
nbAgg=length(ragg);
nbCell=length(rcell);
nbContact=length(rcontact);
t=cell(nbAgg,nbCell,nbContact);
per=cell(nbAgg,nbCell);
m=zeros(nbAgg,nbCell,nbContact);
sError=zeros(nbAgg,nbCell);

c=0;
for i=ragg
    c=c+1;
    filepath_temp=strcat(filepath,'Ragg_',num2str(i));
    cc=0;
    for j=rcell;
        cc=cc+1;
        filepath_temp2=strcat(filepath_temp,'-Rcell_',num2str(j));
        ccc=0;
        for k=rcontact;
            ccc=ccc+1;
            filename=strcat(filepath_temp2,'-Rcont_',num2str(k),'/timing.txt');
            a=dlmread(filename);
            t{c,cc,ccc}=a;
            m(c,cc,ccc)=median(a)/60;%mean(a)/60
            %sError(j,cc)=std(a)/sqrt(50)/60;
            %p= prctile(a,[25 50 75]);
            %per{j,cc}=p;
            %sError(j,cc)=(p(1,3)-p(1,1))/2/60;
            sError(c,cc,ccc)=mad(a/60,1);%mean absolute deviation
        end
        
    end
end


c=0;
l=0;
for i=ragg
    c=c+1;
    cc=0;
    for j=rcell
        cc=cc+1;
        ccc=0;
        l=l+1;
        for k=rcontact
            ccc=ccc+1;
            data(l,1,ccc)=i;
            data(l,2,ccc)=j;
            data(l,3,ccc)=m(c,cc,ccc);
            data(l,4,ccc)=sError(c,cc,ccc);
        end
    end
end

[X,Y]=meshgrid(ragg,rcell);
Z=ones(nbCell,nbAgg).*60;
j=0;
pl=ragg;
for i=pl
    j=j+1;
    %X13(1,j)=((4e-21*1300*90)/(i*4*pi^2*0.8e-3))^(1/3)*1e9;
    X13(1,j)=((3*1300e-3*60*60*8e-4*450)/(2*pi*i))^(1/3)*1e3;% (3*d_open(µm)*T_cellcycle(min)*60sec*D*R / 2*pi*ragg)^(1/3) = rcell supossé (en nm)
end
st=1000;
n=length(pl);
X2=vertcat(X13,X13,X13,X13,X13);
Y2=vertcat(pl,pl,pl,pl,pl);
Z2=vertcat(ones(1,n).*0,ones(1,n).*st,ones(1,n).*(2*st),ones(1,n).*(3*st),ones(1,n).*(4*st));


figure;
%plot3(data(:,1),data(:,2),data(:,3),'b*');
[h]=plot3d_errorbars(data(:,1,1),data(:,2,1),data(:,3,1),data(:,4,1));
%axis square;
axis normal
hold on;
%p=mesh(X,Y,Z);
mesh(X,Y,Z);
%set(p,'facecolor','none');
p=mesh(Y2,X2,Z2);
set(p,'facecolor','none');
title(['Distributuion of time to escape from cell in function of cell radius (100 draws)']);
xlabel('aggregate radius (nm)');
ylabel('cell radius (nm)');
zlabel('time to escape (min)');
ylim([0 3000]);
hold off;


x=[0:10:3000];
y=(pi/(3*650*8e-4*450/250)).*(x.*x.*x).*1e-6/60;% pi / (3*rcontact*DR/Ragg) * Rcell^3 /60
figure;plot(x,y,'LineWidth',2);
hold on;
errorbar(rcell,m(5,:,1),sError(5,:,1),'r*','LineWidth',2);
xlabel('Cell radius (nm)','Fontsize',12);
ylabel('Time to escape (min)','Fontsize',12);
title('Time to escape for an aggregate whose radius is 250 nm','Fontsize',12);
legend('theory T ~R^3','median of 100 simulations','Fontsize',12);
set(gca,'Fontsize',12);
%axis([0  3000  0  2500]);
%line([0 3000], [90 90],'LineWidth',2,'Color',[0 1 0]);
hold off;

x=[0:10:350];
y=(pi*1500^3/(3*650*8e-4*450)).*(x).*1e-6/60;
figure;plot(x,y,'LineWidth',2);
hold on;
errorbar(ragg,m(:,2,1),sError(:,2,1),'r*','LineWidth',2);
%errorbar(ragg,m(:,1),sError(:,1),'r*','LineWidth',2);
xlabel('Aggregate radius (nm)','Fontsize',12);
ylabel('Time to escape (min)','Fontsize',12);
title('Time to escape for an aggregate in a cell whose radius is 1500 nm (100 draws)','Fontsize',12);
legend('theory T~R','median of 100 simulations','Fontsize',12);
set(gca,'Fontsize',12);
%line([0 350], [90 90],'LineWidth',2,'Color',[0 1 0]);
%axis([0  350  0  700]);
hold off;


end