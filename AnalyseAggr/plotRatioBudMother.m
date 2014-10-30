function [h_figure,ratioMean]=plotRatioBudMother(meanLen,Data,display)

%Camille Paoletti - 04/2014
%plot ratio and concentration from an input variable Data (generated with
%!!!!!!! computeRatioBudMotherFigure !!!!!!!!!!!!!);
h_figure=0;

K=size(Data{1,1},2);
eventsLen=size(Data{1,1},3)/meanLen;
eventsName={'RAHS','FD','NB'};
CcMean=zeros(2,K,eventsLen);
ratioMean=zeros(eventsLen,K);
areaMean=zeros(2,K,eventsLen);
for i=1:eventsLen
        Cc_temp=Data{1,1};
        Cc_temp=Cc_temp(:,:,1+(i-1)*meanLen:meanLen+(i-1)*meanLen);
        CcMean(:,:,i)=mean(Cc_temp,3);
        ratio_temp=Data{2,1};
        ratio_temp=ratio_temp(1+(i-1)*meanLen:meanLen+(i-1)*meanLen,:);
        ratioMean(i,:)=mean(ratio_temp,1);
        area_temp=Data{3,1};
        area_temp=area_temp(:,:,1+(i-1)*meanLen:meanLen+(i-1)*meanLen);
        areaMean(:,:,i)=mean(area_temp,3);
end

[pval]=displayStatCc(CcMean,ratioMean,areaMean,eventsLen,eventsName,0);
[p12,p23]=displayStatRatio(ratioMean,0,eventsLen);

if display
figure;
fsize=12;
set(gca,'FontSize',fsize);
if eventsLen>2
    boxplot([transpose(ratioMean(1,:)),transpose(ratioMean(2,:)),transpose(ratioMean(3,:))],'notch','on');
    hold on;
    title('Evolution of bud to mother ratio');
    groups={[1,2],[2,3]};
    stats=[p12,p23]
    H=sigstar(groups,stats);
else
    boxplot([transpose(ratioMean(1,:)),transpose(ratioMean(2,:))],'notch','on');
    hold on;
    title('Evolution of bud to mother ratio');
    groups={[1,2]};
    stats=[p12]
    H=sigstar(groups,stats);
end


marg=0.2;
numelI=~isnan(ratioMean(1,:));
numelI=find(numelI);
numelN=~isinf(ratioMean(1,:));
numelN=find(numelN);
numel=intersect(numelI,numelN);
max1=max(ratioMean(1,numel)+marg);max1=min(max1,8+marg);

numelI=~isnan(ratioMean(2,:));
numelI=find(numelI);
numelN=~isinf(ratioMean(2,:));
numelN=find(numelN);
numel=intersect(numelI,numelN);
max2=max(ratioMean(2,numel)+marg);max2=min(max2,8+marg);

if eventsLen>2
    numelI=~isnan(ratioMean(3,:));
    numelI=find(numelI);
    numelN=~isinf(ratioMean(3,:));
    numelN=find(numelN);
    numel=intersect(numelI,numelN);
    max3=max(ratioMean(3,numel)+marg);max3=min(max3,8+marg);
end

Y=get(H(1,1),'YData');Y(1)=max(max1,max2);Y(2)=max(max1,max2)+marg;Y(3)=max(max1,max2)+marg;Y(4)=max(max1,max2);set(H(1,1),'YData',Y);
if eventsLen>2
    Z=get(H(2,1),'YData');Z(1)=max(max3,max2);Z(2)=max(max3,max2)+marg;Z(3)=max(max3,max2)+marg;Z(4)=max(max3,max2);set(H(2,1),'YData',Z);
else
    Z=[0 0 0 0];
end
ylim([0 max(Y(3),Z(3))+3*marg]);
% text(1,Y(2)+2*marg,num2str(p12));
% text(2,Z(2)+2*marg,num2str(p23));
marg=0.05;
text(1.5,Y(2)+2*marg,'***');
text(2.5,Z(2)+2*marg,'***');
if eventsLen>2
    set(gca,'xtick',1:3, 'xticklabel',eventsName);
else
    set(gca,'xtick',1:2, 'xticklabel',eventsName(1:2));
end
hold off;
h_figure(1)=gca;


for i=1:eventsLen;
figure;
fsize=12;
set(gca,'FontSize',fsize);
boxplot([transpose(CcMean(1,:,i)),transpose(CcMean(2,:,i))],'notch','on');
%boxplot([transpose(CcMean(1,:,i)),transpose(CcMean(2,:,i)),transpose(ratioMean(i,:))],'notch','on');
%ylim([0 75]);
hold on;
ylabel('Fluorescence concentration (a.u)');
title(['Concentration of fluo ',eventsName{i}]);
hold off;
set(gca,'xtick',1:2, 'xticklabel',{'M','B'}); 
H=sigstar({[1,2]},[pval.(eventsName{i})]);
%Extend the arms down:
max1=max(transpose(CcMean(1,:,i))+1);
max2=max(transpose(CcMean(2,:,i))+1);
Y=get(H(1,1),'YData');Y(1)=max1;Y(4)=max2;
set(H(1,1),'YData',Y);
%set(gca,'xtick',1:3, 'xticklabel',{'Mothers','Buds','Ratio'}); 
ylim([0 Y(3)+2])
hold off;
h_figure(1+i)=gca;
end

disp(['ncells = ',num2str(K)]);
end
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


function [pval]=displayStatCc(Cc,ratio,area,eventsLen,eventsName,display)

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
    
    if display
        
        disp(['frame ', num2str(i)]);
        disp(['mean concentration in bud = ',num2str(mB)]);
        disp(['mean concentration in mother = ',num2str(mM)]);
        disp(['mean ratio = ',num2str(mR)]);
        disp(['median concentration in bud = ',num2str(medianB)]);
        disp(['median concentration in mother = ',num2str(medianM)]);
        disp(['median ratio = ',num2str(medianR)]);
        
        disp('---');
        disp('concentration wikcoxon test');
    end
    numel1=~isnan(Cc(1,:,i));
    numel2=~isnan(Cc(2,:,i));
    numel=numel1.*numel2;
    numel=find(numel);
    [R,P]=corrcoef(Cc(1,numel,i),Cc(2,numel,i));
    [p] = ranksum(Cc(1,numel,i),Cc(2,numel,i));
    if display
        disp(['covariance = ', num2str(R(1,2))]);
        disp(['p-value significant correlation = ',num2str(P(1,2))]);
        disp(['p-value median significantly different = ',num2str(p)]);
    end
    pval.(eventsName{i})=p;
    
    if display
        disp('---');
        disp('area wikcoxon test');
    end
    [R,P]=corrcoef(area(1,numel,i),area(2,numel,i));
    [p] = ranksum(area(1,numel,i),area(2,numel,i));
    if display
        disp(['covariance = ', num2str(R(1,2))]);
        disp(['p-value significant correlation = ',num2str(P(1,2))]);
        disp(['p-value median significantly different = ',num2str(p)]);
        disp('***');
        disp('***');
    end
end

end

function [p12,p23]=displayStatRatio(ratio,display,eventsLen)
    numel1=~isnan(ratio(1,:));
    numel2=~isnan(ratio(2,:));
    numel=numel1.*numel2;
    numel=find(numel);
    if display
        disp(['ncell1_2 = ',num2str(length(numel))]);
        disp('ratio wikcoxon test - 1VS2');
    end
    [R,P]=corrcoef(ratio(1,numel),ratio(2,numel));
    [p] = ranksum(ratio(1,numel),ratio(2,numel));
    if display
        disp(['covariance = ', num2str(R(1,2))]);
        disp(['p-value significant correlation = ',num2str(P(1,2))]);
        disp(['p-value median significantly different = ',num2str(p)]);
    end
    p12=p;
    
    if eventsLen>2
        if display
            disp('ratio wilcoxon test - 2VS3')
        end
        numel1=~isnan(ratio(3,:));
        numel2=~isnan(ratio(2,:));
        numel=numel1.*numel2;
        numel=find(numel);
        if display
            disp(['ncell2_3 = ',num2str(length(numel))]);
            disp('ratio wikcoxon test');
        end
        [R,P]=corrcoef(ratio(3,numel),ratio(2,numel));
        [p] = ranksum(ratio(3,numel),ratio(2,numel));
        if display
            disp(['covariance = ', num2str(R(1,2))]);
            disp(['p-value significant correlation = ',num2str(P(1,2))]);
            disp(['p-value median significantly different = ',num2str(p)]);
        end
        p23=p;
    else
        p23=0;
    end
   
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