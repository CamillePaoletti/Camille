function []=RLSplot(fluo)
%Camille Paoletti - 09/2011
%plot RLS from database Data

%loading data base
load('L:\common\matlab\straindb\db\Data\Common_Data.mat');
%load('E:\Mes documents\MATLAB\phD\straindb\db\Data\Common_Data.mat');

%%extracting data to plot
%all data points
if fluo==1
    numel1=find(strncmp('1A',database.data(:,1),2));
    numel2=find(strncmp('1C',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel=vertcat(numel1,numel2);
elseif fluo==2
    numel1=find(strncmp('1G',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel2=find(strncmp('1F',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel3=find(strncmp('1H',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel=vertcat(numel1,numel2,numel3);
elseif fluo==3
    numel1=find(strncmp('1A',database.data(:,1),2));
    numel2=find(strncmp('1C',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel3=find(strncmp('1G',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel4=find(strncmp('1F',database.data(:,1),2) & str2double(database.data(:,7))~=0);
    numel=vertcat(numel1,numel2,numel3,numel4);
end
t{1}=str2double(database.data(numel,3));
censored=str2double(database.data(numel,5));
censored=logical(censored);
numel=find(censored);
censored=ones(length(censored),1);
censored(numel)=0;

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

t{2}=str2double(database.data(numel,3));

m=zeros(2);
M=zeros(2);
s=zeros(2);
for i=1:2
    m(i)=mean(t{i});
    M(i)=median(t{i});
    s(i)=std(t{i});
end
m3 = moment(t{2},3);
m4 = moment(t{2},4);
JB=length(t{2})/6*((m3/s(2)^3)^2+((m4/s(2)^4)-3)^2/4);
[h,p,jbstat] = jbtest(t{2});


figure;
t{1}=int8(t{1});
censored=int8(censored);
[f,x,flo,fup] = ecdf(t{1},'censoring',censored, 'function', 'survivor');
stairs(x,f,'LineWidth',2)
hold on
stairs(x,flo,'r:','LineWidth',2)
stairs(x,fup,'r:','LineWidth',2)
xlabel('generation number');
ylabel('survival');
title('Survival curve');

figure;
hold on;
subplot(1,2,1);
title('survival curve: dead cells only');
ecdf(t{2},'function', 'survivor');
xlabel('generation number');
ylabel('survival');
subplot(1,2,2);
title('survival curve: all cells');
ecdf(t{1},'function', 'survivor');
xlabel('generation number');
ylabel('survival');
hold off;

figure;
hold on;
title(['survival curve: dead cells only (',num2str(length(t{2})),' cells). Mean=',num2str(m(2)),'. median=',num2str(M(2)), '. std=',num2str(s(2)),'.']);
ecdf(t{2},'function', 'survivor');
xlabel('generation number');
ylabel('survival');
hold off;

figure;
hist(t{2},[0:5:50]);

for i=1:2
    if i==1;
        fprintf('all cells:\n');
    elseif i==2;
        fprintf('dead cells only;\n JB=%f\n p=%f\n stat=%f\n',JB,p,jbstat);
    end
    fprintf('mean: %f \n median: %f \n standard deviation: %f \n\n',m(i),M(i),s(i));
end

figure;
qqplot(t{2});



end