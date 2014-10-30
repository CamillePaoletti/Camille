%function [h_growth,h_figure]=compareMeanFociNumberBatch(path,file,position,initFrame, hsFrame, lastFrame,mode)%

%Camille Paoletti - 11/2013
function [h_growth,h_figure,cbar_axes,h_gr]=compareMeanFociNumberBatch(initFrame, hsFrame, lastFrame,concat,nNum,area,volume,display)

%mode='all' or 'hsCells' or 'newCells'

%ex: compareMeanFociNumberBatch(1, 42, 119, 'hsCells')

%extraction of values of number/fluo_mean/fluo_tot/radius...
%[concat,nNum,area,volume]=extract_values(path,file,position,initFrame, hsFrame, lastFrame,mode);

[h_growth]=plotGrowthEvolution(initFrame,hsFrame,lastFrame,volume);

[h_gr]=plotGrowthRateEvolution(initFrame,hsFrame,lastFrame,volume);

[meanNum,HISTO,meanFluo,HISTO2,meanFoci,HISTO3,meanRadius,HISTO4,y,y2]=compute_mean_and_histo(concat,initFrame,lastFrame);

persoMap=load('/Users/camillepaoletti/Documents/MATLAB/Camille/AnalyseAggr/persoMap.mat');
persoMap=persoMap.persoMap;

[h_figure,cbar_axes]=plotfigure(HISTO,HISTO2,HISTO3,meanNum,nNum,y,meanFluo,meanFoci,HISTO4,meanRadius,y2,persoMap,initFrame,lastFrame,display);

end

function [h_figure,cbar_axes]=plotfigure(HISTO,HISTO2,HISTO3,meanNum,nNum,y,meanFluo,meanFoci,HISTO4,meanRadius,y2,persoMap,initFrame,lastFrame,display)
global timeLapse
%point size
    fsize=14;
%personalized colormap
%     cmap = [204 0 51   % Rouge doux
%         0 1 0   % Triplet RGB de la couleur verte
%         102 204 204]; % Bleu doux
%     cmap=cmap./255;
% 
%colormap(cmap);


%FIGURE 1:
    %flattening
    h=figure;
    if ~display
        set(h,'Visible','off');
    end
    pos=get(h,'Position');
    pos(4)=round(pos(4)/2);
    set(h,'Position',pos);
    %plot
    pcolor(transpose(HISTO));
    %colormap(persoMap(1:10:end,:));
    %line display off
    shading(gca,'flat');
    %color
    cbar_axes=colorbar;
    %axis limit
    caxis([0 1]);
    ylim([1,11]);
    %labels
    ylabel(cbar_axes,'Fraction of events (%)','FontSize',fsize);
    ylabel('Number of foci per cell','FontSize',fsize);
    xlabel('Time (hours)','FontSize',fsize);
    title('Evolution of Number of Foci per Cell','FontSize',fsize);
    set(gca,'YTick',[1.5:1:10.5]);
    set(gca,'YTickLabel',{'0' '1' '2' '3' '4' '5' '6' '7' '8' '>9'},'FontSize',fsize);
    set(cbar_axes,'YTickLabel',{'0', '20','40','60','80','100'});
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
    timing=[1:lastFrame-initFrame+1];
    timing=timing-1;
    plot(timing,meanNum(1,:)+1.5,'w-','LineWidth',1);
    for i=0:9
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,10,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    
    h_figure(1)=gca;
    
%FIGURE 2;
    %flattening
    h=figure;
    if ~display
        set(h,'Visible','off');
    end
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
    timing=[1:lastFrame-initFrame+1];
    timing=timing-1;
    plot(timing,(log10(meanFluo(1,:))*2)+1.5,'w-','LineWidth',1);%plot(timing,(log10(meanFluo(n,:)))/7*10+1.5,'w-','LineWidth',1);
    for i=0:length(y)
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    text(115,2,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    %test=meanFluo(n,:);
    
    h_figure(2)=gca;
    
%FIGURE 3;
    %flattening
    h=figure;
    if ~display
        set(h,'Visible','off');
    end
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
    for i=1:2:length(y)-1
        %str{1,i+1}=['10^',num2str(i-1)];
        %str{1,i}=num2str(y(i));
        str{1,i}=['10^',num2str(0.5*(i-1))];
    end
    for i=2:2:length(y)-1
        str{1,i}='';
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
    timing=[1:lastFrame-initFrame+1];
    timing=timing-1;
    plot(timing,(log10(meanFoci(1,:))*2)+1.5,'w-','LineWidth',1);%plot(timing,(log10(meanFluo(n,:)))/7*10+1.5,'w-','LineWidth',1);
    for i=0:length(y)
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,2,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    %test=meanFluo(n,:);
    
    h_figure(3)=gca;
    
    
    %FIGURE 4:
    %flattening
    h=figure;
    if ~display
        set(h,'Visible','off');
    end
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
    set(gca,'YTickLabel',{'0' '0.05' '0.10' '0.15' '0.20' '0.25' '0.30' '0.35' '0.40' '>0.45'},'FontSize',fsize);
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
    timing=[1:lastFrame-initFrame+1];
    timing=timing-1;
    plot(timing,meanRadius(1,:)*20+1.5,'w-','LineWidth',1);
    for i=0:length(y2)
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,10,['n = ',num2str(nNum),' cells'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',12);
    hold off;
    
    h_figure(4)=gca;

end

function [h_figure]=plotGrowthEvolution(initFrame,hsFrame,lastFrame,vol)

global timeLapse ;

timing=[1:lastFrame-initFrame+1];
timing=timing-1;
timing=timing.*double(timeLapse.interval/(60));
fsize=12;

lim=[initFrame,hsFrame,hsFrame+30,lastFrame];
pol=cell(1,length(lim)-1);
for i=1:length(lim)-1
    x=[lim(i):lim(i+1)];
    x=x-initFrame+1;
    pol{i}=polyfit(timing(x),log(vol(x)/vol(1)),1);
    val{i}=polyval(pol{i},timing(x));
end

figure;
size(timing)
size(vol)
plot(timing/60,log(vol/vol(1)),'b+');
title('Evolution of total volume over time','FontSize',fsize);
xlabel('Time(hours)','FontSize',fsize);
ylabel('log(total volume/initial volume)','FontSize',fsize);
hold on;
for i=1:length(lim)-1
    x=[lim(i):lim(i+1)];
    x=x-initFrame+1;
    plot(timing(x)/60,val{i},'r-');
    a=pol{i};
    text(timing(x(1))/60,max(val{i}),[num2str(round(log(2)/a(1))),' min'],'FontSize',fsize);
end
hold off;
xlim([0 6]);
h_figure=gca;

end


function [h_figure]=plotGrowthRateEvolution(initFrame,hsFrame,lastFrame,vol)

global timeLapse ;

x=[1:lastFrame-initFrame+1];
y=vol;

inter = double(timeLapse.interval/(60)); %interval in minutes
timing=(x-1).*inter;
fsize=12;

xx=[1:0.1:lastFrame-initFrame+1];
%yy = spline(x,y,xx);
%yy = smooth(xx,yy,1,'rloess');
yy = smooth(x,y,0.1,'rlowess');
gr = diff(yy); %growth rate
gr = gr / inter ;
gr = gr ./ yy(1:end-1) ;
figure; plot(yy);
figure;plot(gr);

figure;
plot(timing(1:end-1)/60,gr,'b-');
title('Evolution of growth rate upon time','FontSize',fsize);
xlabel('Time(hours)','FontSize',fsize);
ylabel('Growth rate (min^{-1})','FontSize',fsize);
xlim([0 6]);
h_figure=gca;

end