function plotRepresentativeImages(low,high,im)
%Camille Paoletti - 05/2014
%plot selected images with the same level within the same figure
hours=[0,2,3,4];
CDT={'30°C-cst','30°C-4°C-cst','30°C-4°C-30°C'};
X=[186,299,187;293,219,192;296,144,170;349,231,181];
Y=[179,236,332;195,271,265;349,239,262;190,184,180];
fsize=12;

hFig = figure;
pos=get(hFig,'Position');
set(hFig, 'Position', [pos(1) pos(2) pos(3)*1.9 pos(4)*2.5]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack({1/3 1/3 1/3});
end
p(1).pack({1},{1/4 1/4 1/4 1/4});
p(2).pack({1},{1/4 1/4 1/4 1/4});
p(3).pack({1},{1/4 1/4 1/4 1/4});

%p.de.margin = 10;%marge tout autour
%p.marginbottom = 20;
%p.margin
% p(2).marginright = 50;
p.margin = [1 1 1 7];%marginleft, marginbottom, marginright, margintop
% p(2).marginleft = 50;
%p.select('all');
% set some font properties
marg=1;
p.fontsize = fsize ;


for j=1:3
    p=set_margin(j,marg,p);
    for i=1:4
        p(j,1,i).select();
        im_temp=imcrop(im(:,:,j,i),[X(i,j)-150,Y(i,j)-150,300,300]);
        imshow(im_temp,[low,high]);
        pos_temp=get(gca,'Position');
        rectangle('Position',[pos_temp(1)+5,pos_temp(1)+5,39,5],'FaceColor','w');
        title(['t=',num2str(hours(i)),'h - T=',CDT{j}]);
    end
end

end

function p=set_margin(a,b,p)
p(a,1,1).marginright = b;
p(a,1,1).marginleft = b;
p(a,1,2).marginright = b;
p(a,1,2).marginleft = b;
p(a,1,3).marginright = b;
p(a,1,3).marginleft = b;
p(a,1,4).marginright = b;
p(a,1,4).marginleft = b;
p(a).marginbottom = b;
p(a).margintop = b;
end