function [NbPerCell,meanArea,meanRadius]=plotFociMeanNbMeanRadius()
%Camille Paoletti - 05/2013
%plot mean nb of foci per cell and mean radius of foci among time


pixel=0.08;

global segmentation;
global timeLapse;

n=timeLapse.numberOfFrames;
dt=timeLapse.interval;
meanArea=zeros(n,1);
meanRadius=zeros(n,1);
NbPerCell=zeros(n,1);

for i=1:n
    pix=find([segmentation.cells1(i,:).n]);
    NbCell=length(pix);
    %Area=[segmentation.cells1(i,pix).area];
    %Radius=sqrt(Area./pi);
    %meanArea(i,1)=mean(Area);
    %meanRadius(i,1)=mean(Radius);
    pix=find([segmentation.foci(i,:).n]);
    NbFoci=length(pix);
    NbPerCell(i,1)=NbFoci/NbCell;
    if pix
        Area=[segmentation.foci(i,pix).area];
    else
        Area=0;
    end
    Radius=sqrt(Area./pi);
    meanArea(i,1)=mean(Area);
    meanRadius(i,1)=mean(Radius);
end


meanArea=meanArea*pixel*pixel;
meanRadius=meanRadius*pixel;
timePoints=[0:1:n-1].*dt/60;

figure;
hold on;
plot(timePoints,NbPerCell,'r-','LineWidth',2); 
title('Overview of the kinetics of aggregation upon heat shock','Fontsize',12);
xlabel('Time (min)','Fontsize',12);
ylabel('Number of foci per cell','Fontsize',12);
ax1 = gca;
set(ax1,'YColor','r');
xlim(ax1,[125 320]);
ax2 = axes('Position',get(ax1,'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'YColor','b');
%xlim(ax2,xlim(ax1));
xlim(ax2,[125 320]);
line(timePoints(62:1:end),meanRadius(62:1:end),'Color','b','LineWidth',2,'Parent',ax2);
ylabel('Mean Radius (µm)','Fontsize',12);
hold off;


figure;
hold on;
plot(timePoints,NbPerCell,'r-','LineWidth',2); 
title('Overview of the kinetics of aggregation upon heat shock','Fontsize',12);
xlabel('Time (min)','Fontsize',12);
ylabel('Number of foci per cell','Fontsize',12);
ax1 = gca;
set(ax1,'YColor','r');
ax2 = axes('Position',get(ax1,'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'YColor','b');
xlim(ax2,xlim(ax1));
line(timePoints(62:1:end),meanArea(62:1:end),'Color','b','LineWidth',2,'Parent',ax2);
ylabel('Mean Area Of Foci (µm^)','Fontsize',12);
hold off;


end