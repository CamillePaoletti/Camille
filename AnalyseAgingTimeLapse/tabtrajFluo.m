function [h,yLevel]=tabtrajFluo(tab)
%tab=matrix, each line corresponds to a cell with successive values of cell
%cycle duration in min
ytick=[];
yLevel(1)=0;
yLevel(2)=max(tab);
h=figure;
map=zeros(256,3);
% map(1,:)=[0,1,0];
% map(256,:)=[1,0,0];
% R0to256=linspace(0,1,256);
% G0to256=1-R0to256;
% map(:,1)=R0to256;
% map(:,2)=G0to256;
% col2=colormap(map);
cc2=1;

col2=colormap(gray(256));
%col(257,:)=[0.3 0.3 0.3];


 for i=1:size(tab,1)
        tabtemp1(i,:)=[length(tab(i,:))-sum(isnan(tab(i,:))) tab(i,:)];
 end
%  tabtemp2=tabtemp1';
%  [values,order]=sort(tabtemp2(:,1));
%  tabsort=tabtemp2(order);
%  tabsort=tabsort'

%tabtemp1=tabtemp1(1:30)
[values,order]=sort(tabtemp1(:,1));
tabsort=tabtemp1(order,:);%nombre d'éléments dans les différentes lignes de tab

for i=1:size(tabsort,1)
        startY=i;
        ytick=[ytick startY];
       
        cindex=ones(1,length(tabsort(i,:))-1-sum(isnan(tabsort(i,:))));
        T=numel(cindex);
        R=ones(T,1);
       for j=1:(length(tabsort(i,:))-2-sum(isnan(tabsort(i,:))))
         t=uint8(round((255*(tabsort(i,j+1))-yLevel(1))/(yLevel(2)-yLevel(1))));
         cindex(j)=max(1,t);
         R(j+1)=R(j)+R(j+1);  
       end
    %tf=uint8(round(255*(tabsort(i,length(tabsort(i,:))-sum(isnan(tabsort(i,:))))/250)));
    %cindex(length(tabsort(i,:))-1-sum(isnan(tabsort(i,:))))= max(1,tf) ; 
    temp2=[0;R];
    R1=temp2(1:(size(R)));
    rec=[R1 R];

 
    %Traj(rec,'Color',col2,'colorindex',cindex,'tag',['Cell ' ],h,'width',0.95,'startX',0,'startY',startY,'sepColor',[0.1 0.1 0.1],'sepwidth',0.07,'gradientwidth',0);
    Traj(rec,'Color',col2,'colorindex',cindex,'tag',['Cell ' ],h,'width',0.95,'startX',0,'startY',startY,'sepColor',[0.1 0.1 0.1],'sepwidth',0,'gradientwidth',0);
end
   set(gca,'YTick',ytick);
   if ytick==1
       set(gca,'YTickLabel','');
   end
   
    
    axis tight;