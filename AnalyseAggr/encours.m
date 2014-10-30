t=160;
dT=3;
pos=3;

for i=1:t;cyt{i,1}=horzcat(cytoVal{i,1},cytoVal{i,2},cytoVal{i,3});end
for i=1:t;cytm(i,1)=mean(cyt{i,1});end
for i=1:t;fl{i,1}=horzcat(meanVal{i,1},meanVal{i,2},meanVal{i,3});end
for i=1:t;flm(i,1)=mean(fl{i,1});end
%n=length(data.realTime);
figure;plot([1:1:t],flm,'r-');hold on;plot([1:1:t],cytm);
%plot(data.diffTime(1:n,1)./60,data.stageTempAlarm(1:n,1).*20,'k-');
xlabel('Time (min)');
ylabel('Mean fluorescnece intensity (a.u.)');
legend('foci','cytoplasm');
hold off;



% for i=1:t;cyt{i,1}=horzcat(MPcytoVal{i,1},MPcytoVal{i,2},MPcytoVal{i,3});end
% for i=1:t;cytm(i,1)=mean(cyt{i,1});end
% for i=1:t;fl{i,1}=horzcat(MPfociVal{i,1},MPfociVal{i,2},MPfociVal{i,3});end
% for i=1:t;flm(i,1)=mean(fl{i,1});end
% n=length(data.realTime);
% figure;
% hold on;
% plot(data.diffTime(1:n,1)./60,data.stageTempAlarm(1:n,1).*1e4,'b-');
% ax1 = gca;
% set(ax1,'YColor','b')
% legend('Stage Alarm','Stage Current','Stage','Obj Current','Obj');
% legend('Sample temperature');
% legend1 = legend(ax1,'show');
% set(legend1,'Location','South');
% xlabel('Time (min)');
% ylabel('Temperature (°C)');
% 
% 
% ax2 = axes('Position',get(ax1,'Position'),...
%     'YAxisLocation','right',...
%     'Color','none',...
%     'YColor','b');
% line([1:1:160],flm,'Color','r','Parent',ax2);
% line([1:1:160],cytm,'Color','g','Parent',ax2);
% legend('Foci','Cytplasm');
% ylabel('Fluorescence intensity (a.u.)');
% 
% title(['response to change in temperature']);
% hold off;


for i=1:t;cyt{i,1}=horzcat(MPcytoVal{i,1},MPcytoVal{i,2},MPcytoVal{i,3});end
for i=1:t;cytm(i,1)=mean(cyt{i,1});end
for i=1:t;fl{i,1}=horzcat(MPfociVal{i,1},MPfociVal{i,2},MPfociVal{i,3});end
for i=1:t;flm(i,1)=mean(fl{i,1});end
figure;
hold on;
plot([1:1:t],flm,'r-');
plot([1:1:t],cytm,'g-');
legend('Foci','Cytplasm');
xlabel('Time (min)');
ylabel('Fluorescence intensity (a.u.)');
title(['response to change in temperature']);
hold off;



for i=1:t;nb{i,1}=horzcat(nbVal{i,1},nbVal{i,2},nbVal{i,3});end
for i=1:t;nbTot(i,1)=sum(nb{i,1});end
for i=1:t;meanFociNb(i,1)=mean(nb{i,1});end
figure;
plot([1:dT:t*dT],nbTot);
title('Total number of foci');
xlabel('Time (min)');
ylabel('Number of foci');
figure;
plot([1:dT:t*dT],meanFociNb);
title('Total number of foci per cell');
xlabel('Time (min)');
ylabel('Number of foci');



t=520;
dT=3;
pos=1;

for j=1:pos
    for i=1:t
        nb1(i,j)=sum(nbVal{i,j});
        meanFociNb1(i,j)=mean(nbVal{i,j})
    end
end
figure;
colors={'r-','b-','g-','-c','-k','-m'};
hold on;
for j=1:pos
    plot([1:dT:t*dT],nb1(:,j),colors{j});
end
legend('position 1','position 2','position 3');
title('Total number of foci');
xlabel('Time (min)');
ylabel('Number of foci');

hold off;
figure;
colors={'r-','b-','g-','-c','-k','-m'};
hold on;
for j=1:pos
    plot([1:dT:t*dT],meanFociNb1(:,j),colors{j});
end
legend('position 1','position 2','position 3');
title('Total number of foci Per cell');
xlabel('Time (min)');
ylabel('Number of foci');

hold off;

for i=1:t;cyt{i,1}=horzcat(MPcytoVal{i,1});end
for i=1:t;cytm(i,1)=mean(cyt{i,1});end
for i=1:t;fl{i,1}=horzcat(MPfociVal{i,1});end
for i=1:t;flm(i,1)=mean(fl{i,1});end
figure;plot([2:1:t],flm(2:t),'r-');hold on;plot([2:1:t],cytm(2:t),'g-');plot([2:1:t],flm(2:t)+cytm(2:t),'b-');
hold off;

leng=timeLapse.numberOfFrames;
vY=[];
vX=[];
for i=1:leng
    vY=[vY,nb{i,1}];
    vX=[vX,ones(1,numel(nb{i,1})).*i];
end
dat=horzcat(transpose(vX),transpose(vY));
n=hist3(dat,{1:10:t 1:1:t});
figure;
n1 = n';
n1( size(n,1) ,size(n,2) + 1 ) = 0;
%Generate grid for 2-D projected view of intensities:
xb = linspace(min(dat(:,1)),max(dat(:,1)),size(n,1));
yb = linspace(min(dat(:,2)),max(dat(:,2)),size(n,1));
%Make a pseudocolor plot:
h = pcolor(xb,yb,n1);
%Set the z-level and colormap of the displayed grid:
set(h, 'zdata', ones(size(n1)) * -max(max(n)))
colormap(hot) % heat map
title('2d hist nb foci per cell/time');
xlabel('Time (min)');
ylabel('number of foci per cell');
colorbar;
grid on;





load('L:\common\movies\Camille\2012\201203\120327_aggr_continuous35degstep_analysis\120327_continuous35degstep_analysis-fociAnalysis.mat');
for i=1:t;nb{i,1}=horzcat(nbVal{i,1},nbVal{i,2},nbVal{i,3});end
for i=1:t;nbTot(i,1)=sum(nb{i,1});end
for i=1:t;meanFociNb(i,1)=mean(nb{i,1});end
figure;
hold on
plot([1:1:t],meanFociNb);
title('Total number of foci per cell');
xlabel('Time (min)');
ylabel('Number of foci');
load('L:\common\movies\Camille\2012\201204\120403_aggr_continuousStep35deg_analysis\120403_aggr35deg5stacks_analysis-fociAnalysis.mat');
for i=1:t;nb{i,1}=horzcat(nbVal{i,1},nbVal{i,2},nbVal{i,3});end
for i=1:t;nbTot(i,1)=sum(nb{i,1});end
for i=1:t;meanFociNb(i,1)=mean(nb{i,1});end
plot([1:1:t],meanFociNb,'r-');
legend('illu 30%', 'illu 20%');
hold off;


t=240;
dT=3;
pos=1;

for i=1:t
    a{i,1}=nbVal{i,1}./areaCell{i,1}; 
    aM{i,1}=nbValM{i,1}./areaCellM{i,1}; 
    aD{i,1}=nbValD{i,1}./areaCellD{i,1}; 
end
for i=1:t
    m(1,i)=mean(a{i,1});
    m(2,i)=length(a{i,1});
    mM(1,i)=mean(aM{i,1});
    mM(2,i)=length(aM{i,1});
    mD(1,i)=mean(aD{i,1});
    mD(2,i)=length(aD{i,1});
end
figure;
plot([1:1*dT:t*dT],m,'r-');
hold on;
plot([1:1*dT:t*dT],mM,'b-');
plot([1:1*dT:t*dT],mD,'g-');
legend('all','mothers','daughters');
title('Number of Foci per Unit of Area');
xlabel('Time (min)');
ylabel('Number of foci per unit of area (pix^{-1})');


clear A;
ratio_bHS_M=bHSNrpointsM./bHSareaM;
ratio_HS_M=HSNrpointsM./HSareaM;
ratio_bHS_D=bHSNrpointsD./bHSareaD;
ratio_HS_D=HSNrpointsD./HSareaD;
ratio_S_M=SNrpointsM./SareaM;
ratio_S_D=SNrpointsD./SareaD;
A(1,:)=[ratio_bHS_M,ratio_bHS_D,ratio_HS_M,ratio_HS_D,ratio_S_M,ratio_S_D];
A(2,:)=[ones(1,length(ratio_bHS_M)),ones(1,length(ratio_bHS_D)).*2,ones(1,length(ratio_HS_M)).*3,ones(1,length(ratio_HS_D)).*4,ones(1,length(ratio_S_M)).*5,ones(1,length(ratio_S_D)).*6];
figure;boxplot(A(1,:),A(2,:),'notch','on');
hold on;
title('ratio nb of foci/area');
hold off;


clear A;
ratio_bHS_M=bHSNrpointsM./(bHSareaM.^(3/2));
ratio_HS_M=HSNrpointsM./(HSareaM.^(3/2));
ratio_bHS_D=bHSNrpointsD./(bHSareaD.^(3/2));
ratio_HS_D=HSNrpointsD./(HSareaD.^(3/2));
ratio_S_M=SNrpointsM./(SareaM.^(3/2));
ratio_S_D=SNrpointsD./(SareaD.^(3/2));
A(1,:)=[ratio_bHS_M,ratio_bHS_D,ratio_HS_M,ratio_HS_D,ratio_S_M,ratio_S_D];
A(2,:)=[ones(1,length(ratio_bHS_M)),ones(1,length(ratio_bHS_D)).*2,ones(1,length(ratio_HS_M)).*3,ones(1,length(ratio_HS_D)).*4,ones(1,length(ratio_S_M)).*5,ones(1,length(ratio_S_D)).*6];
figure;boxplot(A(1,:),A(2,:),'notch','on');
hold on;
title('ratio nb of foci/volume');
hold off;

clear B;
B(1,:)=[bHSNrpointsM,bHSNrpointsD,HSNrpointsM,HSNrpointsD,SNrpointsM,SNrpointsD];
B(2,:)=[ones(1,length(bHSNrpointsM)),ones(1,length(bHSNrpointsD)).*2,ones(1,length(HSNrpointsM)).*3,ones(1,length(HSNrpointsD)).*4,ones(1,length(SNrpointsM)).*5,ones(1,length(SNrpointsD)).*6];
figure;boxplot(B(1,:),B(2,:),'notch','on');
hold on;
title('nb of foci');
hold off;

clear C;
ratio_bHS_M=bHSfluoM./bHSareaM;
ratio_HS_M=HSfluoM./HSareaM;
ratio_bHS_D=bHSfluoD./bHSareaD;
ratio_HS_D=HSfluoD./HSareaD;
ratio_S_M=SfluoM./SareaM;
ratio_S_D=SfluoD./SareaD;
C(1,:)=[ratio_bHS_M,ratio_bHS_D,ratio_HS_M,ratio_HS_D,ratio_S_M,ratio_S_D];
C(2,:)=[ones(1,length(ratio_bHS_M)),ones(1,length(ratio_bHS_D)).*2,ones(1,length(ratio_HS_M)).*3,ones(1,length(ratio_HS_D)).*4,ones(1,length(ratio_S_M)).*5,ones(1,length(ratio_S_D)).*6];
figure;boxplot(C(1,:),C(2,:),'notch','on');
hold on;
title('ratio total fluo in foci/area');
hold off;

clear D;
ratio_bHS_M=bHSfluoM./(bHSareaM.^(3/2));
ratio_HS_M=HSfluoM./(HSareaM.^(3/2));
ratio_bHS_D=bHSfluoD./(bHSareaD.^(3/2));
ratio_HS_D=HSfluoD./(HSareaD.^(3/2));
ratio_S_M=SfluoM./(SareaM.^(3/2));
ratio_S_D=SfluoD./(SareaD.^(3/2));
D(1,:)=[ratio_bHS_M,ratio_bHS_D,ratio_HS_M,ratio_HS_D,ratio_S_M,ratio_S_D];
D(2,:)=[ones(1,length(ratio_bHS_M)),ones(1,length(ratio_bHS_D)).*2,ones(1,length(ratio_HS_M)).*3,ones(1,length(ratio_HS_D)).*4,ones(1,length(ratio_S_M)).*5,ones(1,length(ratio_S_D)).*6];
figure;boxplot(D(1,:),D(2,:),'notch','on');
hold on;
title('ratio total fluo in foci/volume');
hold off;

ratioB_M=zeros(1,length(fluoM));
for i=1:length(fluoM);
    if fluoM(i)==0
    else ratioB_M(i)=fluoD(i)/fluoM(i);
    end
end
figure;boxplot(ratioB_M,'notch','on');
hold on;
title('ratio total fluo in foci Bud/mother at div');
hold off;


for i=0:2
    tM(i+1)=length(find(SNrpointsM==i));
    tD(i+1)=length(find(SNrpointsD==i));
end
tM(4)=length(find(SNrpointsM>=3));
tD(4)=length(find(SNrpointsD>=3));
p(1,:)=tM./sum(tM)*100;
p(2,:)=tD./sum(tD)*100;
figure;
h=bar(p);hold on;
title 'percentage of cells with foci in stationnary phase'
legend('no focus', '1 focus', '2 foci', '>=3 foci');
ylabel 'percentage of cell'
set(gca,'XTickLabel',{'mothers','daugthers'});
colormap summer 
%errorbar([0.5,0.75,1.5,2],p(1,:),std(p(1,:))./sqrt(length(p(1,:))));

