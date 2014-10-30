function [out,sp,moyenne] = computeTempAndZMulti(filepath,filename,N,Nkeep)
%Camille - 05/2013
%description !!
%[out,sp,moyenne] = computeTempAndZMulti(filepath,filename,6,[2:6]);

%filepath='/Volumes/charvin/common/movies/Camille/2013/130523_calibrationObserver/record';
%filename='_DFandTemp';

%filepath='/Volumes/charvin/common/movies/Camille/2013/130913_calibrationZdriftObserver/';
%filename='shock100X';

%filepath='/Volumes/charvin/common/movies/Camille/2013/130913_calibrationZdriftObserver/shock63X_';
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

% s=zeros(1,N);
% for i=1:N;
%     s(1,i)=size(out.time{1,i},1);
% end;
% 
%minTime=min(s);

for i=1:N;
    for j=2:8
        [sp.(feature{j})(:,i)]=feval(@spline,out.time{1,i},out.(feature{j}){1,i},time);
    end
end

for j=2:8
   moyenne.(feature{j})=mean(sp.(feature{j})(:,Nkeep),2);
end

figure;
hold on;
k=1;
for j=[2,3,5,4]
    plot(time,moyenne.(feature{j}),Colors{k});
    k=k+1;
end
legend('Sample temp','Stage temp','Objective temp','Set temp');
title('Response to change in temperature');
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


figure;
hold on;
for i=Nkeep%1:N
    k=1;
    for j=[2,3,5,4]
    %figure;hold on;
    plot(out.time{1,i},out.(feature{j}){1,i},Colors{k});
    k=k+1;
    legend('Sample temp','Stage temp','Objective temp','Set temp');
    %hold off;
    end
end
title('Response to change in temperature');
xlim([0 15]);%20]);
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
for i=Nkeep%1:N
    line(out.time{1,i},out.z{1,i}-out.z{1,i}(1,1),'Color',[1 0.5 0],'Parent',ax2);
    ylabel('z (µm)');
end
xlim([0 15]);%20]);
hold off;

figure;
hold on;
for i=Nkeep
plot(out.stageTemp{1,i},out.z{1,i}-out.z{1,i}(1,1),Colors2{i});
% plot(data.objectiveTempCurrent(1:n,1),data.z(1:n,1)-data.z(1,1),'r+');
end
hold off;
%
 n1=15%38
 n2=30%150

%[A,B,a,b]=linearRegression(data.stageTempCurrent(n1:n2,1),data.z(n1:n2,1)-data.z(1,1),ones(n2-n1+1,1),'r+','r-',1);
[A,B,a,b]=linearRegression(moyenne.stageTemp(n1:n2,1),moyenne.z(n1:n2,1)-moyenne.z(1,1),ones(n2-n1+1,1),'r+','r-',1);


end
