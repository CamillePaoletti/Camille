function []=simulationPlotSegregationDependingInitialBudRadius()
%Camille Paoletti - 01/13

%plot results of 1000 simulations FIXED CONCENTRATION (on surf)

x=[650 940 1500 2000 2500];
y=[2.5 1.2 1.0 1.0 1.0];
z=[0.4074 0.8525 0.9771 0.9620 0.9896]

figure;
bar(x,ones(1,length(y))./y);
hold on;
title('Segregation after 90 min','Fontsize',12);
xlabel('bud radius (nm)','Fontsize',12);
ylabel('ratio of concentration of fluorescence in foci in D/M','Fontsize',12);
hold off;

figure;
bar(x,z);
hold on;
title('Segregation after 60 min','Fontsize',12);
xlabel('bud radius (nm)','Fontsize',12);
ylabel('ratio of concentration of fluorescence in foci in D/M','Fontsize',12);
hold off;
end