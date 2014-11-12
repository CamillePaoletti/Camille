%figure 1;
%Camille - 11/2013

%time serie
%/Volumes/charvin/common/movies/Camille/2013/131029_HS_CDC10-HSP104CP03 - position 3
%phy_plotMontageFoci([1 42 44 46 60 85],[1 1 [1 1 1] [1500 5000]; 3 2 [1 1 1] [500 1200]],[220 45 440 440],1,3,1);
phy_plotMontageFoci([1 42 44 46 60 85],[1 1 [1 1 1] [1500 5000]; 3 2 [1 1 1] [500 1200]; 2 4 [1 1 1] [680 800]],[250 45 360 440],1,3,1);


%evolution number of foci
%open phyloCell and load the project 131029
[Data,concat]=compareMeanFociNumberBatch('','131029_HS_CDC10-HSP104',[2:5],1, 42, 119,'hsCells');


%evolution of temperature
%global timeLapse
load('/Users/camillepaoletti/Documents/Lab-WorkInProgress/131029_HS_CDC10-HSP104CP03/131029_HS_CDC10-HSP104-MonitorLog.mat');
temp=[monitorSpy.list(1,1:end-1).currentTemperature1];
inter=double(timeLapse.interval/60);
timing=[1:1:timeLapse.numberOfFrames-1];
timing=double(timing);
timing=timing.*inter./60;
h=figure;
    pos=get(h,'Position');
    pos(4)=round(pos(4)/4);
    set(h,'Position',pos);
plot(timing,temp,'r-','LineWidth',1);
ylabel('Stage temperature (°C)','FontSize',14);
xlabel('Time (hours)','FontSize',14);
set(gca,'FontSize',14);


