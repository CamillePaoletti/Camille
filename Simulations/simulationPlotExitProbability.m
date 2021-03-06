function simulationPlotExitProbability(foldername,out)
%Camille Paoletti - 01/2013

%plot probability to exit the bud for an aggregate from different simulations
%whose summary are stored in foldername

%out=maximum time of the simulation

%foldername='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/checkOut_RANDOM_growth';

R=250;
step=[650 750 940 1150 1350 1450];

proba=zeros(length(step),1);

cc=0;
for i=1:length(step)
    cc=cc+1;
    str=strcat(foldername,'/RBUDi_',num2str(step(cc)),'/R_',num2str(R),'/t_agg.txt');
    proba(cc)=simulationComputeExitProbability(str,out);
end

figure;
bar(step,proba);
hold on;
title('Probability for an aggregate to exit the bud depending on the initial bud radius');
xlabel('bud radius (nm)');
ylabel('exit probability');
hold off;


end