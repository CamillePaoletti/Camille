function []=figure_recap_HS()

%Camille Paoletti - 04/2014
%figure 2

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT.mat');
[h_figure1]=plotRatioBudMother(meanLen,Data);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-all.mat');
[c,h_fig1,area1,rat1]=alpha(Data,0.012,1);
[h_fig1(2)]=plotCorr(Data);

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-bni1.mat');
[h_figure2]=plotRatioBudMother(meanLen,Data);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-bni1-all.mat');
[c,h_fig2,area2,rat2]=alpha(Data,0.024,1);
[h_fig2(2)]=plotCorr(Data);

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-35.mat');
[h_figure3]=plotRatioBudMother(meanLen,Data);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-35-all.mat');
%[c,h_fig3,area3,rat3]=alpha(Data,0.007,1);
[c,h_fig3,area3,rat3]=alpha(Data,0.08,1);
[h_fig3(2)]=plotCorr(Data);

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-40.mat');
[h_figure4]=plotRatioBudMother(meanLen,Data);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-WT-40-all.mat');
[c,h_fig4,area4,rat4]=alpha(Data,0.015,1);
[h_fig4(2)]=plotCorr(Data);

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-hsp42.mat');
[h_figure5]=plotRatioBudMother(meanLen,Data);
load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-2-hsp42-all.mat');
[c,h_fig5,area5,rat5]=alpha(Data,0.008,1);
[h_fig5(2)]=plotCorr(Data);

fsize=12;

hFig = figure;
pos=get(hFig,'Position');
set(hFig, 'Position', [pos(1) pos(2) pos(3)*2 pos(4)*2]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack({30 25 30 15});
end
p(1).pack({1},{1/5 1/5 1/5 1/5 1/5});
p(2).pack({1},{1/5 1/5 1/5 1/5 1/5});
p(3).pack({1},{1/5 1/5 1/5 1/5 1/5});
p(4).pack({1},{1/5 1/5 1/5 1/5 1/5});

%p.de.margin = 10;%marge tout autour
%p.marginbottom = 20;
%p.margin
% p(2).marginright = 50;
p.margin = [15 15 10 10];%marginleft, marginbottom, marginright, margintop
% p(2).marginleft = 50;
%p.select('all');
% set some font properties
marg=10;
p.fontsize = fsize ;


%% (b)

% plot into each panel in turn
p=set_margin(1,marg,p);
p(1,1,1).select(h_figure1(1));
title('WT - 38°C');
ylim([-0.1 9]);
ylabel('Ratio of concentration in foci in B/M');

p(1,1,2).select(h_figure2(1));
title('bni1? - 38°C');
ylim([-0.1 9]);

p(1,1,3).select(h_figure3(1));
title('WT - 35°C');
ylim([-0.1 9]);

p(1,1,4).select(h_figure4(1));
title('WT - 40°C');
ylim([-0.1 9]);

p(1,1,5).select(h_figure5(1));
title('hsp42? - 38°C');
ylim([-0.1 9]);


%margin
ymax=85;
p=set_margin(2,marg,p);
p(2,1,1).pack({1},{1/3 1/3 1/3});
p=set_little_margin(2,1,1,p);
p(2,1,1,1,1).select(h_figure1(2));
ylim([0 ymax]);
title('');
p(2,1,1,1,2).select(h_figure1(3));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');
p(2,1,1,1,3).select(h_figure1(4));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');

p(2,1,2).pack({1},{1/3 1/3 1/3});
p=set_little_margin(2,1,2,p);
p(2,1,2,1,1).select(h_figure2(2));
ylim([0 ymax]);
title('');
ylabel('');
p(2,1,2,1,2).select(h_figure2(3));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');
p(2,1,2,1,3).select(h_figure2(4));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');

p(2,1,3).pack({1},{1/3 1/3 1/3});
p=set_little_margin(2,1,3,p);
p(2,1,3,1,1).select(h_figure3(2));
ylim([0 ymax]);
title('');
ylabel('');
p(2,1,3,1,2).select(h_figure3(3));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');
p(2,1,3,1,3).select(h_figure3(4));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');

p(2,1,4).pack({1},{49.4 49.4 0.2});
p=set_little_margin(2,1,4,p);
p(2,1,4,1,1).select(h_figure4(2));
ylim([0 ymax]);
title('');
ylabel('');
p(2,1,4,1,2).select(h_figure4(3));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');

p(2,1,5).pack({1},{49.4 49.4 0.2});
p=set_little_margin(2,1,5,p);
p(2,1,5,1,1).select(h_figure5(2));
ylim([0 ymax]);
title('');
ylabel('');
p(2,1,5,1,2).select(h_figure5(3));
ylim([0 ymax]);
ylabel('');
set(gca,'YTickLabel',{});
title('');
% p(2,1,5,1,3).select(h_figure5(4));
% ylim([0 ymax]);
% ylabel('');
% set(gca,'YTickLabel',{});
% title('');

p=set_margin(1,marg,p);
p(3,1,1).select(h_fig1(1));
ylabel('Experimental ratio');
xlabel('Theoritical ratio');
% ylim([1e-4,100]);
% xlim([1e-4,100]);
p(3,1,2).select(h_fig2(1));
xlabel('Theoritical ratio');
% ylim([1e-4,100]);
% xlim([1e-4,100]);

p(3,1,3).select(h_fig3(1));
xlabel('Theoritical ratio');

p(3,1,4).select(h_fig4(1));
xlabel('Theoritical ratio');

p(3,1,5).select(h_fig5(1));
xlabel('Theoritical ratio');


p=set_margin(1,marg,p);
p(4,1,1).select(h_fig1(2));
ylabel('Residuals');
xlabel('alpha (frame^{-1})');
p(4,1,2).select(h_fig2(2));
xlabel('alpha (frame^{-1})');
p(4,1,3).select(h_fig3(2));
xlabel('alpha (frame^{-1})');
p(4,1,4).select(h_fig4(2));
xlabel('alpha (frame^{-1})');
p(4,1,5).select(h_fig5(2));
xlabel('alpha (frame^{-1})');




end

function p=set_margin(a,b,p)
p(a,1,1).marginright = b;
p(a,1,1).marginleft = b;
p(a,1,2).marginright = b;
p(a,1,2).marginleft = b;
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


function h_fig=plotCorr(Data)

j=0;
x=[0:0.0001:0.05];
for i=x;
    j=j+1;
    [cor(j),~,~,~,~,s(j)]=alpha(Data,i,0);
end

figure;plot(x,cor);
%figure;plot(x(1:j),s(1:j));
%xlim([0 0.05]);
s=s/max(s);
figure;plot(x(1:j),cor(1:j)./s(1:j));
h_fig=gca;

end




