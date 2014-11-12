function [h,yLevel]=tabtraj(tab)
%tab=matrix, each line corresponds to cell with successive values of cell
%cycle duration in min
ytick=[];
yLevel=[70,200];
h=figure;
%col2=colormap(cool(256));
map=zeros(256,3);
% map(1,:)=[0,1,0];
% map(256,:)=[1,0,0];
R0to256=linspace(0,1,256);
G0to256=1-R0to256;
map(:,1)=R0to256;
map(:,2)=G0to256;
col2=colormap(map);

for i=1:size(tab,1)
    tabtemp1(i,:)=[length(tab(i,:))-sum(isnan(tab(i,:))) tab(i,:)];
end
%  tabtemp2=tabtemp1';
%  [values,order]=sort(tabtemp2(:,1));
%  tabsort=tabtemp2(order);
%  tabsort=tabsort'

[~,order]=sort(tabtemp1(:,1));
tabsort=tabtemp1(order,:);

for i=1:size(tabsort,1)
    startY=i;
    %ytick=[ytick startY];
    
    cindex=ones(1,length(tabsort(i,:))-2-sum(isnan(tabsort(i,:))));
    %    for j=2:(length(tabsort(i,:))-sum(isnan(tabsort(i,:))))
    %        t=uint8(round(255*(tabsort(i,j))/300));
    %        cindex(j)=max(1,t);
    %    end
    to=uint8(round(255*(tabsort(i,2))/300));%first renormalize value of the cell cycle to plot right color
    cindex(1)=max(1,to);
    for j=2:(length(tabsort(i,:))-1-sum(isnan(tabsort(i,:))))
        tabsort(i,j+1)=tabsort(i,j)+tabsort(i,j+1);
        t=uint8(round(255*(tabsort(i,j+1)-tabsort(i,j)-yLevel(1))/(yLevel(2)-yLevel(1))));%renormalize value of the cell cycle to plot right color
        cindex(j)=max(1,t);
    end
    
    temp1=tabsort(i,:);
    T=numel(temp1)-sum(isnan(temp1));
    T2=temp1(2:T);
    temp2=[0 T2];
    T1=temp2(1:T-1);
    rec=[T1' T2'];
    
    Traj(rec,'Color',col2,'colorindex',cindex,'tag',['Cell ' ],h,'width',0.95,'startX',0,'startY',startY,'sepColor',[0.1 0.1 0.1],'sepwidth',10,'gradientwidth',1);
    %hold on
end
set(gca,'YTick',ytick);

axis tight;
%Traj(tab,'Color',col2,'colorindex',cindex)%,'tag',['Cell ' ],h,'width',5,'startX',0,'startY',startY-5,'sepColor',[0.1 0.1 0.1],'sepwidth',0,'gradientwidth',0);