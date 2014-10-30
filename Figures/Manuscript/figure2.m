function []=figure2()

%Camille Paoletti - 09/2014
%figure 2

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT.mat');
[h_figure1,ratMean1]=plotRatioBudMother(meanLen,Data,1);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-all.mat');
[c,h_fig1,area1,rat1]=alpha(Data,0.011,1);
[c,h_fig1b,area1,rat1]=alpha(Data,0.011,1);
%[h_fig1(2)]=plotCorr(Data);


load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-bni1.mat');
[~,ratMean2]=plotRatioBudMother(meanLen,Data,0);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-bni1-all.mat');
[c,h_fig2,area2,rat2]=alpha(Data,0.022,1);
% [h_fig2(2)]=plotCorr(Data);


load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-35.mat');
[~,ratMean3]=plotRatioBudMother(meanLen,Data,0);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-35-all.mat');
%[c,h_fig3,area3,rat3]=alpha(Data,0.007,1);
[c,h_fig3,area3,rat3]=alpha(Data,0.081,1);
%[h_fig3(2)]=plotCorr(Data);


load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-40.mat');
[~,ratMean4]=plotRatioBudMother(meanLen,Data,0);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-40-all.mat');
[c,h_fig4,area4,rat4]=alpha(Data,0.015,1);
%[h_fig4(2)]=plotCorr(Data);


fsize=12;

m=2;
rat{1,1}=ratMean1(m,:);
rat{2,1}=ratMean2(m,:);
rat{3,1}=ratMean3(m,:);
rat{4,:}=ratMean4(m,:);
h_fig=plotMedianRatio(rat,fsize);
h_figA=plotAlpha([0.011,0.022,0.081,0.015],[0.001,0.003,0.005,0.001],fsize);

hFig = figure;
pos=get(hFig,'Position');
set(hFig, 'Position', [pos(1) pos(2) pos(3)*2 pos(4)*2]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack('h',{1/3 1/3 1/3});%horizontal packing
end
p(1).pack('h',{1},{20 40 40});%horizontal packing
p(2).pack('h',{1},{60 40});
p(3).pack('h',{1},{30 40 30});

%p.de.margin = 10;%marge tout autour
%p.marginbottom = 20;
%p.margin
% p(2).marginright = 50;
p.margin = [25 15 10 10];%marginleft, marginbottom, marginright, margintop
% p(2).marginleft = 50;
% p.select('all');
% p.identify();
% set some font properties
marg=20;
p.fontsize = fsize ;
eventsName={'t_{HS}','t_D','t_B'};
% p.select('all');
% p.identify();
% return
%% (b)

% plot into each panel in turn

%COLONNE 1: RATIO
p=set_margin(1,marg,p,3);
%p(1,1,1).select(h_figure1(1));

%concentrations
ymax=55;
p(1,1,2).pack({1},{1/3 1/3 1/3});
p=set_little_margin(1,1,2,p);
p(1,1,2,1,1).select(h_figure1(2));
ylabel('Fluorescence concentration in aggregates (a.u.)');
ylim([0 ymax]);
title(eventsName{1});
p(1,1,2,1,2).select(h_figure1(3));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title(eventsName{2});
p(1,1,2,1,3).select(h_figure1(4));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title(eventsName{3});

p(1,1,3).select(h_figure1(1));
ylim([-0.1 9]);
%set(gca,'xtick',1:3, 'xticklabel',eventsName);
format_ticks(gca,eventsName,[],1:3);
ylabel('Ratio of fluorescence concentration in B/M');
title('');

% p(1,1,2).select(h_figure2(1));
% title('bni1? - 38°C');
% ylim([-0.1 9]);
% 
% p(1,1,3).select(h_figure3(1));
% title('WT - 35°C');
% ylim([-0.1 9]);
% 
% p(1,1,4).select(h_figure4(1));
% title('WT - 40°C');
% ylim([-0.1 9]);
% 
% p(1,1,5).select(h_figure5(1));
% title('hsp42? - 38°C');
% ylim([-0.1 9]);


%COLONNE 2: MODELE
p=set_margin(2,marg,p,2);
p(2,1,2).select(h_fig1(1));
ylabel('Experimental ratio at t_D: R_{exp}=[A_B]/[A_M]');
xlabel('Theoretical ratio R_{theo}=(\alpha+µ_M)/(\alpha+µB)');

%COLONNE 3: PERTURBATION GENETIQUE
p=set_margin(3,marg,p,3);
n=3;
p(n,1,2).pack({1/2 1/2},{1/2 1/2});
p=set_little_margin2(n,1,2,p);
p(n,1,2,1,1).select(h_fig1b(1));
ylabel('Experimental ratio at t_D');
set(gca,'XTickLabel',{});
%title('Sauvage - 38°C');
p(n,1,2,1,2).select(h_fig2(1));
ylabel('');
xlabel('');
set(gca,'XTickLabel',{});
set(gca,'YTickLabel',{});
%title('bni1\Delta');
p(n,1,2,2,1).select(h_fig3(1));
set(gca,'YTickLabel',{});
ylabel('Experimental ratio at t_D');
xlabel('Theoretical ratio');
%title('Sauvage - 35°C');
p(n,1,2,2,2).select(h_fig4(1));
set(gca,'YTickLabel',{});
xlabel('Theoretical ratio');
%title('Sauvage - 40°C');

p(3,1,1).select(h_fig(1));
p(3,1,3).select(h_figA);

export_fig('/Users/camillepaoletti/Documents/MATLAB/test.pdf','-pdf','-transparent');
end

function p=set_margin(a,b,p,l)
p(a,1,1).marginright = b+10;
p(a,1,1).marginleft = b;
p(a,1,2).marginright = b+10;
p(a,1,2).marginleft = b;
if l>2
    p(a,1,3).marginright = b+10;
    p(a,1,3).marginleft = b;
end
p(a).marginbottom = b;
p(a).margintop = b;
end

function p=set_little_margin(a,b,c,p)
p(a,1,c,1,1).marginright = b;
p(a,1,c,1,1).marginleft = b;
p(a,1,c,1,2).marginright = b;
p(a,1,c,1,2).marginleft = b;
p(a,1,c,1,3).marginright = b;
p(a,1,c,1,3).marginleft = b;
end

function p=set_little_margin2(a,b,c,p)
p(a,1,c,1,1).marginright = b;
p(a,1,c,1,1).marginleft = b;
p(a,1,c,1,2).marginright = b;
p(a,1,c,1,2).marginleft = b;
p(a,1,c,2,1).marginright = b;
p(a,1,c,2,1).marginleft = b;
p(a,1,c,2,2).marginright = b;
p(a,1,c,2,2).marginleft = b;
p(a,1,c,1,1).margintop = b;
p(a,1,c,1,1).marginbottom = b;
p(a,1,c,1,2).margintop = b;
p(a,1,c,1,2).marginbottom = b;
p(a,1,c,2,1).margintop = b;
p(a,1,c,2,1).marginbottom = b;
p(a,1,c,2,2).margintop = b;
p(a,1,c,2,2).marginbottom = b;
end

function h_fig=plotCorr(Data)

j=0;
x=[0:0.0001:0.1];
for i=x;
    j=j+1;
    [cor(j),~,~,~,~,s(j)]=alpha(Data,i,0);
end

figure;plot(x,cor);title('cor');
figure;plot(x(1:j),s(1:j));title('res');
%xlim([0 0.05]);
s=s/max(s);
figure;plot(x(1:j),cor(1:j)./s(1:j));title('cor/res');
h_fig=gca;

end

function h_fig=plotMedianRatio(rat,fsize)
n=size(rat,1);
for i=1:n
    rat_temp=rat{i,1};
    num=isnan(rat_temp);
    num2=isinf(rat_temp);
    num=num+num2;
    rat_temp=rat_temp(1,~num);
    med(i)=median(rat_temp);
    mea(i)=mean(rat_temp);
    s(i)=std(rat_temp)/sqrt(length(rat_temp));
    rat_out{i,1}=rat_temp;
end

% figure;
% x=[1:1:length(med)];
% bar(x,med, 'facecolor',rgb('Grey'));
% hold on;
% errorbar(x,med,s,'.r','MarkerSize',1,'Color','k');
% %xlabel('Température (°C)');
% ylabel('Ratio expérimental médian à t_D');
% set(gca,'XTickLabel',{'38°C','Bni1D','35°C','40°C'});
% hold off;
% %xlim([0.5 length(T)+0.5]);
% h_fig(1)=gca;

figure;
set(gca,'FontSize',fsize);
x=[1:1:length(med)];
bar(x,mea, 'facecolor',rgb('Grey'));
hold on;
errorbar(x,mea,s*1.96,'.r','MarkerSize',1,'Color','k');
%xlabel('Température (°C)');
ylabel('Mean experimental ratio <R_{exp}> at t_D');
%set(gca,'XTickLabel',{'38°C','bni1\Delta','35°C','40°C'});
format_ticks(gca,{'WT-38°C','bni1\Delta-38°C','WT-35°C','WT-40°C'},[],x);
hold off;
%xlim([0.5 length(T)+0.5]);
h_fig(1)=gca;

% a=zeros(4,4);
% for i=1:4
%     for j=i:4
%         a(i,j)=ranksum(rat_out{i,1},rat_out{j,1});
%     end
% end
% a

end


function h_fig=plotAlpha(alpha,er,fsize)
figure;
set(gca,'FontSize',fsize);
x=[1:1:length(alpha)];
bar(x,alpha/3, 'facecolor',rgb('Grey'));
hold on;
errorbar(x,alpha/3,er*1.96/3,'.r','MarkerSize',1,'Color','k');
ylim([0 0.1]./3);
ylabel('Transport coefficient \alpha (min^{-1})');
%set(gca,'XTickLabel',{'38°C','bni1\Delta','35°C','40°C'});
format_ticks(gca,{'WT-38°C','bni1\Delta-38°C','WT-35°C','WT-40°C'},[],x);
hold off;
h_fig=gca;

end





