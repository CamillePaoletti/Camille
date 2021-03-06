function [NbTot]=simulationLogN(filepath)
%Camille Paoletti - 10/2012

%plot Log N =f ( Log(T) )


filepathSec=strcat(filepath);
directory=dir(filepathSec);

cc=0;
for j=1:length(directory)
    if strfind(directory(j,1).name,'time')
        cc=cc+1;
    end
end

NbTot=zeros(cc,1);


for k=0:cc-1
    k
    str=strcat(filepathSec,'time_',num2str(k),'.txt');
    data=dlmread(str);
    NbTot(k+1,1)=data(end,1);
end

n=length(NbTot);
X=[0.1:0.1:0.1*(n)]./60;
X=X./(0.1/60);
figure;plot(log(X),log(NbTot));%,'LineWidth',2);
hold on;
title('Evolution of the number of aggregates','fontsize',12);
xlabel('time - log(t/t0) ','fontsize',12);
ylabel('number of aggregates - log(number)','fontsize',12);
hold off;
ylim([0,10]);


a=20;
b=403;
x=log(X(1,a:b));
y=log(NbTot(a:b,1));
y=transpose(y);
y=y(1,1:length(x));
n=1;
[p,S] = polyfit(x,y,n);

hold on;
plot(x,p(1,1)*x+p(1,2),'r-');
hold off;


end