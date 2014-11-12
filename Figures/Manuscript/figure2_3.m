% build figure 2 for camille's paper

function figure2_3()

myfigure=figure('Color','w','Position',[200 200 1200 800]); 

p = panel();
p.pack('h',{22 34 22 22});%horizontal packing
p.de.margin=20;
p.fontsize=20;
p.marginleft=20;
p.marginbottom=20;

load('fig-2-WT.mat'); % load data for ratios
load('fig-2-WT-volumeFrame42.mat'); % load data for cell size

[h_figure1,ratMean1]=plotRatioBudMother2(meanLen,Data,1,Volume);
eventsName={'HS','Division','Budding'};

%return;

% conc, ratio, aire

% original figure from Camille
p(1).pack('v',{1/4 1/3 []});

%p(1,1).select(); % plot sketch of temprature increase

p(1,2).pack('h',{1/2 1/2}); % plot fluo in agg at different time points
ymax=55;
p(1,2,1).select(h_figure1(2)); title(''); ylim([0 ymax]); ylabel('[Fluo.] (A.U.)');
title(eventsName{1});
p(1,2,1).marginright=1;
p(1,2,1).marginleft=0;

p(1,2,2).select(h_figure1(3)); title(''); ylim([0 ymax]); ylabel(''); set(gca,'YTickLabel',{});
title(eventsName{2}); 
p(1,2,2).marginright=1;
p(1,2,2).marginleft=0;

% p(1,2,3).select(h_figure1(4)); title(''); ylim([0 ymax]); ylabel(''); set(gca,'YTickLabel',{});
% title(eventsName{3});
% p(1,2,3).marginright=1;
% p(1,2,3).marginleft=0;

p(1,3).select(h_figure1(1)); % plot fluo in agg at different time points
title(''); ylim([-0.1 6]);
ylabel('Ratio [Fluo.B] / [Fluo.M]');
set(gca,'XTickLabel',eventsName);

% split of data according to data classes
p(2).pack('v',{12 44 44});
p(2).marginleft=25;
%p(2,1).select(h_figure1(5)) ; % plot fratio=f(Vb)
%xlabel(''); set(gca,'XTickLabel',{});
% see below ....

%load('fig-2-WT-all-1.mat');
load('fig-2-WT-all.mat');
[hout hout2]=agg_analysis(Data);

% Volume, n agg and conc agg in D
p(3).pack('v',{1/3 1/3 1/3});
p(3).marginleft=30;
p(3).marginbottom=25;
%p(3).marginleft=25;

figure(hout(1));
p(3,1).select(gca) ; % plot Area
xlabel(''); set(gca,'XTickLabel',{});
p(3,1).margintop=0;
p(3,1).marginbottom=1;

figure(hout(1)); close

figure(hout(3));
p(3,2).select(gca) ; % plot Number of agg
xlabel(''); set(gca,'XTickLabel',{});
p(3,2).margintop=0;
p(3,2).marginbottom=1;
figure(hout(3)); close

figure(hout(5));
p(3,3).select(gca) ; % plot Conc of agg
p(3,3).margintop=0;
p(3,3).marginbottom=1;
figure(hout(5)); close

% Volume, n agg and conc agg in M
p(4).pack('v',{1/3 1/3 1/3});
p(4).marginleft=35;
p(4).marginbottom=25;

figure(hout(2));
p(4,1).select(gca) ; % plot Area
xlabel(''); set(gca,'XTickLabel',{});
p(4,1).margintop=0;
p(4,1).marginbottom=1;
figure(hout(2)); close

figure(hout(4));
p(4,2).select(gca) ; % plot Number of agg
xlabel(''); set(gca,'XTickLabel',{});
p(4,2).margintop=0;
p(4,2).marginbottom=1;
figure(hout(4)); close

figure(hout(6));
p(4,3).select(gca) ; % plot Conc of agg
p(4,3).margintop=0;
p(4,3).marginbottom=1;
figure(hout(6)); close


% plot timings and stall arrest as a function classes
figure(hout(8));
p(2,2).select(gca) ; % plot fratio=f(Vb)
%figure; axes; plot(
p(2,2).margintop=0;
p(2,2).marginbottom=1;

new_handle = copyobj(hout2(3).hMain,gca);

for i=1:length(hout2(3).hErrorbar(:))
new_handle = copyobj(hout2(3).hErrorbar(i),gca);
end

xlabel(''); set(gca,'XTickLabel',{});
figure(hout(8)); close;

p(2,2).marginbottom=1;
p(2,3).pack({[0 0 1 1]}); % main plot (fills parent)
p(2,3).pack({[0.65 0.55 0.3 0.4]}); % inset plot (overlaid)
p(2,3).margintop=0;
p(2,3).marginbottom=1;


figure(hout(7));
p(2,3,1).select(gca) ; % plot timings=f(Vb)
new_handle = copyobj(hout2(1).hMain,gca);

for i=1:length(hout2(1).hErrorbar(:))
new_handle = copyobj(hout2(1).hErrorbar(i),gca);
end

figure(hout(7)); close;

%p(2,3).select() ; % plot stalltime=f(Vb)
%plot(0,0);
p(2,3,2).select() ;
new_handle = copyobj(hout2(2).hMain,gca);

for i=1:length(hout2(2).hErrorbar(:))
new_handle = copyobj(hout2(2).hErrorbar(i),gca);
end

%p(2,2,2).margintop=0;
%p(2,2,2).marginbottom=1;
f=20;
xlabel('Size B');
ylabel('Stall (min)','FontSize',f);
ylim([-10 75]);
xlim([0 2500]);
set(gca,'FontSize',f);
set(gca,'XTickLabel',{'0','1','2'});

set(myfigure,'HandleVisibility','off');
close all;
set(myfigure,'HandleVisibility','on');

myExportFig('Figure2.pdf')

