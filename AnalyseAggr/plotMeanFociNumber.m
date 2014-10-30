function h_figure=plotMeanFociNumber

%FIGURE 1:
figure;
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-30.mat');
[meanNum,~,~,~]=computeMean(concat,120,240);
plotMeanNum([0 1 0],meanNum,nNum,0.25,1,119);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-35.mat');
[meanNum,~,~,~]=computeMean(concat,20,139);
plotMeanNum([0 0 1],meanNum,nNum,2.8,1,119);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-38.mat');
[meanNum,~,~,~]=computeMean(concat,1,119);
plotMeanNum([1 0 0],meanNum,nNum,1.4,1,119);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-40.mat');
[meanNum,~,~,~]=computeMean(concat,1,119);
plotMeanNum([0 0 0],meanNum,nNum,1.85,1,119);
plotMeanNumLegend(119);
h_figure(1)=gca;


%FIGURE 2:
figure;
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-30.mat');
[~,~,~,meanRadius]=computeMean(concat,120,240);
plotMeanRad([0 1 0],meanRadius,nNum,0.12,1,119);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-35.mat');
[~,~,~,meanRadius]=computeMean(concat,20,139);
plotMeanRad([0 0 1],meanRadius,nNum,0.29,1,119);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-38.mat');
[~,~,~,meanRadius]=computeMean(concat,1,119);
plotMeanRad([1 0 0],meanRadius,nNum,0.38,1,119);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-40.mat');
[~,~,~,meanRadius]=computeMean(concat,1,119);
plotMeanRad([0 0 0],meanRadius,nNum,0.25,1,119);
plotMeanRadLegend(119);
h_figure(2)=gca;

end

function plotMeanNum(Color,meanNum,nNum,alt,initFrame,lastFrame)
    timing=[1:lastFrame-initFrame+1];
    timing=timing-1;
    timing=timing/20;
    hold on;
    plot(timing,meanNum(1,initFrame:lastFrame),'Color',Color,'LineWidth',1);
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    %text(119,alt,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',Color,'FontSize',12);
    hold off;
end

function plotMeanNumLegend(lastFrame)
    fsize=14;
    hold on;
    legend('30°C','35°C','38°C','40°C');
    for i=0:5
        %plot([1 lastFrame],[i i],'k--','LineWidth',0.5);
        plot([0 6],[i i],'k--','LineWidth',0.5);
    end
    ylabel('Nombre moyen','FontSize',fsize);
    xlabel('Temps (heure)','FontSize',fsize);
%     inter=3;
%     a=get(gca,'XTick');
%     l=length(a);
%     str=cell(1,l);
%     for i=1:l
%         str{i}=num2str(a(i)*inter/60);
%     end
%     set(gca,'XTickLabel',str,'FontSize',fsize);
    set(gca,'XTickLabel',{'0','1','2','3','4','5','6'},'FontSize',fsize);
    hold off;
end

function plotMeanRad(Color,meanNum,nNum,alt,initFrame,lastFrame)
    timing=[1:lastFrame-initFrame+1];
    timing=timing-1;
    timing=timing/20;
    hold on;
    plot(timing,meanNum(1,initFrame:lastFrame),'Color',Color,'LineWidth',1);
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    %text(119,alt,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',Color,'FontSize',12);
    hold off;
end

function plotMeanRadLegend(lastFrame)
    fsize=14;
    hold on;
    legend('30°C','35°C','38°C','40°C','Location','NorthWest');
    for i=0:5
        %plot([1 lastFrame],[i/10 i/10],'k--','LineWidth',0.5);
        plot([0 6],[i/10 i/10],'k--','LineWidth',0.5);
    end
    ylabel('Rayon moyen (µm)','FontSize',fsize);
    xlabel('Temps (heure)','FontSize',fsize);
%     inter=3;
%     a=get(gca,'XTick')
%     l=length(a)
%     str=cell(1,l);
%     for i=1:l
%         str{i}=num2str(a(i)*inter/60);
%     end
%     set(gca,'XTickLabel',str,'FontSize',fsize);
    set(gca,'XTickLabel',{'0','1','2','3','4','5','6'},'FontSize',fsize);
    hold off;
end


function [meanNum,meanFluo,meanFoci,meanRadius]=computeMean(concat,initFrame,lastFrame)
%initialization
n=lastFrame-initFrame+1;
meanNum=zeros(1,n);
meanFluo=zeros(1,n);
meanFoci=zeros(1,n);
meanRadius=zeros(1,n);

counter=0;
for i=initFrame:lastFrame
    counter=counter+1;
    number=concat{1,i};
    fluo=concat{2,i};
    foci=concat{3,i};
    radius=concat{4,i};
    meanNum(1,counter)=mean(number);
    meanFluo(1,counter)=mean(fluo);
    meanFoci(1,counter)=mean(foci);
    meanRadius(1,counter)=mean(radius);
end
end