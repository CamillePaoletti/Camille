function [out,zout,outX,Xout] = simulationTestDensity(filename);
%
%Camille - 10/2012
%
%read first txtfile of simulation3D and plot concentration for several
%stacks in z

%filename='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/testInit/results/0.txt';

data=dlmread(filename);
x=data(3:end,1);
y=data(3:end,2);
radius=data(3:end,4);
z=data(3:end,3);
Rcell=data(1,4);
Rbud=data(2,4);
Xbud=data(2,1);
Rcontact=650;
Xcontact=sqrt(Rcell^2-Rcontact^2);
step=200;
out=[];
zout=[];
outX=[];
Xout=[];
outY=[];
Yout=[];

numel1=find(x<=Rcell);
numel2=find(x>=Rcell);
z1=z(numel1);
z2=z(numel2);
x1=x(numel1);
x2=x(numel2);
y1=y(numel1);
y2=y(numel2);
%size(z1)
%size(z2)

st=2*Rcell/step;

for i=0:step-1
    zi_start=-Rcell+2*Rcell/step*i;
    zi_end=zi_start+2*Rcell/step;
    numel=find(zi_start<z1 & z1<zi_end);
    r2=Rcell^2-((zi_end+zi_start)/2)^2;
    concentration=length(numel)/(pi*r2*st);
    out=[out concentration];
    zout=[zout (zi_end+zi_start)/2];
end

a=strfind(filename,'_R');
str=filename(a+1:end);

% figure;
% plot(zout, out);
% hold on;
% title({'concentration of aggregates at t=0 in function of z stacks';[str,' - step=',num2str(step)]},'fontsize',12);
% xlabel('z (�m)','fontsize',12);
% ylabel('concentration of aggregates (�m^{-3})','fontsize',12);
% hold off;


for i=0:step-1
    zi_start=-Rcell+2*Rcell/step*i;
    zi_end=zi_start+2*Rcell/step;
    numel=find(zi_start<z2 & z2<zi_end);
    r2=Rbud^2-((zi_end+zi_start)/2)^2;
    concentration=length(numel)/(pi*r2*st);
    out=[out concentration];
    zout=[zout (zi_end+zi_start)/2];
end

a=strfind(filename,'_R');
str=filename(a+1:end);

figure;
plot(zout,out,'b-');
hold on;
plot(zout(1,1:step),out(1,1:step),'r-');
%plot(zout(1,n1+1:n2), out(1,n1+1:n2),'r-');
title({'concentration of aggregates at t=0 in function of z stacks';[str,' - step=',num2str(step)]},'fontsize',12);
xlabel('z (�m)','fontsize',12);
ylabel('concentration of aggregates (�m^{-3})','fontsize',12);
legend('bud','mother');
hold off;

numel1=find(x<=Xcontact);
numel2=find(x>=Xcontact);
z1=x(numel1);
z2=x(numel2);



temp_step=floor((Xcontact+Rcell)/st)+1;
for i=0:temp_step-1
    zi_start=-Rcell+st*i;
    zi_end=zi_start+st;
    numel=find(zi_start<z1 & z1<zi_end);
    r2=Rcell^2-((zi_end+zi_start)/2)^2;
    concentration=length(numel)/(pi*r2*st);
    outX=[outX concentration];
    Xout=[Xout (zi_end+zi_start)/2];
end

temp_step=floor((Xbud+Rbud-Xcontact)/st)+1;
for i=0:temp_step-1
    zi_start=Xcontact+st*i;
    zi_end=zi_start+st;
    numel=find(zi_start<z2 & z2<zi_end);
    r2=Rbud^2-((zi_end+zi_start)/2-Xbud)^2;
    concentration=length(numel)/(pi*r2*st);
    outX=[outX concentration];
    Xout=[Xout (zi_end+zi_start)/2];
end
temp_step=floor((Xcontact+Rcell)/st)+1;

figure;
plot(Xout,outX,'b-');
hold on;
plot(Xout(1,1:temp_step),outX(1,1:temp_step),'r-');
title({'concentration of aggregates at t=0 in function of x stacks';[str,' - step=',num2str(step)]},'fontsize',12);
xlabel('x (�m)','fontsize',12);
ylabel('concentration of aggregates (�m^{-3})','fontsize',12);
legend('bud','mother');
hold off;

z1=y1;
z2=y2;

for i=0:step-1
    zi_start=-Rcell+2*Rcell/step*i;
    zi_end=zi_start+2*Rcell/step;
    numel=find(zi_start<z1 & z1<zi_end);
    r2=Rcell^2-((zi_end+zi_start)/2)^2;
    concentration=length(numel)/(pi*r2*st);
    outY=[outY concentration];
    Yout=[Yout (zi_end+zi_start)/2];
end

for i=0:step-1
    zi_start=-Rcell+2*Rcell/step*i;
    zi_end=zi_start+2*Rcell/step;
    numel=find(zi_start<z2 & z2<zi_end);
    r2=Rbud^2-((zi_end+zi_start)/2)^2;
    concentration=length(numel)/(pi*r2*st);
    outY=[outY concentration];
    Yout=[Yout (zi_end+zi_start)/2];
end
figure;
plot(Yout,outY,'b-');
hold on;
plot(Yout(1,1:step),outY(1,1:step),'r-');
title({'concentration of aggregates at t=0 in function of y stacks';[str,' - step=',num2str(step)]},'fontsize',12);
xlabel('y (�m)','fontsize',12);
ylabel('concentration of aggregates (�m^{-3})','fontsize',12);
legend('bud','mother');
hold off;

n1=find(outY~=0);
n2=find(out~=0);

mX=mean(outX)
mY=mean(outY(n1))
mZ=mean(out(n2))


end

