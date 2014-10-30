%[concat,nNum,area,volume]=extract_values('','140314-control-CP03-1',[4],50, 162, 240,'all');

function []=figure_juha(concat,nNum,area,volume)

%Camille Paoletti - 04/2014
%figure Juha - foci apparition at generation 2

%[concat,nNum,area,volume]=extract_values('','140314-control-CP03-1',[4],50,
%162, 240,'all'); %start at frame 50 because  cells died at 50 (bad growth rate otherwise...)
%saved in MATLAB/manuscript/juha.mat (to load) !!!
%saved in MATLAB/manuscript/juha_2.mat (to load) !!! for a start at frame 1

display=0;

[h_growth,h_figure,cbar_axes,h_gr]=compareMeanFociNumberBatch(1, 162, 240,concat,nNum,area,volume,display);

fsize=12;

hFig = figure;
pos=get(hFig,'Position');
set(hFig, 'Position', [pos(1) pos(2) pos(3) pos(4)*2]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack({0.25 0.25 0.25 0.25});
end
p(1).pack({1},{48,48,4});
p(2).pack({1},{48,48,4});
p(3).pack({1},{48,48,4});
p(4).pack({1},{48,48,4});

%p.de.margin = 10;%marge tout autour
p.margin = [20 15 7 10];%marginleft, marginbottom, marginright, margintop
% set some font properties
p.fontsize = fsize ;

%margin
p=set_margin(1,5,p);

p(1,1,1).select(h_gr);
title('');
xlabel('');
ylim([0 7e-3]);
set(gca,'XTickLabel',{});

% p(1,1,2).select(....);
% title('');

%margin
p=set_margin(2,5,p);

p(2,1,1).select(h_figure(1));
title('');
xlabel('');
set(gca,'XTickLabel',{});

% p(2,1,2).select(....);
% title('');

%margin
p=set_margin(3,5,p);

p(3,1,1).select(h_figure(4));
title('');
xlabel('');
set(gca,'XTickLabel',{});

% p(3,1,2).select(....);
% title('');

% p(3,1,3).select(cbar_axes);
% h=cbar_axes;
% set(h,'YTickLabel',{'0', '20','40','60','80','100'});
% ylabel(h,'Fraction of events (%)');
% set(cbar_axes,'Position',[pos(1)+pos(3)+0.03 pos(2) 0.02 pos(4)]);

%margin
p=set_margin(4,5,p);

p(4,1,1).select(h_figure(3));
title('');


end


function p=set_margin(a,b,p)
p(a,1,1).marginright = b;
p(a,1,2).marginleft = b;
p(a,1,2).marginright = b;
p(a,1,2).marginleft = b;
p(a).marginbottom = b;
p(a).margintop = b;
end