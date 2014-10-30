function plotBudFociAppearance()
%Camille Paoletti - 04/2013
%plot timing of apparition of foci in bud for data in a txt file


data=load('/Users/camillepaoletti/Documents/Lab/Movies/120515_aggr_30-35_2-9h/120515_budExit.txt');
data=vertcat(data(1:24,:),data(26:end,:));
a1=data(:,3)-data(:,2);
a2=data(:,8)-data(:,3);
figure;
hold on;
boxplot([a1*3,a2*3],'notch','on','labels',{'Budding to Focus nucleation','Focus nucleation to Division'});
ylabel('Time (min)');
title('Timing of apparition of foci in bud during the stationnary phase (T=38°C)');
ylim([0 80]);
hold off;


figure;
hold on;
plot((data(:,3)-data(:,2))*3,'r*');
%plot(data(:,8)-data(:,2),'k*');
plot((data(:,8)-data(:,3))*3,'b*');
ylim([0 80]);
hold off;


end