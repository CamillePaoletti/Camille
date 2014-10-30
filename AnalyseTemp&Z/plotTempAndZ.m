function [  ] = plotTempAndZ( filename )
%filename='/Users/camillepaoletti/Documents/Lab/Movies/121213_tempStepObserver50uL_30to35/';

load([filename,'_data.mat']);
n=length(data.realTime);

figure;
hold on;
plot(data.diffTime(1:n,1)./60,data.stageTempAlarm(1:n,1),'k-');
plot(data.diffTime(1:n,1)./60,data.stageTempCurrent(1:n,1),'b-');
%plot(data.diffTime(1:n,1),data.stageTemp(1:n,1),'k-');
%plot(data.diffTime(1:end-1,1),data.objectiveTempAlarm(1:end-1,1),'m-');
plot(data.diffTime(1:n,1)./60,data.objectiveTempCurrent(1:n,1),'c-');
plot(data.diffTime(1:n,1)./60,data.objectiveTemp(1:n,1),'g-');
%plotyy(data.diffTime(1:n,1),data.objectiveTemp(1:n,1),data.diffTime(1:n,1),data.z(1:n,1))
ax1 = gca;
set(ax1,'YColor','k')
%legend('Stage Alarm','Stage Current','Stage','Obj Current','Obj');
legend('Glass slide temp','Stage temp','Objective temp','Set temp');
legend1 = legend(ax1,'show');
set(legend1,'Location','West');

xlabel('Time (min)');
ylabel('Temperature (°C)');
       

ax2 = axes('Position',get(ax1,'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'YColor','r');
line(data.diffTime(1:n,1)./60,data.z(1:n,1),'Color','r','Parent',ax2);
%legend('z');
ylabel('z (µm)');
% 'XAxisLocation','top',...

title(['response to change in temperature']);

hold off;

figure;
plot(data.stageTempCurrent(1:n,1),data.z(1:n,1));


end

