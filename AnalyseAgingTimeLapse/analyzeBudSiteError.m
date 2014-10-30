function []=analyzeBudSiteError(user)
%Camille Paoletti - 11/2011
%
%ex: []=deathAgeVSfirstCrisis('');

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
numel1=find(str2double(DATA.data(:,6))~=0 & strncmp('1G',DATA.data(:,1),2) & str2double(DATA.data(:,7))~=0);
numel2=find(str2double(DATA.data(:,6))~=0 & strncmp('1H',DATA.data(:,1),2) & str2double(DATA.data(:,7))~=0);
numel=vertcat(numel1,numel2);
L=length(numel);
str=cell(L,1);
str2=cell(L,1);
bud=cell(L,1);
div=cell(L,1);
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
    
    div{i,1}=segmentation.tcells1(1,line).divisionTimes(1,:);
    
end


s=zeros(L,2);
for i=1:L
       s(i,1)=length(bud{i,1});
       s(i,2)=length(div{i,1});
end

Times=cell(L,3);
for i=1:L
    t=min(s(i,1),s(i,2));

    Times{i,1}=(bud{i,1}(1:t)-div{i,1}(1:t))*double(interval{i,1})/60;
    
    if s(i,1)==s(i,2)
        Times{i,2}=(div{i,1}(2:t)-bud{i,1}(1:t-1))*double(interval{i,1})/60;
    else
        Times{i,2}=(div{i,1}(2:t+1)-bud{i,1}(1:t))*double(interval{i,1})/60;
    end
    Times{i,3}=(div{i,1}(2:end)-div{i,1}(1:end-1))*double(interval{i,1})/60;
end

crisis=cell(L,3);
CrisisN=cell(L,3);
for i=1:L
    crisis{i,1}=find(Times{i,1}(1:end)>50);
    CrisisN{i,1}=crisis{i,1}(2:end);
    crisis{i,2}=find(Times{i,2}(1:end)>70);
    CrisisN{i,2}=crisis{i,2}(2:end);
    crisis{i,3}=find(Times{i,3}(1:end)>130);
    CrisisN{i,3}=crisis{i,3};
end

M=max(max(s));
CrisisT=cell(3,1);
%n=zeros(3,1);
for k=1:3
    CrisisT{k,1}=cat(2,CrisisN{:,k});
    %n(k,1)=max(CrisisT{k,1});
end

%histogramm
tTOT=str2double(DATA.data(numel,3));
[f,x] = ecdf(tTOT,'function', 'survivor');
m=max(tTOT);
nb=zeros(m,1);
for i=1:m
   nb(i,1)=length(find(tTOT==double(i)));
end
nb=vertcat(0,nb);
cum=cumsum(nb);
cum=(L*ones(m+1,1)-cum);

Colors={'r','b','g'};

CrisisHist=zeros(M,3);
for k=1:3
    for i=1:M
        CrisisHist(i,k)=length(find(CrisisT{k,1}==i))./cum(i);
    end
end

figure;
hold on;
%for k=1:3
    bar(CrisisHist(:,1:2));
%end
legend('G1','S/G2/M','total');
title('Distribution of crisis');
xlabel('generation number');
ylabel('frequency of crisis');
hold off;


CrisisTN=cell(3,1);
CrisisNorm=cell(3,1);
for k=1:3
    for i=1:L
        CrisisNorm{i,k}=CrisisN{i,k}./tTOT(i);
    end
    CrisisTN{k,1}=cat(2,CrisisNorm{:,k});
end

CrisisHistN=zeros(10,3);
a=[0.05:0.1:0.95];
xscale=horzcat(transpose(a),transpose(a));
for k=1:3
    for i=1:10
        A=CrisisTN{k,1}>(i-1)/10;
        B=CrisisTN{k,1}<=i/10;
        C=A.*B;
        CrisisHistN(i,k)=length(find(C==1));
    end
end
figure;
hold on;
%for k=1:3
    bar(xscale,CrisisHistN(:,1:2));
%end
legend('G1','S/G2/M','total');
title('Distribution of crisis - normalized life span');
xlabel('generation number (normalized)');
ylabel('number of crisis');
hold off;

CrisisD=cell(3,1);
for k=1:3
    for i=1:L
        b=size(CrisisN{i,k},2);
        for j=1:b
            CrisisD{i,k}(1,j)=Times{i,k}(1,CrisisN{i,k}(1,j));
        end
    end
end

CrisisDT=cell(3,1);
for k=1:3
    CrisisDT{k,1}=cat(2,CrisisD{:,k});
end

CrisisHistD=zeros(10,3);

a=[5:10:1995];
xscale=horzcat(transpose(a),transpose(a));
for k=1:3
    for i=1:200
        A=CrisisDT{k,1}>(i-1)*10;
        B=CrisisDT{k,1}<=i*10;
        C=A.*B;
        CrisisHistD(i,k)=length(find(C==1));
    end
end
figure;
hold on;
%for k=1:3
    bar(xscale,CrisisHistD(:,1:2));
%end
legend('G1','S/G2/M','total');
title('Distribution of duration of crisis');
xlabel('duration of crisis (min)');
ylabel('counts');
hold off;




end