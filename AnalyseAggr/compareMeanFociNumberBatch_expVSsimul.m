function []=compareMeanFociNumberBatch_expVSsimul(path,file,position,initFrame, hsFrame, lastFrame,mode)
%
%Camille Paoletti - 11/2013

%mode='all' or 'hsCells' or 'newCells'

%ex: compareMeanFociNumberBatch(1, 42, 119, 'hsCells')

global segmentation timeLapse segList

filen='segmentation-batch.mat';
[timeLapsepath , timeLapsefile]=setProjectPath(path,file);

data=load('simul.mat');

Data=cell(3,1);
nNum=0;

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

        [number,fluo,foci,nNum_temp]=compareMeanFociNumber(initFrame, hsFrame, lastFrame,mode,0);
        
        
        a=number(1,:);
        Data{1,1}=horzcat(Data{1,1},a(:));
        a=fluo(1,:);
        Data{2,1}=horzcat(Data{2,1},a(:));
        a=foci(1,:);
        Data{3,1}=horzcat(Data{3,1},a(:));
        nNum=nNum+nNum_temp;
        

    end

end

n=lastFrame-initFrame+1;
concat=cell(3,n);
for j=1:3
    for i=initFrame:lastFrame
        concat{j,i}=horzcat(Data{j,1}{i,:});
    end
end

meanNum=zeros(1,n);
HISTO=zeros(n,11);
meanFluo=zeros(1,n);
HISTO2=zeros(n,13);
meanFoci=zeros(1,n);
HISTO3=zeros(n,13);


counter=0;
for i=initFrame:lastFrame
    
    counter=counter+1;
    number=concat{1,i};
    fluo=concat{2,i};
    foci=concat{3,i};
    
    meanNum(1,counter)=mean(number);
    HISTO(counter,:) = histc(number,[0 1 2 3 4 5 6 7 8 9 10])./length(number);
    
    meanFluo(1,counter)=mean(fluo);
    ymax=6;
    y=[0:0.5:ymax];
    %y=y.*7/10;
    y=10.^y;
    %y=[0,y];
    %y(1)=0;
    
    HISTO2(counter,:) = histc(fluo,y)./length(fluo);
    
    meanFoci(1,counter)=mean(foci);
    HISTO3(counter,:) = histc(foci,y)./length(foci);
    
    
end

plotfigure(HISTO,HISTO2,HISTO3,meanNum,nNum,y,meanFluo,meanFoci,lastFrame,data);

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

function plotfigure(HISTO,HISTO2,HISTO3,meanNum,nNum,y,meanFluo,meanFoci, lastFrame,data)
global timeLapse
%point size
    fsize=14;
%personalized colormap
%     cmap = [204 0 51   % Rouge doux
%         0 1 0   % Triplet RGB de la couleur verte
%         102 204 204]; % Bleu doux
%     cmap=cmap./255;
% 
% colormap(cmap);

%FIGURE 1:
    %flattening
    h=figure;
    pos=get(h,'Position');
    pos(4)=round(pos(4)/2);
    set(h,'Position',pos);
    %plot
    pcolor(transpose(HISTO));
    %line display off
    shading(gca,'flat');
    %color
    h=colorbar;
    %axis limit
    caxis([0 1]);
    ylim([1,11]);
    %labels
    ylabel(h,'Fraction of events (%)','FontSize',fsize);
    ylabh = get(h,'YLabel');
    ylabel('Number of foci per cell','FontSize',fsize);
    xlabel('Time (hours)','FontSize',fsize);
    title('Evolution of Number of Foci per Cell','FontSize',fsize);
    set(gca,'YTick',[1.5:1:10.5]);
    set(gca,'YTickLabel',{'0' '1' '2' '3' '4' '5' '6' '7' '8' '>9'},'FontSize',fsize);
    set(h,'YTickLabel',{'0', '20','40','60','80','100'});
    inter=timeLapse.interval/60;
    a=get(gca,'XTick');
    l=length(a);
    str=cell(1,l);
    for i=1:l
        str{i}=num2str(i*a(1)*inter/60);
    end
    set(gca,'XTickLabel',str,'FontSize',fsize);
    
    %mean plot
    hold on;
    timing=[1:1:lastFrame];
    plot(timing,meanNum(1,:)+1.5,'w-','LineWidth',1);
    for i=0:9
        plot([1 119],[i i]+1.5,'w--','LineWidth',0.5);
    end
    plot(timing(42:42+66),data.numberSimul_mean(1,1:3:end)+1.5,'r-','LineWidth',1);
    %errorbar([1:1:119],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,10,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    
%FIGURE 2;
    %flattening
    h=figure;
    pos=get(h,'Position');
    pos(4)=round(pos(4)/2);
    set(h,'Position',pos);
    %plot
    pcolor(transpose(HISTO2));
    %line display off
    shading(gca,'flat');
    %colorbar
    h=colorbar;
    %axis limits
    caxis([0 1]);
    %ylim([1,11]);
    %labels
    ylabel(h,'Fraction of events (%)','FontSize',fsize);
    ylabh = get(h,'YLabel');
    ylabel('Intensity in foci per cell (a.u.)','FontSize',fsize);
    xlabel('Time (hours)','FontSize',fsize);
    title('Evolution of Intensity in Foci per Cell','FontSize',fsize);
    set(gca,'YTick',[1.5:1:15.5]);
    str=cell(1,1);
    %str{1,1}=0;
    for i=1:length(y)-1
        %str{1,i+1}=['10^',num2str(i-1)];
        %str{1,i}=num2str(y(i));
        str{1,i}=['10^',num2str(0.5*(i-1))];
    end
    set(gca,'YTickLabel',str,'FontSize',fsize);
    
    %str={'0%','50%','100%'};
    %set(h,'YtickLabel',str);
    set(h,'YTickLabel',{'0', '20','40','60','80','100'});
    inter=timeLapse.interval/60;
    a=get(gca,'XTick');
    l=length(a);
    str=cell(1,l);
    for i=1:l
        str{i}=num2str(i*a(1)*inter/60);
    end
    set(gca,'XTickLabel',str,'FontSize',fsize);
    
    %mean plot
    hold on;
    timing=[1:1:119];
    plot(timing,(log10(meanFluo(1,:))*2)+1.5,'w-','LineWidth',1);%plot(timing,(log10(meanFluo(n,:)))/7*10+1.5,'w-','LineWidth',1);
    for i=0:length(y)
        plot([1 119],[i i]+1.5,'w--','LineWidth',0.5);
    end
    MIN=0;
    MAX=10^4.25;
    MAXEXP=10^5.1;
    MINEXP=10^2;
    Y=[1,data.massSimul_mean(1,4:3:end)];
    Y=(Y-MIN)*(MAXEXP-MINEXP)/(MAX-MIN)+MINEXP;
    Y=(log10(Y)*2)+1.5;
    plot(timing(42:42+66),Y,'r-','LineWidth',1);
    text(115,2,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    %test=meanFluo(n,:);
    
%FIGURE 3;
    %flattening
    h=figure;
    pos=get(h,'Position');
    pos(4)=round(pos(4)/2);
    set(h,'Position',pos);
    %plot
    pcolor(transpose(HISTO3));
    %line display off
    shading(gca,'flat');
    %colorbar
    h=colorbar;
    %axis limits
    caxis([0 1]);
    %ylim([1,11]);
    %labels
    ylabel(h,'Fraction of events (%)','FontSize',fsize);
    ylabh = get(h,'YLabel');
    ylabel('Intensity in foci (a.u.)','FontSize',fsize);
    xlabel('Time (hours)','FontSize',fsize);
    title('Evolution of Intensity in Foci','FontSize',fsize);
    set(gca,'YTick',[1.5:1:15.5]);
    str=cell(1,1);
    %str{1,1}=0;
    for i=1:length(y)-1
        %str{1,i+1}=['10^',num2str(i-1)];
        %str{1,i}=num2str(y(i));
        str{1,i}=['10^',num2str(0.5*(i-1))];
    end
    set(gca,'YTickLabel',str,'FontSize',fsize);
    
    %str={'0%','50%','100%'};
    %set(h,'YtickLabel',str);
    set(h,'YTickLabel',{'0', '20','40','60','80','100'});
    inter=timeLapse.interval/60;
    a=get(gca,'XTick');
    l=length(a);
    str=cell(1,l);
    for i=1:l
        str{i}=num2str(i*a(1)*inter/60);
    end
    set(gca,'XTickLabel',str,'FontSize',fsize);
    %mean plot
    n=1;%n=4
    hold on;
    timing=[1:1:119];
    plot(timing,(log10(meanFoci(1,:))*2)+1.5,'w-','LineWidth',1);%plot(timing,(log10(meanFluo(n,:)))/7*10+1.5,'w-','LineWidth',1);
    for i=0:length(y)
        plot([1 119],[i i]+1.5,'w--','LineWidth',0.5);
    end
    MIN=2919;
    MAX=12850;
    MAXEXP=10^4.8;
    MINEXP=10^2.5;
    Y=[1,data.massSimul_mean(1,4:3:end)./data.numberSimul_mean(1,4:3:end)];
    Y=(Y-MIN)*(MAXEXP-MINEXP)/(MAX-MIN)+MINEXP;
    Y=(log10(Y)*2)+1.5;
    plot(timing(42:42+66),Y,'r-','LineWidth',1);
    %plot(timing(42:42+66),(log10(data.massSimul_mean(1,1:3:end))*2)+1.5,'r-','LineWidth',1);
    %errorbar([1:1:119],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,2,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    %test=meanFluo(n,:);


end