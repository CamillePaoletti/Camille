function [Number,Fluo,Foci,Radius,NNum]=compareMeanFociNumber_frame(frames,mode,display)
%
%Camille Paoletti - 11/2013

%compare the evolution of the mean number of foci per cell present at HS
%for different parameters of segmentation (foci/mito/nucleus or cytoSubstracted/nonSubstracted...)
%ex: hsFrame=162;

%mode='all' or 'hsCells' or 'newCells'

global segmentation;
global timeLapse;

compare=0;

feat={'Nrpoints','fluoCytoMean','fluoCytoVar','fluoCytoMin','fluoNuclVar'};
nb=length(feat);
Color={'b','r','g','m'};
cells=segmentation.cells1(frames(1),:);
num=[cells.n];
numel=find(num);
num=num(numel);%n° of cells present at hsFrame

cc=0;
counter=0;
len=length(frames);
meanNum=zeros(nb,len);
stdNum=zeros(nb,len);
nNum=zeros(nb,len);
meanFluo=zeros(1,len);
Number=cell(1,len);
Foci=cell(1,len);
Fluo=cell(1,len);
Radius=cell(1,len);

meanNum=zeros(1,len);
HISTO=zeros(len,11);
meanFluo=zeros(1,len);
HISTO2=zeros(len,13);
meanFoci=zeros(1,len);
HISTO3=zeros(len,13);
meanRadius=zeros(1,len);
HISTO4=zeros(len,11);


for frame=frames
    cc=cc+1;
    cells=segmentation.cells1(frame,:);
    n=[cells.n];
%    if frame>hsFrame
        switch mode
            case 'all'
                numel=find(n);
                %n=n(numel);
            case 'hsCells'
                [~,~,ib]=intersect(num,n);
                %[cells(ib).n]
                numel=ib;
                %ibb=[1:1:length(n)];
                %ibb(numel)=0;
            case 'newCells'
                [~,~,ib]=intersect(num,n);
                n(ib)=0;
                numel=find(n);
        end
    %else
        numel=find(n);
    %end
    
    %test{frame}=numel;
    
    for f=1:nb
        N=[cells(numel).([feat{f}])];
        meanNum(f,cc)=mean(N);
        stdNum(f,cc)=std(N);
        nNum(f,cc)=length(numel);
    end
    
    
    foci=[];
    radius=[];
    for i=numel
        if size(segmentation.cells1(frame,i).vy,1)>1 %2 lines so there is a least one focus
            foci_temp=[segmentation.cells1(frame,i).vy(1,:)].*[segmentation.cells1(frame,i).vy(2,:)];
            foci=[foci,foci_temp];
            radius_temp=[segmentation.cells1(frame,i).vy(1,:)]*0.08^2;
            radius_temp=(radius_temp/pi).^(1/2);
            radius=[radius,radius_temp];
        end
    end
    
    if isempty(foci)
        foci=0;
        radius=0;
    end
    
    counter=counter+1;
    number=[cells(numel).([feat{1}])];%nb of foci in each cell
    fluo=[cells(numel).([feat{5}])];%mean fluo of foci
    
    Foci{1,frame}=foci;
    Fluo{1,frame}=fluo;
    Number{1,frame}=number;
    Radius{1,frame}=radius;
    
    if display
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
        %         subplot(3,4,counter);
        %         bar(n);
        %         ylabel('Number of Events');
        %         xlabel('Number of foci per cell');
        %         set(gca,'XTickLabel',{'0' '1' '>2'});
        
        %end
        
        meanFoci(1,counter)=mean(foci);
        HISTO3(counter,:) = histc(foci,y)./length(foci);
        
        meanRadius(1,counter)=mean(radius);
        y2=[0:0.1:1];
        HISTO4(counter,:) = histc(radius,y2);%./length(radius);
    end
    
end

NNum=nNum(1,cc);


if display
    if compare;
        timing=[initFrame:lastFrame].*double(timeLapse.interval/3600);
        %%%%%%%%%%%%%%%%%%
        
        
        figure;
        errorbar(timing,meanNum(1,:),stdNum(1,:)./sqrt(nNum(1,:)));
        title('Evolution of the mean number of foci following heat shock');
        xlabel('Time (min)');
        ylabel('Mean number of foci per cell');
        text(max(timing)-3,max(meanNum(1,:))-1,['n = ',num2str(nNum(1,cc)),' cells'],'horizontalAlignment','right');
        hold on;
        for j=2:nb
            errorbar(timing,meanNum(j,:),stdNum(j,:)./sqrt(nNum(j,:)),Color{j});
        end
        legend('segmentFoci3 - 15/50','segmentFoci3 - 15/60','segmentFoci3 - 15/70','segmetnFoci4 - 20/70');
        hold off;
        %%%%%%%%%%%%%%%%%%%
        figure;
        hold on;
        for j=1:nb
            plot(log(timing(hsFrame:hsFrame+20)),log(meanNum(j,(hsFrame:hsFrame+20))),Color{j});
        end;
        legend('segmentFoci3 - 15/50','segmentFoci3 - 15/60','segmentFoci3 - 15/70','segmetnFoci4 - 20/70');
        hold off;
    end
    
    plotfigure(HISTO,HISTO2,HISTO3,meanNum,NNum,y,meanFluo,meanFoci, lastFrame,HISTO4,meanRadius,y2)
    
end

end

function plotfigure(HISTO,HISTO2,HISTO3,meanNum,nNum,y,meanFluo,meanFoci, lastFrame,HISTO4,meanRadius,y2)
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
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
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
    timing=[1:1:lastFrame];
    plot(timing,(log10(meanFluo(1,:))*2)+1.5,'w-','LineWidth',1);%plot(timing,(log10(meanFluo(n,:)))/7*10+1.5,'w-','LineWidth',1);
    for i=0:length(y)
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
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
    timing=[1:1:lastFrame];
    plot(timing,(log10(meanFoci(1,:))*2)+1.5,'w-','LineWidth',1);%plot(timing,(log10(meanFluo(n,:)))/7*10+1.5,'w-','LineWidth',1);
    for i=0:length(y)
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,2,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    %test=meanFluo(n,:);

    
%FIGURE 4:
    %flattening
    h=figure;
    pos=get(h,'Position');
    pos(4)=round(pos(4)/2);
    set(h,'Position',pos);
    %plot
    pcolor(transpose(HISTO4));
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
    ylabel('Radius of foci (µm)','FontSize',fsize);
    xlabel('Time (hours)','FontSize',fsize);
    title('Evolution of Radius of Foci','FontSize',fsize);
    set(gca,'YTick',[1.5:1:10.5]);
    set(gca,'YTickLabel',{'0' '0.1' '0.2' '0.3' '0.4' '0.5' '0.6' '0.7' '0.8' '>0.9'},'FontSize',fsize);
    set(h,'YTickLabel',{'0', '20','40','60','80','100'});
    inter=timeLapse.interval/60;
    a=get(gca,'XTick');
    l=length(a);
    str=cell(1,l);
    for i=1:l
        str{i}=num2str(i*a(1)*inter/60);
    end
    set(gca,'XTickLabel',str,'FontSize',fsize);
%     for i=1:length(y2)
%         str{1,i}=num2str(y2);
%     end
%     set(gca,'YTickLabel',str,'FontSize',fsize);
    
    %mean plot
    hold on;
    timing=[1:1:lastFrame];
    plot(timing,meanRadius(1,:)*10+1.5,'w-','LineWidth',1);
    for i=0:length(y2)
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,10,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    
    

end