function [obj]=distributionCellCycleTiming(user)
%Camille Paoletti - 11/2011
%
%ex: [obj]=distributionCellCycleTiming('');

%loading data bases
load('L:\common\matlab\straindb\db\Data\Common_Data.mat');
%load('E:\Mes documents\MATLAB\phD\straindb\db\Data\Common_Data.mat');
DATA=database;
load('L:\common\matlab\straindb\db\Experiments\Common_Experiments.mat');
%load('E:\Mes documents\MATLAB\phD\straindb\db\Experiments\Common_Experiments.mat');
EXP=database;

%user's path
if strcmp(user,'Gilles')
    path=[];
elseif strcmp(user,'Steffen')
    path=[];
else
    path='L:\common\movies\';
    %path='E:\Mes documents\PhD\';
end

%%extracting data to plot
%all data points
numel=find(str2double(DATA.data(:,7))~=0);
L=length(numel);
str=cell(L,1);
str2=cell(L,1);
bud=cell(L,1);
interval=cell(L,1);
for i=1:L
    %creating path corresponding to cell number i (with i: line in database)
    ID=DATA.data(numel(i),1);
    %%%%%%%%Be careful, problem for more than 9*26 experiments!!!%%%%%%%%
    a=find(strncmp(ID,EXP.data(:,1),2));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    experimenter=EXP.data(a,2);
    date=str2double(EXP.data(a,3));
    folder=EXP.data(a,4);
    name=EXP.data(a,5);
    pos=DATA.data(numel(i),2);
    str{i}=strcat(path,experimenter,'\20',num2str(int8(date/1e4)),'\20',num2str(int16(date/1e2)),'\',folder,'\',name,'-pos',pos,'\segmentation.mat');
    str2{i}=strcat(path,experimenter,'\20',num2str(int8(date/1e4)),'\20',num2str(int16(date/1e2)),'\',folder,'\','BK-project.mat');
    %loading segmentation data
    load(str{i}{1});
    load(str2{i}{1});
    %extraction of t-data for the interesting cell
%     n=size(segmentation.tcells1(1,:))
%     if n(2)~=1
%         sLine=zeros(n(2)-1,1);
%         for j=1:(n(2)-1)
%             sLine(j,1)=strcmp(num2str(segmentation.tcells1(1,j).N),DATA.data(numel(i),7));
%         end
%         line=find(sLine)
%     else line=1
%     end
    line=str2double(DATA.data{numel(i),7});
    fprintf('i=%d; numel=%d; line=%d \n',i,numel(i),line);
    
    l=length(segmentation.tcells1(1,line).budTimes(1,:));
    if l==0
        fprintf('WARNING: no bud times available for position %d \n',i);
    else
        bud{i,1}=segmentation.tcells1(1,line).budTimes(1,:);
        interval{i,1}=timeLapse.interval;
    end
    
end
 
s=zeros(L,1);
for i=1:L
       s(i,1)=length(bud{i,1});
end

n=5;
TimesN=cell(n,L);
c=0;
for i=1:L
    if s(i,1)>=n+1;
        c=c+1;
        for k=1:n
            TimesN{k,i}=double((bud{i,1}(k+1)-bud{i,1}(k))*interval{i,1}/60);
        end
    end
end

Times=cell(n,1);
for k=1:n
    Times{k,1}=cat(2,TimesN{k,:}); 
end

TimesF=cat(2,Times{1:n,1});

M=mean(TimesF);
STD=std(TimesF)/sqrt(length(TimesF));
C=std(TimesF)/mean(TimesF);

fprintf('Mean: %f \n Std: %f \n COV: %f',M,STD,C);


figure;
hold on;
title(['Distribution of cell cycle timings for the first five generations (',num2str(c),' cells)']);
hist(TimesF,15);
xlabel('division time (min)'); ylabel('bin');
hold off;

%histogram fitting
TimesF=transpose(TimesF);
bin=10;
nbins=max(TimesF)/bin;
nbGauss=1;
step1=0.1;
obj = gmdistribution.fit(TimesF,nbGauss);
f = @(x)pdf(obj,x);
x = (0:step1:max(TimesF))';
y = f(x);

xi=min(TimesF);
xf=max(TimesF);
I = sum(y * step1);
step2 = (xf-xi) / nbins;

figure;
%n = hist(TimesF,nbins);
J = sum(n*step2);
hist(TimesF,[5:10:max(TimesF+5)]);
hold on;
plot(x,y * J / I,'r-','linewidth',3);
legend('histogram of cell cycle timings',strcat('gaussian mixture distribution (',num2str(nbGauss),' gauss.)'));
xlabel('cell cycle timings');
ylabel('Counts');
title('Distribution of cell cycle timings for the first five generations');
hold off;

end