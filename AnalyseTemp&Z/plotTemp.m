function [  ] = plotTemp( filename )
load([filename,'_data.mat']);
n=length(data.realTime);
L=1;
hold on;
axes1 = axes('Parent',figure,...
    'YTick',[25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55],...
    'YGrid','on',...
    'XTick',[0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240],...
    'XGrid','on');
hold(axes1,'all');
plot(data.diffTime(1:n,1)./60,data.stageTempAlarm(1:n,1),'r-','LineWidth',L);
plot(data.diffTime(1:n,1)./60,data.stageTempCurrent(1:n,1),'b-','LineWidth',L);
plot(data.diffTime(1:n,1)./60,data.objectiveTempCurrent(1:n,1),'g-','LineWidth',L);
plot(data.diffTime(1:n,1)./60,data.stageTemp(1:n,1),'k-');
%plot(data.diffTime(1:end-1,1),data.objectiveTempAlarm(1:end-1,1),'m-');
%plot(data.diffTime(1:n,1),data.objectiveTemp(1:n,1),'b-');
%legend('Stage Alarm','Stage Current','Stage','Obj Alarm','Obj Current','Obj')
% Create axes
%legend('Stage Alarm','Stage Current','Stage','Obj Current','Obj','z');
title(['Temperature response (',num2str(data.stageT(1,1)),'°C to ',num2str(data.stageT(end-1,1)),'°C by ',num2str(data.stageT(2,1)-data.stageT(1,1)),'°C)']);
xlabel('Time (min)');
ylabel('Temperature (°C)');


%filename='/Volumes/charvin/common/movies/Camille/2012/201211/121129_calibTempAxiovert50uL_woObjective/';
filename='/Volumes/charvin/common/movies/Camille/2012/201212/121205_calibTempObserver0uL/';
load([filename,'_data.mat']);
n=length(data.realTime);
plot(data.diffTime(1:n,1)./60,data.stageTempAlarm(1:n,1),'Color',[1 0.7 0],'LineWidth',L);

filename='/Volumes/charvin/common/movies/Camille/2012/201211/121129_calibTempObserver50uL/';
load([filename,'_data.mat']);
n=length(data.realTime);
plot(data.diffTime(1:n,1)./60,data.stageTempAlarm(1:n,1),'r','LineWidth',L);
%legend('Stage Alarm Obj in contact','Stage Current','Stage','Stage Alarm wo Obj');
legend('Sample 50µL/min','Stage','Objective','Set temperature','Sample wo/ pump');
xlim([0 160]);
hold off;







end

