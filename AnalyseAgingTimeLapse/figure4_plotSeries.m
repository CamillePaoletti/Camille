function [hfig,hc]=figure4_plotSeries(div,tim,fluo,filename)
fsize=18;


[h,yLevel]=tabtraj(div);
pos=get(h,'Position');
set(h, 'Position', [pos(1) pos(2) pos(3) pos(4)/5]);
% X=[0:5:length(div)];
% for i=1:length(X)
%     XL{1,i}=num2str(X(i));
% end
% set(gca,'XTick',X);
% set(gca,'XTickLabel',XL);
% xlabel('Generation');
X=[0:6*5:length(tim)];
for i=1:length(X)
    XL{1,i}=num2str(X(i)/6);
end
% X=X*10;
% set(gca,'XTick',X);
% set(gca,'XTickLabel',XL);
% xlabel('Time (hours)');
xlabel('');
set(gca,'XTickLabel',{});
hc(1)=colorbar;
lev=get(hc(1),'YTick');
levLab={strcat('<',num2str(yLevel(1))),num2str(mean(yLevel)),strcat('>',num2str(yLevel(2)))};
set(hc(1),'YTickLabel',levLab,'FontSize',fsize);

hfig(1)=gca;
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 14 1.2]);
print(gcf,strcat(filename,'-2.png'),'-dpng', '-r300')

%3)
[h,yLevel]=tabtrajFluo(fluo);
pos=get(h,'Position');
set(h, 'Position', [pos(1) pos(2) pos(3) pos(4)/5]);
X=[0:6*5:length(tim)];
for i=1:length(X)
    XL{1,i}=num2str(X(i)/6);
end
set(gca,'XTick',X);
set(gca,'XTickLabel',XL,'FontSize',fsize);
xlabel('Time (hours)','FontSize',fsize);
hc(2)=colorbar;
lev=get(hc(2),'YTick');
levLab={strcat('<',num2str(round(yLevel(1)))),num2str(round(mean(yLevel))),strcat('>',num2str(round(yLevel(2))))};
set(hc(2),'YTickLabel',levLab,'FontSize',fsize);

hfig(2)=gca;
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 14 1.5]);
print(gcf,strcat(filename,'-3.png'),'-dpng', '-r300')

end