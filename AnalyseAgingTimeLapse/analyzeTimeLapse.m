function analyzeTimeLapse(user)
global segList segmentation timeLapse

%Gilles Charvin - 10/2011
%plot average cell cycle timing as a function of generation
%number
%ex:

%loading data bases
%load('/Volumes/charvin/common/matlab/straindb/db/Data/Common_Data.mat');
load('L:\common\matlab\straindb\db\Data\Common_Data.mat');
DATA=database;
%load('/Volumes/charvin/common/matlab/straindb/db/Experiments/Common_Experiments.mat');
load('L:\common\matlab\straindb\db\Experiments\Common_Experiments.mat');
EXP=database;

%user's path
if strcmp(user,'Gilles')
    path='/Volumes/charvin/common/movies/';
elseif strcmp(user,'Steffen')
    path=[];
else
    path='L:\common\movies\';
    %path='E:\Mes documents\PhD\';
end

%%extracting data to plot

% selectitems from movie 1H
selitems=[];

for i=1:numel(DATA.data(:,1))
pix=strfind(DATA.data{i,1},'1H');
if numel(pix)~=0
    selitems=[selitems i];
end
end

for i=1:numel(DATA.data(:,1))
 pix=strfind(DATA.data{i,1},'1G');
 if numel(pix)~=0
     selitems=[selitems i];
 end
 end

L=length(selitems);
str=cell(L,1);
str2=cell(L,1);
bud=cell(L,1);
interval=cell(L,1);

cc=0;

for i=1:L
    %creating path corresponding to cell number i (with i: line in database)
    ID=DATA.data(selitems(i),1);
    %%%%%%%%Be careful, problem for more than 9*26 experiments!!!%%%%%%%%
    a=find(strncmp(ID,EXP.data(:,1),2));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    experimenter=EXP.data(a,2);
    date=str2double(EXP.data(a,3));
    folder=EXP.data(a,4);
    name=EXP.data(a,5);
    pos=DATA.data(selitems(i),2);
    warning off all;
    str{i}=strcat(path,experimenter,'/20',num2str(int8(date/1e4)),'/20',num2str(int16(date/1e2)),'/',folder,'/',name,'-pos',pos,'/segmentation.mat');
    str2{i}=strcat(path,experimenter,'/20',num2str(int8(date/1e4)),'/20',num2str(int16(date/1e2)),'/',folder,'/','BK-project.mat');
    warning on all;
    
    % check data are already loaded
    
    alreadyEx=0;
    
    line=str2double(DATA.data{selitems(i),7});
    
    if numel(segList)~=0
        for j=1:numel(segList)
            if isfield(segList(j).s,'position')
                if segList(j).s.position==str2num(cell2mat(pos))
                    if strcmp(segList(j).filename,name)
                        if segList(j).line==line
                        alreadyEx=1;
                        break
                        end
                    end
                end
            end
        end
    end
          
    
    %segList
    
    
    if alreadyEx
        fprintf('i=%d; numel=%d; pos=%d already loaded \n',i,selitems(i),str2num(cell2mat(pos)));
        continue
    end
    
    
    
    if ~line
        fprintf('i=%d; numel=%d; pos=%d is not segmented \n',i,selitems(i),str2num(cell2mat(pos)));
        continue
    end
    
    
    %loading segmentation data
    try
    load(str{i}{1});
    load(str2{i}{1});
    catch
   fprintf('unable to load i=%d;  pos=%d \n',i,str2num(cell2mat(pos)));  
    continue    
    end
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

    line=str2double(DATA.data{selitems(i),7});
    
    fprintf('i=%d; numel=%d; line=%d; pos=%d \n',i,selitems(i),line,str2num(cell2mat(pos)));
    
    if ~line
       continue;
    end
    

    
%    l=length(segmentation.tcells1(1,line).budTimes(1,:));
%    if l==0
%        fprintf('WARNING: no bud times available for position %d \n',i);
%    else
%        bud{i,1}=segmentation.tcells1(1,line).budTimes(1,:);
%        interval{i,1}=timeLapse.interval;
%    end
   
%segList

    

        segList(cc+1).s=segmentation;
        segList(cc+1).filename=timeLapse.filename;
        segList(cc+1).position=segmentation.position;
        segList(cc+1).line=line;
        
        cc=cc+1;
 
    
    %segList
   % segList
    
end

laste=numel(segList);
for i=1:numel(segList)
   if numel(segList(i).s)==0
      laste=i;
      break;
   end
end

segList=segList(1:laste);