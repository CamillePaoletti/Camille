function [out] = compareTempAndZ()
%Camille - 05/2013
%comparison of sample heatings (w/ & wo/pump, w/ & wo/ stage heating, w/ & wo/ objective heating
%[out] = compareTempAndZ()

N=3;
filepath{1}='/Volumes/charvin/common/movies/Camille/2013/130523_calibrationObserver/record2_DFandTemp_data.mat';
filepath{2}='/Volumes/charvin/common/movies/Camille/2013/130523_calibrationObserver/recordWoStage1_DFandTemp_data.mat';
filepath{3}='/Volumes/charvin/common/movies/Camille/2013/130523_calibrationObserver/recordWoObjective1_DFandTemp_data.mat';


feature={'time','sampleTemp','stageTemp','stageSetTemp','objectiveTemp','objectiveSetTemp','z','zCorr'};
Colors={'r-','b-','g-','b--','g--'};
Colors2={'r-','r-','r-'};
Line2=[5,2,1];
Colors3={'ro','rx','rv'};
TitStr={'Objective + Stage heating','Objective heating', 'Stage heating'};


for i=1:N
    load(filepath{i});
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


figure;
hold on;
%k=1;
for i=1:N
    %     figure;
    subplot(1,3,i);
    hold on;
    k=1;
    
    for j=[2,3,5,4,6]
        plot(out.time{1,i}(1:end-1),out.(feature{j}){1,i}(1:end-1),Colors{k});
        k=k+1;
    end
    legend('Sample temp','Stage temp','Objective temp','Set temp Stage','Set temp Objective');
    title(['Response to change in temperature',TitStr{i}]);
%     ax1 = gca;
%     set(ax1,'YColor','k');
%     legend1 = legend(ax1,'show');
%     set(legend1,'Location','East');
    xlabel('Time (min)');
    ylabel('Temperature (°C)');
    hold off;
end
% ax2 = axes('Position',get(ax1,'Position'),...
%     'YAxisLocation','right',...
%     'Color','none',...
%     'YColor','r');
% for i=1:N
%     line(out.time{1,i},out.z{1,i}-out.z{1,i}(1,1),'Color','r','Parent',ax2);
% end
% ylabel('z (µm)');
hold off;

% subplot(1,3,3);
figure;
k=1;
hold on;
for i=1:N
    for j=2
        plot(out.time{1,i},out.(feature{j}){1,i},Colors2{k},'LineWidth',Line2(k));
        k=k+1;
    end
end
legend(TitStr{1},TitStr{2},TitStr{3});
title('Sample temperature upon 30 to 38 °C temperature switch');
xlabel('Time (min)');
ylabel('Temperature (°C)');
hold off;


figure;
k=1;
hold on;
for i=1:N
    for j=2
        L=length(out.time{1,i});
        l=round(L/100);
        range=[1:l:L];
        plot(out.time{1,i}(range),out.(feature{j}){1,i}(range),Colors3{k});
        k=k+1;
    end
end
legend(TitStr{1},TitStr{2},TitStr{3});
title('Sample temperature upon 30 to 38 °C temperature switch');
xlabel('Time (min)');
ylabel('Temperature (°C)');
hold off;

figure;
k=1;
hold on;
for i=1:N
    for j=2
        L=length(out.time{1,i});
        l=round(L/100);
        range=[1:l:L];
        plot(out.time{1,i}(range),out.(feature{j}){1,i}(range),Colors3{k});
        k=k+1;
    end
end
k=1;
for i=1:N
    for j=2
        plot(out.time{1,i},out.(feature{j}){1,i},Colors2{k});
        k=k+1;
    end
end
legend(TitStr{1},TitStr{2},TitStr{3});
title('Sample temperature upon 30 to 38 °C temperature switch');
xlabel('Time (min)');
ylabel('Temperature (°C)');
xlim([0 20]);
ylim([29 39]);
hold off;




end