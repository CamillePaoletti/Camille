function [Data]=computeRatioBudMotherAllDataPoints(path,file,position,hsFrame,lastFrame)
%Camille Paoletti - 12/2013
%compute computeRatioBudMother3 for the movie path/file for all position in pos
%and plot boxplot


% Data{1,1}=concentration
%
% [ 2x92x78 double]
%
% dim1: 1:mother / 2:bud
%
% dim2: couple mother/bud
%
% dim3: time evolution of concentration (renormalization by area)
%
%         Data{2,1}=ratio
%
%  [78x92    double]
%
% dim1: time evolution of ratio (ccbud/ccmother)
%
% dim2: couple mother/bud
%
%         Data{3,1}=aire
%
% [ 2x92x78 double]
%
% same as concentration for area
%
%         Data{4,1}=numéro des cellules
%
%  [ 2x92    double]
%
% dim1: 1:mother / 2:bud
%
% dim2: numéro des cellules de chaque couple
%
%         Data{5,1}=frame de division
%
% [ 1x92    double]
%
%         Data{6,1}=budding (first budding after division)
%
%  [ 1x92    double]

load([path,file,'-project.mat']);

global segmentation timeLapse segList

filen='segmentation-batch.mat';
[timeLapsepath , timeLapsefile]=setProjectPath(path,file);

Data=cell(8,1);

for l=position
    a=exist('segList');
    if a==0
        [segmentation , timeLapse]=phy_openSegmentationProject(timeLapsepath,timeLapsefile,l,1);%path/file/position/channel/handles
        
    else
        
        strPath=strcat(timeLapsepath,timeLapsefile);
        load(strPath);
        timeLapse.path=timeLapsepath;
        timeLapse.realPath=timeLapsepath;
        
        if exist(fullfile(timeLapse.path,timeLapse.pathList.position{l},filen),'file')
            % 'project already exist'
            load(fullfile(timeLapse.path,timeLapse.pathList.position{l},filen))
            
        else
            segmentation=phy_createSegmentation(timeLapse,l);
            save(fullfile(timeLapse.path,timeLapse.pathList.position{segmentation.position},filen),'segmentation');
        end

        [Cc,ratio,area,coupleNum,division,budding,Nrpoints,NrCc]=computeRatioBudMother4(hsFrame, lastFrame);
        
        a=Cc;
        Data{1,1}=horzcat(Data{1,1},a);
        a=ratio;
        Data{2,1}=horzcat(Data{2,1},a);
        a=area;
        Data{3,1}=horzcat(Data{3,1},a);
        a=coupleNum;
        Data{4,1}=horzcat(Data{4,1},a);
        a=division;
        Data{5,1}=horzcat(Data{5,1},a);
        a=budding;
        Data{6,1}=horzcat(Data{6,1},a);
        a=Nrpoints;
        Data{7,1}=horzcat(Data{7,1},a);
        a=NrCc;
        Data{8,1}=horzcat(Data{8,1},a);
        

    end

end


% K=size(Data{1,1},2);
% eventsLen=size(Data{1,1},3)/meanLen;
% CcMean=zeros(2,K,eventsLen);
% ratioMean=zeros(eventsLen,K);
% areaMean=zeros(2,K,eventsLen);
% for i=1:eventsLen
%         Cc_temp=Data{1,1};
%         Cc_temp=Cc_temp(:,:,1+(i-1)*meanLen:meanLen+(i-1)*meanLen);
%         CcMean(:,:,i)=mean(Cc_temp,3);
%         ratio_temp=Data{2,1};
%         ratio_temp=ratio_temp(1+(i-1)*meanLen:meanLen+(i-1)*meanLen,:);
%         ratioMean(i,:)=mean(ratio_temp,1);
%         area_temp=Data{3,1};
%         area_temp=area_temp(:,:,1+(i-1)*meanLen:meanLen+(i-1)*meanLen);
%         areaMean(:,:,i)=mean(area_temp,3);
% end

% displayStatCc(CcMean,ratioMean,areaMean,eventsLen);
% displayStatRatio(ratioMean);
% 
% figure;
% fsize=12;
% set(gca,'FontSize',fsize);
% boxplot([transpose(ratioMean(1,:)),transpose(ratioMean(2,:)),transpose(ratioMean(3,:))],'notch','on');
% 
% for i=1:eventsLen;
% figure;
% fsize=12;
% set(gca,'FontSize',fsize);
% boxplot([transpose(CcMean(1,:,i)),transpose(CcMean(2,:,i)),transpose(ratioMean(i,:))],'notch','on');
% %boxplot([transpose(CcMean(1,:,i)),transpose(CcMean(2,:,i))],'notch','on');
% %set(gca,'XTickLabel',{'Right After HS','First Division','Ratio'});
% %ylim([0 75]);
% ylabel('Fluorescence concentration (a.u)');

% figure;
% fsize=12;
% set(gca,'FontSize',fsize);
% boxplot(transpose(ratioMean(i,:)),'notch','on');
% ylabel('Ratio of Fluorescence (a.u)');
% ylim([0 10.5]);
% end




% disp(['ncells = ',num2str(K)]);
% 
% figure;
% Colors={'b*','r*','g*'};
% for i=1:eventsLen
% % figure;
% % plot(areaMean(1,:,i),CcMean(1,:,i),'b*');
% % hold on;
% % plot(areaMean(2,:,i),CcMean(2,:,i),'r*');
% hold on;
% plot(areaMean(2,:,1),ratioMean(i,:),Colors{i});
% xlim([0 3000]);
% hold off;
% end
% 
% figure;
% ColorsB={'b+','r+','g+'};
% for i=1:eventsLen
% hold on;
% plot(areaMean(2,:,1),CcMean(1,:,i),Colors{i});
% plot(areaMean(2,:,1),CcMean(2,:,i),ColorsB{i});
% xlim([0 3000]);
% hold off;
% end
% 


%plotHist(CcMean,eventsLen);

end



function [timeLapsepath timeLapsefile]=setProjectPath(path,file)
global timeLapse

%str=strcat(path,file);

%load(str);

timeLapse.realPath=strcat(path);
timeLapse.realName=file;

timeLapsepath=timeLapse.realPath;
timeLapsefile=[timeLapse.filename '-project.mat'];

end


function displayStatCc(Cc,ratio,area,eventsLen)

for i=1:eventsLen
    numel=~isnan(Cc(1,:,i));
    numel=find(numel);
    mM=mean(Cc(1,numel,i));%mean concentration in mother
    medianM=median(Cc(1,numel,i));%median of concentration in mother
    
    numel=~isnan(Cc(2,:,i));
    numel=find(numel);
    mB=mean(Cc(2,numel,i));%mean concentration in bud
    medianB=median(Cc(2,numel,i));%median of concentration in bud
    
    numel=~isnan(ratio(i,:));
    numel=find(numel);
    mR=mean(ratio(i,numel));%mean Ratio
    medianR=median(ratio(i,numel));%median ratio
    
    disp(['frame ', num2str(i)]);
    disp(['mean concentration in bud = ',num2str(mB)]);
    disp(['mean concentration in mother = ',num2str(mM)]);
    disp(['mean ratio = ',num2str(mR)]);
    disp(['median concentration in bud = ',num2str(medianB)]);
    disp(['median concentration in mother = ',num2str(medianM)]);
    disp(['median ratio = ',num2str(medianR)]);
    
    
    disp('---');
    disp('concentration wikcoxon test');
    numel1=~isnan(Cc(1,:,i));
    numel2=~isnan(Cc(2,:,i));
    numel=numel1.*numel2;
    numel=find(numel);
    [R,P]=corrcoef(Cc(1,numel,i),Cc(2,numel,i));
    [p] = ranksum(Cc(1,numel,i),Cc(2,numel,i));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
    disp('---');
    disp('area wikcoxon test');
    [R,P]=corrcoef(area(1,numel,i),area(2,numel,i));
    [p] = ranksum(area(1,numel,i),area(2,numel,i));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
    disp('***');
    disp('***');
end

end

function displayStatRatio(ratio)
    numel1=~isnan(ratio(1,:));
    numel2=~isnan(ratio(2,:));
    numel=numel1.*numel2;
    numel=find(numel);
    disp(['ncell1_2 = ',num2str(length(numel))]);
    disp('ratio wikcoxon test - 1VS2');
    [R,P]=corrcoef(ratio(1,numel),ratio(2,numel));
    [p] = ranksum(ratio(1,numel),ratio(2,numel));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
    
    disp('ratio wilcoxon test - 2VS3')
    numel1=~isnan(ratio(3,:));
    numel2=~isnan(ratio(2,:));
    numel=numel1.*numel2;
    numel=find(numel);
    disp(['ncell2_3 = ',num2str(length(numel))]);
    disp('ratio wikcoxon test');
    [R,P]=corrcoef(ratio(3,numel),ratio(2,numel));
    [p] = ranksum(ratio(3,numel),ratio(2,numel));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
   
end


function plotHist(CcMean,eventsLen)

Mean=[];
for i=1:eventsLen
%Mean=[4.5 1.5 2 1 2 1];
numel1=isnan(CcMean(1,:,i));
numel2=isnan(CcMean(2,:,i));
Mean=[Mean mean(CcMean(1,~numel1,i)) mean(CcMean(2,~numel2,i))];
end

Mean=[4.66 1.48 2.28 1.24 1.28 0];
MeanG=[4.66 1.48 2.28 1.24 1.29 0];
SigmaG=[1.7 0.99 1.7 0.88 0.79 0];

x=[0:1:12];
p=zeros(length(x),length(Mean));
g=zeros(length(x),length(Mean));

for j=1:length(Mean)
    for i=x
        Mean_temp=Mean(j);
        p(i+1,j)=exp(-Mean_temp)*Mean_temp^i/factorial(i);
        g(i+1,j)=1/(SigmaG(j)*sqrt(2*pi))*exp((-1/2)*((i-MeanG(j))/SigmaG(j))^2);
    end
end

close all;
for i=1:eventsLen

disp(['Mean Mother ',num2str(i),' = ',num2str(Mean((i-1)*2+1))]);
disp(['Mean Bud ',num2str(i),' = ',num2str(Mean((i-1)*2+2))]);
n1=hist(CcMean(1,:,i),x);
n1=transpose(n1);
PD1 = fitdist(transpose(x), 'poisson','freq',n1)
n1=n1./length(CcMean(1,:,i));
n2=hist(CcMean(2,:,i),x);
n2=transpose(n2);
PD2 = fitdist(transpose(x), 'poisson','freq',n2)
n2=n2./length(CcMean(2,:,i));
n1p=p(:,(i-1)+1);
n2p=p(:,(i-1)*2+2);
n1g=g(:,(i-1)+1);
n2g=g(:,(i-1)*2+2);

figure;
pl=horzcat(n1,n1p,n1g);
bar(pl);
ylim([0 1]);


figure
pl=horzcat(n2,n2p,n2g);
bar(pl);
ylim([0 1]);

% pl=horzcat(n1,n1p,n2,n2p);
% bar(pl);
% ylim([0 1]);

end

end