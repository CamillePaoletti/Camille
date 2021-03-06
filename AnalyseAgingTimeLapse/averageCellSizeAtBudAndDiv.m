function [Size,SizeN,SizeF]=averageCellSizeAtBudAndDiv(user)
%Camille Paoletti - 09/2011
%plot average cell size at budding and division as a function of generation
%number

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
numel1=find(str2double(DATA.data(:,7))~=0 & strncmp('1G',DATA.data(:,1),2));
numel2=find(str2double(DATA.data(:,7))~=0 & strncmp('1H',DATA.data(:,1),2));
numel=vertcat(numel1,numel2);
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
    div=segmentation.tcells1(1,line).divisionTimes(1,:);
    s=size(div);
    div=div-ones(1,s(2)).*(segmentation.tcells1(1,line).detectionFrame-1);
    
    Obj=segmentation.tcells1(1,line).Obj(1,:);
    Size{i,1}=getYeastSize(bud,Obj);
    Size{i,2}=getYeastSize(div,Obj);
end

s=zeros(L,2);
%average cell size at budding calculation
for i=1:L
    for j=1:2
        s(i,j)=length(Size{i,j});
    end   
end

M1=max(s(:,1));%maximal number of bud
M2=max(s(:,2));%maximal number of division



SizeN=cell(max(M1,M2),L,2);

for i=1:L
    for j=1:2
       for k=1:s(i,j)
           fprintf('i=%f; j=%f; k=%f\n',i,j,k);
           SizeN{k,i,j}=Size{i,j}(k); 
       end
    end   
end

SizeF=cell(M1,2);
for k=1:M1
    for j=1:2
    SizeF{k,j}=cat(2,SizeN{k,:,j});
    end   
end

M=zeros(M1,2);
STD=zeros(M1,2);
for k=1:M1
    for j=1:2
    M(k,j)=mean(SizeF{k,j});
    STD(k,j)=std(SizeF{k,j})/sqrt(length(SizeF{k,j}));
    end   
end

figure;
errorbar([1:1:length(M(:,1))],M(:,1),STD(:,1),'b-');
hold on;
errorbar([1:1:length(M(:,1))],M(:,2),STD(:,2),'r-');
title(['Average cell size at budding and division as a function of generation number (',num2str(L),' cells)']);
xlabel('Generation');
ylabel('Average Cell Size (area in pix)');
legend('bud','div');
hold off;

end