function [MSD,err]=simulationMSDfromlookAtTransferplot(filepath)
%[MSD,err]=simulationMSDplot(filepath)
%
%Camille - 04/2013
%
%filepath='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/data/lookAtTransfer_1div_18_450';
filepath='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/data/lookAtTransfer_1div_08_450';
%
%


step=[750 950 1150 1350];
r=[200 300 400];
dt=10;
Colors={'b-','b-','b-','r-','g-','b-','r-','b-','b-','b-'};

c=0;
cc=0;


figure;
hold on;
for k=400
    c=c+1;
    for j=750
        cc=cc+1;
        for i=1:10
            filename=[filepath '/Ragg_' num2str(k) '/Rbud_' num2str(j) '/coordinates/sim_' num2str(i),'.txt'];
            data=load(filename);
            data=data*1e-3;
            [MSD,err]=computeMSD(data(:,1),data(:,2));
            n=length(MSD);
            time=[0:1:n-1].*dt/60;
            plot(time,MSD(:,1),Colors{i});
        end
    end
end
title('Mean Square Displacement','fontsize',12);
xlabel('time (min)','fontsize',12);
ylabel('mean square displacement (µm^{2})','fontsize',12);
hold off;





end