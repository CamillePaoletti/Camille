function hexport=figure4_DG(n,xmax,ymin,ymax,filename,hfig,strleg,offset)
%Camille Paoletti - 11/2014
%figure papier n°4 D et G

WID=800;
HEI=430;

    
h = figure;
pos=get(h,'Position');
set(h, 'Position', [pos(1) pos(2) WID HEI]);
use_panel = 1;
clf

fsize=14;

% PREPARE
if use_panel
	p = panel();
    p.pack('v',{1/5 1/5 1/5 1/5 1/5});
end

p.margin = [17 15 5 10];%marginleft, marginbottom, marginright, margintop
marg=1;
p.fontsize = fsize ;
% p.select('all');
% p.identify();
% return
for i=1:n
    p(i).select(hfig(i));
    if i<n
        xlabel('');
        set(gca,'XTickLabel',{});
        p(i).marginbottom=1;
    end
    if i>1
        p(i).margintop=1;
    end
    xlim([0 xmax]);
    ylim([ymin ymax]);
    tick=get(gca,'YTick');
    if length(tick)>2
        set(gca,'Ytick',tick(1:2:end));
    end
end

pos=get(h,'Position');
text(offset,600,strleg,'Rotation',90,'FontSize',fsize);%,'HorizontalAlignment','center'

% set(myfigure,'HandleVisibility','off');
% close all;
% set(myfigure,'HandleVisibility','on');

myExportFig(filename,'-pdf','-transparent');

hexport=get(h,'CurrentAxes');


end

