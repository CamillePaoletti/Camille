function []=singleCellCycleTiming(user)
%Camille Paoletti - 10/2011
%plot time trace of single cell cycle timing
%number
%ex: singleCellCycleTiming('');

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
bud=cell(L,1);
interval=cell(L,1);

h1=figure; h2=figure;

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
    str1=strcat(path,experimenter,'\20',num2str(int8(date/1e4)),'\20',num2str(int16(date/1e2)),'\',folder,'\',name,'-pos',pos,'\segmentation.mat');
    str2=strcat(path,experimenter,'\20',num2str(int8(date/1e4)),'\20',num2str(int16(date/1e2)),'\',folder,'\','BK-project.mat');
    %loading segmentation data
    load(str1{1,1});
    load(str2{1,1});
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
        ar= bud{i,1};
        ar2=double(timeLapse.interval/60)*(ar(2:end)-ar(1:end-1));
        figure(h1);
        plot(ar2,'Marker','o'); hold on;
        figure(h2);
        plot(double(timeLapse.interval/60)*ar(1:end-1),ar2,'Marker','o'); hold on;
    end
    
end
 

figure(h1);
xlabel('generations'); ylabel('Division time (min)');
figure(h2);
xlabel('division time'); ylabel('Time (min)');

end