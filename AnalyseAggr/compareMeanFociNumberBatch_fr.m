%function [h_growth,h_figure]=compareMeanFociNumberBatch(path,file,position,initFrame, hsFrame, lastFrame,mode)%

%Camille Paoletti - 11/2013
function [h_growth,h_figure,cbar_axes,h_gr]=compareMeanFociNumberBatch_fr(initFrame, hsFrame, lastFrame,concat,nNum,area,volume,display)

%mode='all' or 'hsCells' or 'newCells'

%ex: compareMeanFociNumberBatch(1, 42, 119, 'hsCells')

%extraction of values of number/fluo_mean/fluo_tot/radius...
%[concat,nNum,area,volume]=extract_values(path,file,position,initFrame, hsFrame, lastFrame,mode);

[h_growth]=plotGrowthEvolution(initFrame,hsFrame,lastFrame,volume);

[h_gr]=plotGrowthRateEvolution(initFrame,hsFrame,lastFrame,volume);

[meanNum,HISTO,meanFluo,HISTO2,meanFoci,HISTO3,meanRadius,HISTO4,y,y2]=compute_mean_and_histo(concat,initFrame,lastFrame);

persoMap=load('/Users/camillepaoletti/Documents/MATLAB/Camille/AnalyseAggr/persoMap2.mat');
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

n=1001;
[persoMap]=cbrewer('seq', 'PuBu', n, 'cubic');%'Blues' 'PuBu'
% persoMap=jet(n);
% newX = logspace(0, log10(2), n)-1;
% newX=fliplr(1-newX);
% logMap = interp1(1:n, persoMap, n*newX);
% persoMap=logMap;
%colormap(jet(100));

%FIGURE 1:
    %flattening
    h=figure;
    if ~display
        set(h,'Visible','off');
    end
    pos=get(h,'Position');
    pos(4)=round(pos(4)/2);
    set(h,'Position',pos);
    
    pcolor(transpose(log10(HISTO*100)));
    colormap(persoMap(1:10:end,:));
    %set(gcf, 'Colormap', evalin('base', 'persoMap'))
    %line display off
    shading(gca,'flat');
    %color
    cbar_axes=colorbar;
    %axis limit
    caxis([log10(0.5) log10(100)]);
    ylim([1,11]);
    %labels
    ylabel(cbar_axes,'Fraction of events (%)','FontSize',fsize);
    ylabel('Nombre d agrégats par cellule','FontSize',fsize);
    xlabel('Temps (heures)','FontSize',fsize);
    title('Evolution du nombre d agrégats par cellule','FontSize',fsize);
    set(gca,'YTick',[1.5:1:10.5]);
    set(gca,'YTickLabel',{'0' '1' '2' '3' '4' '5' '6' '7' '8' '>9'},'FontSize',fsize);
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
    plot(timing,meanNum(1,:)+1.5,'w-','LineWidth',1.25);
    for i=0:9
        plot([1 lastFrame],[i i]+1.5,'w--','LineWidth',0.5);
    end
    %errorbar([1:1:lastFrame],meanNum(4,:)+1.5,stdNum(4,:)./sqrt(nNum(4,:)),'w-');
    text(115,10,['n = ',num2str(nNum),' cellules'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',fsize,'FontWeight','bold');
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
    pcolor(transpose(log10(HISTO2*100)));
    %colormap(persoMap(1:10:end,:));
    %line display off
    shading(gca,'flat');
    %colorbar
    h=colorbar;
    %axis limits
    caxis([log10(0.5) log10(100)]);
    %ylim([1,11]);
    %labels
    ylabel(h,'Fraction des événements (%)','FontSize',fsize);
    ylabh = get(h,'YLabel');
    ylabel('Intensité dans les agrégats par cellules (u.a.)','FontSize',fsize);
    xlabel('Temps (heures)','FontSize',fsize);
    title('Evolution de l intensité dans les agrégats par cellules','FontSize',fsize);
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
    text(115,2,['n = ',num2str(nNum),' cellules'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',fsize,'FontWeight','bold');
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
    pcolor(transpose(log10(HISTO3*100)));
    %colormap(persoMap(1:10:end,:));
    %line display off
    shading(gca,'flat');
    %colorbar
    h=colorbar;
    %axis limits
    caxis([log10(0.5) log10(100)]);
    %ylim([1,11]);
    %labels
    ylabel(h,'Fraction des événements (%)','FontSize',fsize);
    ylabh = get(h,'YLabel');
    ylabel('Indensité dans les agrégats (u.a.)','FontSize',fsize);
    xlabel('Temps (heures)','FontSize',fsize);
    title('Evolution de l intensité dans les agrégats','FontSize',fsize);
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
    text(115,2,['n = ',num2str(nNum),' cellules'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',fsize,'FontWeight','bold');
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
    pcolor(transpose(log10(100*HISTO4)));
    %colormap(persoMap(1:10:end,:));
    %line display off
    shading(gca,'flat');
    %color
    h=colorbar;
    %axis limit
    caxis([log10(0.5) log10(100)]);
    ylim([1,11]);
    %labels
    ylabel(h,'Fraction des événements (%)','FontSize',fsize);
    ylabh = get(h,'YLabel');
    ylabel('Rayon des agrégats (µm)','FontSize',fsize);
    xlabel('Temps (heures)','FontSize',fsize);
    title('Evolution du rayon des agrégats','FontSize',fsize);
    set(gca,'YTick',[1.5:1:10.5]);
    set(gca,'YTickLabel',{'0' '0.05' '0.10' '0.15' '0.20' '0.25' '0.30' '0.35' '0.40' '>0.45'},'FontSize',fsize);
    %set(h,'YTickLabel',{'0', '20','40','60','80','100'});
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
    text(115,10,['n = ',num2str(nNum),' cellules'],'horizontalAlignment','right','Color',[1 1 1],'FontSize',fsize,'FontWeight','bold');
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
title('Evolution du taux de croissance au cours du temps','FontSize',fsize);
xlabel('Temps (heures)','FontSize',fsize);
ylabel('Taux de croissance (min^{-1})','FontSize',fsize);
xlim([0 6]);
h_figure=gca;

end