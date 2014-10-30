function [Size,SizeN,SizeF]=averageCellSizeAtBud(user)
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
numel=find(str2double(DATA.data(:,7))~=0);
L=length(numel);
str=cell(L,1);
Size=cell(L,1);
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
    
    Obj=segmentation.tcells1(1,line).Obj(1,:);
    Size{i,1}=getYeastSize(bud,Obj);

end

s=zeros(L,1);
%average cell size at budding calculation
for i=1:L
       s(i,1)=length(Size{i,1}); 
end

M1=max(s(:,1));


SizeN{:,1}=cell(M1,L);

for i=1:L
       for k=1:s(i,1)
          SizeN{k,i}=Size{i,1}(k); 
       end  
end

SizeF=cell(M1,1);
for k=1:M1
    SizeF{k,1}=cat(2,SizeN{k,:});
end

M=zeros(M1,1);
STD=zeros(M1,1);
for k=1:M1
    M(k,1)=mean(SizeF{k,1});
    STD(k,1)=std(SizeF{k,1})/sqrt(length(SizeF{k,1}));
    C(k,1)=std(SizeF{k,1})/mean(SizeF{k,1});
end


figure;
errorbar(M,STD);
hold on;
title(['Average cell size at budding as a function of generation number (',num2str(L),' cells)']);
xlabel('Generation');
ylabel('Average Cell Size (area in pix)');
hold off;

figure;
plot(C);
hold on;
title(['Variation coefficient for average cell size at budding as a function of generation number (',num2str(L),' cells)']);
xlabel('Generation');
ylabel('Variation coefficient');
hold off;

end