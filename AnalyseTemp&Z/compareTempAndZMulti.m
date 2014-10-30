function [out,sp,moyenne] = compareTempAndZMulti
%Camille - 09/2013
%description !!
%[out,sp,moyenne] = computeTempAndZMulti(filepath,filename);




feature={'time','sampleTemp','stageTemp','stageSetTemp','objectiveTemp','objectiveSetTemp','z','zCorr'};
Colors={'r-','b-','g-','k-','c-'};
Colors2={'r+','b+','g+','k+','c+','m+'};
time=[0:0.1:19];%[0:0.1:540];%

filepath='/Volumes/charvin/common/movies/Camille/2013/130523_calibrationObserver/record';
filename='_DFandTemp';

for i=1:6
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


filepath='/Volumes/charvin/common/movies/Camille/2013/130913_calibrationZdriftObserver/';
filename='shock100X';
load([filepath,filename,'_data.mat']);
n=length(data.realTime);
%Time
out2.time{1,1}=data.diffTime(1:n,1)./60;
%Sample Temp
out2.sampleTemp{1,1}=data.stageTempAlarm(1:n,1);
%Stage Temp
out2.stageTemp{1,1}=data.stageTempCurrent(1:n,1);
%Stage Set Temp
out2.stageSetTemp{1,1}=data.stageTemp(1:n,1);
%Objective Temp
out2.objectiveTemp{1,1}=data.objectiveTempCurrent(1:n,1);
%Objective Set Temp
out2.objectiveSetTemp{1,1}=data.objectiveTemp(1:n,1);
%Z coordinate
out2.z{1,1}=data.z(1:n,1);
%Corrected Z coordinate
out2.zCorr{1,1}=data.z(1:n,1)-data.z(1,1)+38;


N=6
Nkeep=[2:6]
for i=2:N;
    for j=2:8
        [sp.(feature{j})(:,i)]=feval(@spline,out.time{1,i},out.(feature{j}){1,i},time);
    end
end

for j=2:8
   moyenne.(feature{j})=mean(sp.(feature{j})(:,Nkeep),2);
end


figure;
hold on;
for i=Nkeep
    k=1;
    for j=[2,3,5,4]
    %figure;hold on;
    plot(out.time{1,i},out.(feature{j}){1,i},Colors{k});
    k=k+1;
    legend('Sample temp','Stage temp','Objective temp','Set temp');
    plot(out2.time{1,1},out2.(feature{j}){1,1},Colors{k});
    %hold off;
    end
end

title('Response to change in temperature');
xlim([0 20]);
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
       for i=1:N
           line(out.time{1,i},out.z{1,i}-out.z{1,i}(1,1),'Color',[1 0.5 0],'Parent',ax2);
           line(out2.time{1,1},out2.z{1,1}-out2.z{1,1}(1,1),'Color',[1 0.8 0],'Parent',ax2);
           ylabel('z (µm)');
       end
xlim([0 20]);

hold off;




% figure;
% hold on;
% for i=Nkeep
% plot(out.stageTemp{1,i},out.z{1,i}-out.z{1,i}(1,1),Colors2{i});
% % plot(data.objectiveTempCurrent(1:n,1),data.z(1:n,1)-data.z(1,1),'r+');
% end
% hold off;
% %
%  n1=15%38
%  n2=30%150
% 
% %[A,B,a,b]=linearRegression(data.stageTempCurrent(n1:n2,1),data.z(n1:n2,1)-data.z(1,1),ones(n2-n1+1,1),'r+','r-',1);
% [A,B,a,b]=linearRegression(moyenne.stageTemp(n1:n2,1),moyenne.z(n1:n2,1)-moyenne.z(1,1),ones(n2-n1+1,1),'r+','r-',1);


end
