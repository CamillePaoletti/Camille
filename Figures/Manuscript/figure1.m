function []=figure1

%Camille Paoletti - 09/2014
%manuscript figure 1

display=0;

global timeLapse
timeLapse.interval=180;

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-38.mat');
%[~,h_figure3,cbar_axes,h_gr3]=compareMeanFociNumberBatch_fr(1, 42, 119,concat,nNum,Area,Volume,display);
[~,h_figure3,cbar_axes,~]=compareMeanFociNumberBatch_fr(1, 42, 119,concat,nNum,Area,Area,display);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-35.mat');
[~,h_figure2,cbar_axes2,~]=compareMeanFociNumberBatch_fr(20, 62, 139,concat,nNum,Area,Volume,display);

%h_fig_mean=plotMeanFociNumber;


fsize=14;

h_38=plot_temp_38();

hFig = figure;
pos=get(hFig,'Position');
set(hFig, 'Position', [pos(1) pos(2) pos(3)*2 pos(4)]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack({15 42.5 42.5});
end
p(1).pack({1},{40,10,50});
p(2).pack({1},{40,10,50});
p(3).pack({1},{40,10,50});


%p.de.margin = 10;%marge tout autour
%p.marginbottom = 20;
%p.margin
% p(2).marginright = 50;
p.margin = [20 15 7 10];%marginleft, marginbottom, marginright, margintop
% p(2).marginleft = 50;
%p.select('all');
% set some font properties
p.fontsize = fsize ;
%p.fontname = 'arial';
% p.select('all');
% p.identify();
% return;

%% (b)

% plot into each panel in turn
p=set_margin(1,7,p);
p(1,1,1).select(h_38);

%margin
p=set_margin(2,5,p);

p(2,1,1).select(h_figure3(1));
title('');
xlabel('');
ylabel('Number of foci per cell');
set(gca,'XTickLabel',{});

pos_bar=get(gca,'Position');


%margin
p=set_margin(3,5,p);
p(3,1,1).select(h_figure3(3));
title('');
ylabel('Intensity in foci (a.u.)');
xlabel('Time (hours)');
set(gca,'XTick',[1,20,40,60,80,100,119]);
set(gca,'XTickLabel',{'0','1','2','3','4','5','6'},'FontSize',fsize);

% n=1001;
% [persoMap]=cbrewer('seq', 'Greys', n, 'cubic');%'Blues' 'PuBu'
% persoMap=jet(n);
% newX = logspace(0, log10(2), n)-1;
% newX=fliplr(1-newX);
% logMap = interp1(1:n, persoMap, n*newX);
% persoMap=logMap;
% persoMap(1,:)=[1 1 1];
%colormap(persoMap(1:10:end,:));
colormap(jet(100))

pos=get(gca,'Position');

p(2,1,2).select(cbar_axes);
h=cbar_axes;
get(h,'YTick')
get(h,'YTickLabel')
%caxis([log10(0.5) log10(100)]);
sca=[0.5 1 2 5 10 20 50 100];
scal=log10(sca);
%scal=[scal 1.97];
set(gca,'YTick',scal);
set(h,'YTickLabel',{'0.5' '1' '2','5', '10','20','50','100'});
%ylabel(h,'Fraction des événements (%)');
set(cbar_axes,'Position',[pos_bar(1)+pos_bar(3)+0.01 pos_bar(2)-0.012 0.02 pos_bar(4)*1.02]);

p(3,1,2).select(cbar_axes2);
h=cbar_axes2;
%caxis([0 log10(100)]);
sca=[0.5 1 2 5 10 20 50 100];
scal=log10(sca);
%scal=[scal 1.97];
set(gca,'YTick',scal);
set(h,'YTickLabel',{'0.5' '1' '2','5', '10','20','50','100'});
%ylabel(h,'Fraction des événements (%)');
set(cbar_axes2,'Position',[pos(1)+pos(3)+0.01 pos(2) 0.02 pos(4)]);


export_fig('/Users/camillepaoletti/Documents/Lab/Manuscripts/HSP104/figure1-temp.pdf','-pdf','-transparent');
%close all;

end

function h_38=plot_temp_38()
load('/Users/camillepaoletti/Documents/Lab-WorkInProgress/131029_HS_CDC10-HSP104CP03/131029_HS_CDC10-HSP104-MonitorLog.mat');
load('/Users/camillepaoletti/Documents/Lab-WorkInProgress/131029_HS_CDC10-HSP104CP03/131029_HS_CDC10-HSP104-project.mat');
temp=[monitorSpy.list(1,1:end-1).currentTemperature1];
inter=double(timeLapse.interval/60);
timing=[1:1:timeLapse.numberOfFrames-1];
timing=double(timing);
timing=timing.*inter./60;
h=figure;
plot(timing,temp,'r-','LineWidth',1);
ylabel('T (°C)');
h=gcf;
pos=get(h,'Position');
pos(4)=round(pos(4)/4);
set(h,'Position',pos);
set(gca,'XTickLabel',{});
set(gca,'XTick',[0:1:6]);
ylim([29 42]);
%title('T = 30°C à 38°C');
h_38=gca;
end



function p=set_margin(a,b,p)
p(a,1,1).marginright = b;
p(a,1,1).marginleft = b;
p(a,1,2).marginright = b;
p(a,1,2).marginleft = b;
p(a,1,3).marginright = b;
p(a,1,3).marginleft = b;
% p(a,1,4).marginright = b;
% p(a,1,4).marginleft = b;
% p(a,1,5).marginright = b;
% p(a,1,5).marginleft = b;
p(a).marginbottom = b;
p(a).margintop = b;
end