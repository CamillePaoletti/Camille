function [SizeNHist,SizeFHist,SizeBHist]=histogramOfSizeInPopulationSubsets(user)
%Camille Paoletti - 10/2011
%plot average cell size for dead and alive cells for population subsets
%ex:
%[SizeNHist,SizeFHist,SizeBHist]=histogramOfSizeInPopulationSubsets('');

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
numel=find(str2double(DATA.data(:,5))~=0 & str2double(DATA.data(:,7))~=0);
L=length(numel);
str=cell(L,1);
Size=cell(L,2);
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
    %loading segmentation data
    load(str{i}{1});
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
        bud=segmentation.tcells1(1,line).budTimes(1,:);
        s=size(bud);
        bud=bud-ones(1,s(2)).*(segmentation.tcells1(1,line).detectionFrame-1);
    end
    %div=segmentation.tcells1(1,line).divisionTimes(1,:);
    %s=size(div);
    %div=div-ones(1,s(2)).*(segmentation.tcells1(1,line).detectionFrame-1);
    
    Obj=segmentation.tcells1(1,line).Obj(1,:);
    Size{i,1}=getYeastSize(bud,Obj);
    %Size{i,2}=getYeastSize(div,Obj);
end

s=zeros(L,2);
%average cell size at budding calculation
for i=1:L
    %for j=1:2
    j=1;
       s(i,j)=length(Size{i,j});
    %end   
end

M1=max(s(:,1));
%M2=max(s(:,2));

SizeN{:,1}=cell(M1,L);
%SizeN{:,2}=cell(M2,L);
for i=1:L
    %for j=1:2
    j=1;
       for k=1:s(i,j)
          SizeN{k,i,j}=Size{i,1}(k); 
       end
    %end   
end

%histogram of size in population subsets with different ages for alive and
%dead cells
bin=5;
n=floor(M1/bin)+1;
SizeNHist=cell(M1,L,2);
for i=1:L
    if mod(s(i,1),bin)~=0 
       xAlive=floor(s(i,1)/bin);
    else
       xAlive=floor(s(i,1)/bin)-1;
    end
    for p=1:bin*xAlive
        SizeNHist{p,i,1}=SizeN{p,i,1};
    end
    for p=(bin*xAlive+1):s(i,1)
        SizeNHist{p,i,2}=SizeN{p,i,1};
    end      
end

SizeFHist=cell(n*bin,2);
for k=1:M1
    for j=1:2
    SizeFHist{k,j}=cat(2,SizeNHist{k,:,j});
    end   
end

SizeBHist=cell(n,2);
for l=0:n-1
    for j=1:2
    SizeBHist{l+1,j}=cat(2,SizeFHist{l*bin+1:(l+1)*bin,j});
    end   
end

H=zeros(n,2);
STDH=zeros(n,2);
for k=1:n
    for j=1:2
    H(k,j)=mean(SizeBHist{k,j});
    STDH(k,j)=std(SizeBHist{k,j})/sqrt(length(SizeBHist{k,j}));
    C(k,j)=std(SizeBHist{k,j})/mean(SizeBHist{k,j});
    end   
end

figure;
errorbar([bin/2:bin:n*bin-bin/2],H(:,1),STDH(:,1),'b-');
hold on;
title(['Size in population subsets with different ages for alive and dead cells (',num2str(L),' cells)']);
errorbar([bin/2:bin:n*bin-bin/2],H(:,2),STDH(:,2),'r-');
legend('alive','dead');
xlabel('Generation');
ylabel('Average Cell Size (area in pix)');
hold off;

figure;
plot([bin/2:bin:n*bin-bin/2],C(:,1),'b-');
hold on;
title(['Variation coefficient of Size in population subsets with different ages for alive and dead cells (',num2str(L),' cells)']);
plot([bin/2:bin:n*bin-bin/2],C(:,2),'r-');
legend('alive','dead');
xlabel('Generation');
ylabel('Variation coefficient');
hold off;

end