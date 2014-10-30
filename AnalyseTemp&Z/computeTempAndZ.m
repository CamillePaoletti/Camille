function [  ] = computeTempAndZ(filename)

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

plot(data.diffTime(1:n,1)./60,data.z(1:n,1)-data.z(1,1)+38,'r-');
title(['response to change in temperature']);
legend('Glass slide temp','Stage temp','Objective temp','Set temp','z');

hold off;

figure;
plot(data.stageTempCurrent(1:n,1),data.z(1:n,1)-data.z(1,1),'b+');
hold on;
plot(data.objectiveTempCurrent(1:n,1),data.z(1:n,1)-data.z(1,1),'r+');
hold off;

n1=38
n2=150

%[A,B,a,b]=linearRegression(data.stageTempCurrent(n1:n2,1),data.z(n1:n2,1)-data.z(1,1),ones(n2-n1+1,1),'r+','r-',1);


end
