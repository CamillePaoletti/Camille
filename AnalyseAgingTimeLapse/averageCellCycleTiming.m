function [bud, TimesBHist, TimesF]=averageCellCycleTiming(user)
%Camille Paoletti - 10/2011
%plot average cell cycle timing as a function of generation
%number
%ex: [bud, TimesBHist, TimesF]=averageCellCycleTiming('');

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

M1=max(s(:,1))-1;

TimesN=cell(M1,L);
for i=1:L
       for k=1:(s(i,1)-1)
          TimesN{k,i}=double((bud{i,1}(k+1)-bud{i,1}(k))*interval{i,1}/60);
       end  
end

bin=4;

TimesF=cell(M1+bin,1);
for k=1:M1
    TimesF{k,1}=cat(2,TimesN{k,:});  
end

%histo

if mod(M1,bin)==0
    n=M1/bin;
else
    n=floor(M1/bin)+1;
end
TimesBHist=cell(n,1);
for l=0:n-1
    TimesBHist{l+1,1}=cat(2,TimesF{l*bin+1:(l+1)*bin,1});
end


M=zeros(M1,1);
STD=zeros(M1,1);
C=zeros(M1,1);
for k=1:M1
    M(k,1)=mean(TimesF{k,1});
    STD(k,1)=std(TimesF{k,1})/sqrt(length(TimesF{k,1}));
    C(k,1)=std(TimesF{k,1})/mean(TimesF{k,1});
end

H=zeros(n,1);
STDH=zeros(n,1);
CH=zeros(n,1);
for k=1:n
    H(k,1)=mean(TimesBHist{k,1});
    STDH(k,1)=std(TimesBHist{k,1})/sqrt(length(TimesBHist{k,1}));
    CH(k,1)=std(TimesBHist{k,1})/mean(TimesBHist{k,1});
end

figure;
hold on;
title(['Average cell cycle timings as a function of generation (',num2str(L),' cells)']);
errorbar(M(:,1),STD(:,1),'b-');
xlabel('generations'); ylabel('Average division time (min)');
hold off;

figure;
plot(C(:,1),'b-');
hold on;
title(['Coefficient of variation of average cell cycle timings (',num2str(L),' cells)']);
xlabel('Generation');
ylabel('COV');
hold off;

figure;
errorbar([bin/2:bin:n*bin-bin/2],H(:,1),STDH(:,1),'b-');
hold on;
title(['Average cell cycle duration in population subsets with different ages (',num2str(L),' cells)']);
xlabel('Generation');
ylabel('Average Cell Cycle Duration (in min)');
hold off;

figure;
plot([bin/2:bin:n*bin-bin/2],CH(:,1),'b-');
hold on;
title(['Coefficient of variation of Cell cycle duration in population subsets with different ages (',num2str(L),' cells)']);
xlabel('Generation');
ylabel('COV');
hold off;


end