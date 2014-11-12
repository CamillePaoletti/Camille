function figure4_exportPlotSeries(filename,hfig,hc)

myfigure = figure;
pos=get(myfigure,'Position');
set(myfigure, 'Position', [pos(1) pos(2) 450*2.5 283]);
use_panel = 1;
clf

fsize=12;

% PREPARE
if use_panel
	p = panel();
    %p.pack('v',{1/4 1/4 1/4 1/4});%vertical packing
    p.pack('v',{1/2 1/2});
end

% p(1).pack('v',{1},{40 40 20});%horizontal packing
% p(2).pack('v',{1},{40 20 40});
% p(3).pack('v',{1},{40 40 20});
% p(4).pack('v',{1},{40 20 20 20});

p.margin = [25 15 10 10];%marginleft, marginbottom, marginright, margintop
marg=1;
p.fontsize = fsize ;
% p.select('all');
% p.identify();
% return

% PLOT into each panel in turn

%LIGNE 1: grande VS petite
%p=set_margin(1,marg,p,3);

%A
% p(1,1,1).pack('v',{60 20 20});
% p=set_little_margin(1,2,1,p);
% p(1,1,1,1).select(hf);
% p(1,1,1,2).select(hfig(1));
% p(1,1,1,3).select(hfig(2));



% p.select('all');
% p.identify();
% return

%p=set_margin0(1,1,p);
%p=set_margin0(2,1,p);

p(1).pack('h', {90 10});

p(1,1).select(hfig(1));
pos_bar=get(gca,'Position')

p(1,2).select=(hc);

% h=hc;
% get(h,'YTick')
% get(h,'YTickLabel')
% %caxis([log10(0.5) log10(100)]);
% %sca=[0.5 1 2 5 10 20 50 100];
% %scal=log10(sca);
% %scal=[scal 1.97];
% %set(gca,'YTick',scal);
% %set(h,'YTickLabel',{'0.5' '1' '2','5', '10','20','50','100'});
% ylabel(h,'Cell cycle \n duration');
% set(hc(1),'Position',[pos_bar(1)+pos_bar(3)+0.01 pos_bar(2)-0.012 0.02 pos_bar(4)*1.02]);

%p(2).select(hfig(2));




set(myfigure,'HandleVisibility','off');
close all;
set(myfigure,'HandleVisibility','on');

myExportFig('Figure4_A.pdf','-pdf','-transparent');
%set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 16 2.4]);
print(gcf,filename,'-dpng', '-r300')

end

function p=set_margin0(a,b,p)
p(a).marginbottom = b;
p(a).margintop = b;
p(a).marginleft = b;
p(a).marginright = b;
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
p(a,1,c,1).marginright = b;
p(a,1,c,1).marginleft = b;
p(a,1,c,1).margintop = b;
p(a,1,c,1).marginbottom = b;
p(a,1,c,2).marginright = b;
p(a,1,c,2).marginleft = b;
p(a,1,c,2).margintop = b;
p(a,1,c,2).marginbottom = b;
p(a,1,c,3).marginright = b;
p(a,1,c,3).marginleft = b;
p(a,1,c,3).margintop = b;
p(a,1,c,3).marginbottom = b;
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


