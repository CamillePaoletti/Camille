function [budT, Fluo, Times, deltaFluo, TimesF,deltaFluoF]=xyFluoAnalysis(user)
%Camille Paoletti - 10/2011
%plot delaty vs deltaX
%ex: [budT, Fluo, Times,deltaFluo, FluoF, TimesF]=xyFluoAnalysis('');

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
    numel2=find(strncmp('1C',DATA.data(:,1),2) & str2double(DATA.data(:,5))~=0 & str2double(DATA.data(:,7))~=0);
    numel3=find(strncmp('1G',DATA.data(:,1),2) & str2double(DATA.data(:,5))~=0 & str2double(DATA.data(:,7))~=0);
    numel4=find(strncmp('1A',DATA.data(:,1),2) & str2double(DATA.data(:,5))~=0 & str2double(DATA.data(:,7))~=0);
    numel=vertcat(numel2,numel3,numel4);

L=length(numel);
str=cell(L,1);
str2=cell(L,1);
Fluo=cell(L,2);
interval=cell(L,1);
budT=cell(L,1);
k=1;
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
    
    fprintf('i=%d; numel=%d; line=%d',i,numel(i),line);
    if segmentation.tcells1(1,line).Obj(1,1).fluoMean==0
        fprintf(' :: no fluo available \n');
    else
        fprintf(' \n');
        interval{k,1}=timeLapse.interval;
        budT{k,1}=segmentation.tcells1(1,line).budTimes(1,:);
        
        bud=segmentation.tcells1(1,line).budTimes(1,:);
        s=size(bud);
        bud=bud-ones(1,s(2)).*(segmentation.tcells1(1,line).detectionFrame-1);
        
        Obj=segmentation.tcells1(1,line).Obj(1,:);
        
        Fluo{k,1}=getYeastFluo(bud,Obj,2);
        k=k+1;
    end
end

L=k-1;
s=zeros(L,1);
for i=1:L
       s(i,1)=length(budT{i,1});
end

%M1=max(s(:,1));

Times=cell(L,1);
deltaFluo=cell(L,1);
for i=1:L
       for k=1:(s(i,1)-1)
          Times{i,1}(k)=double((budT{i,1}(k+1)-budT{i,1}(k))*interval{i,1}/60);
          deltaFluo{i,1}(k)=Fluo{i,1}(k+1)-Fluo{i,1}(k);
       end  
end

deltaFluoF=cat(2,deltaFluo{:,1});
TimesF=cat(2,Times{:,1});

figure;
plot(TimesF,deltaFluoF, 'r+');
hold on;
title(['deltaFluo vs divTime (',num2str(L),' cells)']);
xlabel('division time (min)');
ylabel('mean fluo (a.u.)');
hold off;

end
