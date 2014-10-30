function [obj]=failureRatePlot(fluo)
%Camille Paoletti - 09/2011
%plot failure rate from database Data
%ex: [obj]=failureRatePlot(3);

%loading data base
load('L:\common\matlab\straindb\db\Data\Common_Data.mat');

%dead data points only
if fluo==1
    numel1=find(str2double(database.data(:,5))~=0 & strncmp('1A',database.data(:,1),2));
    numel2=find(str2double(database.data(:,5))~=0 & strncmp('1C',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel=vertcat(numel1,numel2);
elseif fluo==2
    numel1=find(str2double(database.data(:,5))~=0 & strncmp('1G',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel2=find(str2double(database.data(:,5))~=0 & strncmp('1F',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel3=find(str2double(database.data(:,5))~=0 & strncmp('1H',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel=vertcat(numel1,numel2,numel3);
elseif fluo==3
    numel1=find(str2double(database.data(:,5))~=0 & strncmp('1A',database.data(:,1),2));
    numel2=find(str2double(database.data(:,5))~=0 & strncmp('1C',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel3=find(str2double(database.data(:,5))~=0 & strncmp('1G',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel4=find(str2double(database.data(:,5))~=0 & strncmp('1F',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel5=find(str2double(database.data(:,5))~=0 & strncmp('1H',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel=vertcat(numel1,numel2,numel3,numel4,numel5);
end

%statistical values
t=str2double(database.data(numel,3));
m=mean(t);
M=median(t);
s=std(t);

%experimental RLS
[R,z]=ecdf(t,'function', 'survivor');

%experimental Failure Rate calculation
z(1)=0;
z1=z(1:end-1,1);
z2=z(2:end,1);
dz=z2-z1;
r1=R(1:end-1,1);
r2=R(2:end,1);
FR=(r1-r2)./(r1.*dz);

%plot experimental RLS and Failure rate
figure;
hold on;
title(['survival curve: dead cells only (',num2str(length(t)),' cells). Mean=',num2str(m),'. median=',num2str(M), '. std=',num2str(s),'.']);
ecdf(t,'function', 'survivor');
plot(z,R,'g-');
plot(z(1:end-1),FR,'k-');
xlabel('generation number');
ylabel('survival');
legend('survival','survival','failure rate');
hold off;

%%fitting RLS
%histogram fitting
bin=3;
nbins=max(t)/bin+1;
nbGauss=2;
step1=0.1;
obj = gmdistribution.fit(t,nbGauss);
f = @(x)pdf(obj,x);
x = (0:step1:max(t))';
y = f(x);

xi=z(2);
xf=z(end);
I = sum(y * step1);
step2 = (xf-xi) / nbins;

figure;
n = hist(t,nbins);
J = sum(n*step2);
hist(t,nbins);
hold on;
plot(x,y * J / I,'r-','linewidth',3);
legend('histogram of generation',strcat('gaussian mixture distribution (',num2str(nbGauss),' gauss.)'));
xlabel('generation');
ylabel('Counts');
title('Distribution of generation');
hold off;

%gaussian mixture integral calculation
j= y*step1;
j=cumsum(j);
j=1-j;
figure;
ecdf(t,'function', 'survivor');
hold on;
plot(z,R,'g-');
plot(x,j,'r');
legend('experimental survival curve','experimental survival curve','gaussian mixture integral');
xlabel('generation');
ylabel('Density of probability (a.u.)');
title('Survival curve');
hold off;

%fitting failure rate
h=-diff(j)./(j(1:end-1)*step1);

figure;
ecdf(t,'function', 'survivor');
hold on;
plot(z,R,'g-');
plot(x,j,'r');
plot(z(1:end-1),FR,'k-');
plot(x(1:end-1),h,'r');
legend('experimental survival curve','experimental survival curve','gaussian mixture integral - fit survival curve','experimental failure rate','fit failure rate');
xlabel('generation');
ylabel('Density of probability (a.u.)');
title('Survival curve');
hold off;





end