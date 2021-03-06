%[concat2,nNum2,area2,volume2]=extract_values('','131029_HS_CDC10-HSP104',[2:5],1, 42, 119,'hsCells');
%[concat,nNum,area,volume]=extract_values('','140314-control-CP03-1',[4],120, 162, 240,'hsCells');
%saved in MATLAB/manuscript/supp-3.mat (to load) !!!
%function []=supp_figure3(concat,nNum,area,volume,concat2,nNum2,area2,volume2)
function []=supp_figure3

%Camille Paoletti - 04/2014
%supplementary figure 3

display=0;

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-30.mat');
[h_growth,h_figure,cbar_axes,h_gr]=compareMeanFociNumberBatch(120, 162, 240,concat,nNum,Area,Volume,display);
%[h_growth3,h_figure3,cbar_axes3,hgr3]=compareMeanFociNumberBatch(120, 121, 240,concat,nNum,area,volume,display);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/supp-3-WT-38.mat');
[h_growth2,h_figure2,cbar_axes2,h_gr2]=compareMeanFociNumberBatch(1, 42, 119,concat,nNum,Area,Volume,display);

fsize=12;

h_38=plot_temp_38();
h_30=plot_temp_30();


hFig = figure;
pos=get(hFig,'Position');
set(hFig, 'Position', [pos(1) pos(2) pos(3) pos(4)*1.5]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack({10 30 30 30});
end
p(1).pack({1},{48,48,4});
p(2).pack({1},{48,48,4});
p(3).pack({1},{48,48,4});
p(4).pack({1},{48,48,4});

%p.de.margin = 10;%marge tout autour
%p.marginbottom = 20;
%p.margin
% p(2).marginright = 50;
p.margin = [20 15 7 10];%marginleft, marginbottom, marginright, margintop
% p(2).marginleft = 50;
%p.select('all');
% set some font properties
p.fontsize = fsize ;


%% (b)

% plot into each panel in turn
p=set_margin(1,7,p);
p(1,1,1).select(h_30);
p(1,1,2).select(h_38);

%margin
p=set_margin(2,5,p);

p(2,1,1).select(h_gr);
title('');
xlabel('');
ylim([0 7e-3]);
set(gca,'XTickLabel',{});
%set(gca,'XTick',[0:1:6]);

p(2,1,2).select(h_gr2);
title('');
ylabel('');
ylim([0 7e-3]);
set(gca,'YTickLabel',{});
set(gca,'XTickLabel',{});
%set(gca,'XTick',[0:1:6]);
xlabel('');

%margin
p=set_margin(3,5,p);
p(3,1,1).select(h_figure(1));
title('');
xlabel('');
set(gca,'XTickLabel',{});

p(3,1,2).select(h_figure2(1));
title('');
ylabel('');
set(gca,'YTickLabel',{});
xlabel('');
set(gca,'XTickLabel',{});
pos_bar=get(gca,'Position')

%margin
p=set_margin(4,5,p);
p(4,1,1).select(h_figure(4));
title('');

p(4,1,2).select(h_figure2(4));
title('');
ylabel('');
set(gca,'YTickLabel',{});
pos=get(gca,'Position');

p(3,1,3).select(cbar_axes);
h=cbar_axes;
set(h,'YTickLabel',{'0', '20','40','60','80','100'});
ylabel(h,'Fraction of events (%)');
set(cbar_axes,'Position',[pos_bar(1)+pos_bar(3)+0.03 pos_bar(2)-0.015 0.02 pos_bar(4)*1.03]);

p(4,1,3).select(cbar_axes2);
h=cbar_axes2;
set(h,'YTickLabel',{'0', '20','40','60','80','100'});
ylabel(h,'Fraction of events (%)');
set(cbar_axes2,'Position',[pos(1)+pos(3)+0.03 pos(2) 0.02 pos(4)]);



end


function h_30=plot_temp_30()
load('/Users/camillepaoletti/Documents/Lab-WorkInProgress/140314_control-CP03-1/140314-control-CP03-1-MonitorLog.mat');
load('/Users/camillepaoletti/Documents/Lab-WorkInProgress/140314_control-CP03-1/140314-control-CP03-1-project.mat');
temp=[monitorSpy.list(1,1:end-1).currentTemperature1];
inter=double(timeLapse.interval/60);
timing=[1:1:timeLapse.numberOfFrames-1];
timing=double(timing);
timing=timing.*inter./60;
h=figure;
plot(timing,temp,'r-','LineWidth',1);
ylabel('T (�C)');
h=gcf;
pos=get(h,'Position');
pos(4)=round(pos(4)/4);
set(h,'Position',pos);
set(gca,'XTickLabel',{});
set(gca,'XTick',[0:1:6]);
ylim([29 40]);
xlim([0 6]);
title('Control - T = 30�C');
h_30=gca;
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
h=gcf;
pos=get(h,'Position');
pos(4)=round(pos(4)/4);
set(h,'Position',pos);
set(gca,'YTickLabel',{});
set(gca,'XTickLabel',{});
set(gca,'XTick',[0:1:6]);
ylim([29 40]);
title('Heat Shock - T = 30�C to 38�C');
h_38=gca;
end

function p=set_margin(a,b,p)
p(a,1,1).marginright = b;
p(a,1,2).marginleft = b;
p(a,1,2).marginright = b;
p(a,1,2).marginleft = b;
p(a).marginbottom = b;
p(a).margintop = b;
end




