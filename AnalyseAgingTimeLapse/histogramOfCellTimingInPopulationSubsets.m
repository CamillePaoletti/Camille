function [TimesNHist,TimesFHist,TimesBHist]=histogramOfCellTimingInPopulationSubsets(user)
%Camille Paoletti - 10/2011
%plot average cell cycle duration for dead and alive cells for population subsets
%ex:
%[TimesNHist,TimesFHist,TimesBHist]=histogramOfCellTimingInPopulationSubsets('');

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
numel=find(strncmp('1G',DATA.data(:,1),2) & str2double(DATA.data(:,7))~=0);
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

M1=max(s(:,1));


M1=max(s(:,1));

TimesN=cell(M1,L);
for i=1:L
       for k=1:(s(i,1)-1)
          TimesN{k,i}=double((bud{i,1}(k+1)-bud{i,1}(k))*interval{i,1}/60);
       end  
end

%histogram of size in population subsets with different ages for alive and
%dead cells
bin=4;
n=floor(M1/bin)+1;
TimesNHist=cell(M1,L,2);
for i=1:L
    if mod(s(i,1),bin)~=0 
       xAlive=floor(s(i,1)/bin);
    else
       xAlive=floor(s(i,1)/bin)-1;
    end
    for p=1:bin*xAlive
        TimesNHist{p,i,1}=TimesN{p,i,1};
    end
    for p=(bin*xAlive+1):s(i,1)
        TimesNHist{p,i,2}=TimesN{p,i,1};
    end      
end

TimesFHist=cell(n*bin,2);
for k=1:M1
    for j=1:2
    TimesFHist{k,j}=cat(2,TimesNHist{k,:,j});
    end   
end

TimesBHist=cell(n,2);
for l=0:n-1
    for j=1:2
    TimesBHist{l+1,j}=cat(2,TimesFHist{l*bin+1:(l+1)*bin,j});
    end   
end

H=zeros(n,2);
STDH=zeros(n,2);
for k=1:n
    for j=1:2
    H(k,j)=mean(TimesBHist{k,j});
    STDH(k,j)=std(TimesBHist{k,j})/sqrt(length(TimesBHist{k,j}));
    C(k,j)=std(TimesBHist{k,j})/mean(TimesBHist{k,j});
    end   
end

figure;
errorbar([bin/2:bin:n*bin-bin/2],H(:,1),STDH(:,1),'b-');
hold on;
title(['Average cell cycle duration in population subsets with different ages for alive and dead cells (',num2str(L),' cells)']);
errorbar([bin/2:bin:n*bin-bin/2],H(:,2),STDH(:,2),'r-');
legend('alive','dead');
xlabel('Generation');
ylabel('Average Cell Cycle Duration (in min)');
hold off;

figure;
plot([bin/2:bin:n*bin-bin/2],C(:,1),'b-');
hold on;
title(['Coefficient of variation of Cell cycle duration in population subsets with different ages for alive and dead cells (',num2str(L),' cells)']);
plot([bin/2:bin:n*bin-bin/2],C(:,2),'r-');
legend('alive','dead');
xlabel('Generation');
ylabel('COV');
hold off;

end