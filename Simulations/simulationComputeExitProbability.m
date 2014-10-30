function [proba]=simulationComputeExitProbability(filename, out);
%Camille Paoletti - 01/13

%compute probability to exit the bud for an aggregate from simulations
%whose exit time summary is in filename

%out=maximum time of the simulation

%filename='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/checkOut_RANDOM_growth/RBUDi_940/R_250/t_agg.txt'

data=load(filename);
n=length(data);
size(data)
cc=0;
for i=1:n
if data(i)<out
    cc=cc+1;
end
proba=cc/n;
end