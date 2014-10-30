function []=supp_figure1()

%Camille Paoletti - 04/2014
%supp_figure1 - temperature calibration

%figures loading

uiopen('/Users/camillepaoletti/Documents/Lab/Figures/calibrationTemp&Z_Observer100X/heatingComparison.fig',1);
fig_comp=gca;

uiopen('/Users/camillepaoletti/Documents/Lab/Figures/calibrationTemp&Z_Observer100X/calibrationTemp.fig',1);
fig_calib=gca;

filepath='/Volumes/charvin/common/movies/Camille/2013/130523_calibrationObserver/record';
filename='_DFandTemp';

fsize=12;

hFig = figure;
% pos=get(hFig,'Position');
% set(hFig, 'Position', [pos(1) pos(2) pos(3) pos(4)*2]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack({50 50});
end
p(1).pack({1},{50 50});
p(2).pack({1},{50 50});

%p.de.margin = 10;%marge tout autour
p.margin = [20 15 15 15];%marginleft, marginbottom, marginright, margintop
% set some font properties
p.fontsize = fsize ;

marg=20;

%margin
p=set_margin(1,marg,p);

%p(1,1,1).select(h_gr); %%%%%%%% scheme - TO DO!!

p(1,1,2).select();
computeTempAndZMulti(filepath,filename,6,[2:6]);
title('');
set(gca,'XTickLabel','');

%margin
p=set_margin(2,marg,p);

p(2,1,2).select(fig_comp);
ylabel('Sample temperature (°C)');
title('');
h_legend=legend('Objective+Stage heating','Objective heating','Stage heating');
set(h_legend,'FontSize',6);

p(2,1,1).select(fig_calib);
title('');
h_legend=legend('Sample 50µL/min','Stage','Objective','Set temperature','Sample wo/ pump','Location','SouthEast');
set(h_legend,'FontSize',6);
ylim([29 46]);

y_str=get(gca,'YTickLabel');
y_str=y_str(2:2:end,:);
y_ticks=[30:2:46];
set(gca,'YTick',y_ticks);
set(gca,'YTickLabel',y_str);

x_str=get(gca,'XTickLabel');
x_str=x_str(1:2:end,:);
x_ticks=get(gca,'XTick');
x_ticks=x_ticks(1:2:end);
set(gca,'XTick',x_ticks);
set(gca,'XTickLabel',x_str);


end


function p=set_margin(a,b,p)
p(a,1,1).marginright = b;
p(a,1,2).marginleft = b;
p(a,1,2).marginright = b;
p(a,1,2).marginleft = b;
p(a).marginbottom = b;
p(a).margintop = b;
end





function [] = computeTempAndZMulti(filepath,filename,N,Nkeep)
%Camille - 05/2013
%description !!
%[] = computeTempAndZMulti(filepath,filename,6,[2:6]);

%filepath='/Volumes/charvin/common/movies/Camille/2013/130523_calibrationObserver/record';
%filename='_DFandTemp';

% !!!! ATTENTION XLIM A MODIFIER !!!!


feature={'time','sampleTemp','stageTemp','stageSetTemp','objectiveTemp','objectiveSetTemp','z','zCorr'};
Colors={'r-','b-','g-','k-','c-'};
Colors2={'r+','b+','g+','k+','c+','m+'};
time=[0:0.1:19];%[0:0.1:540];%

for i=1:N
    load([filepath,num2str(i),filename,'_data.mat']);
    %load([filepath,filename,'_data.mat']);
    n=length(data.realTime);
    %Time
    out.time{1,i}=data.diffTime(1:n,1)./60;
    %Sample Temp
    out.sampleTemp{1,i}=data.stageTempAlarm(1:n,1);
    %Stage Temp
    out.stageTemp{1,i}=data.stageTempCurrent(1:n,1);
    %Stage Set Temp
    out.stageSetTemp{1,i}=data.stageTemp(1:n,1);
    %Objective Temp
    out.objectiveTemp{1,i}=data.objectiveTempCurrent(1:n,1);
    %Objective Set Temp
    out.objectiveSetTemp{1,i}=data.objectiveTemp(1:n,1);
    %Z coordinate
    out.z{1,i}=data.z(1:n,1);
    %Corrected Z coordinate
    out.zCorr{1,i}=data.z(1:n,1)-data.z(1,1)+38;
end

for i=1:N;
    for j=2:8
        [sp.(feature{j})(:,i)]=feval(@spline,out.time{1,i},out.(feature{j}){1,i},time);
    end
end

for j=2:8
   moyenne.(feature{j})=mean(sp.(feature{j})(:,Nkeep),2);
end

hold on;
k=1;
for j=[2,3,5,4]
    plot(time,moyenne.(feature{j}),Colors{k});
    k=k+1;
end
h_legend=legend('Sample temp','Stage temp','Objective temp','Set temp');
set(h_legend,'FontSize',6);
ax1 = gca;
set(ax1,'YColor','k');
legend1 = legend(ax1,'show');
set(legend1,'Location','East');
xlabel('Time (min)');
ylabel('Temperature (°C)');

ax2 = axes('Position',get(ax1,'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'YColor',[1 0.5 0]);
line(time,moyenne.z-moyenne.z(1,1),'Color',[1 0.5 0],'Parent',ax2);
ylabel('z (µm)');
hold off;

end