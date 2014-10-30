function [proba]=simulationComputeExitProbability1div(x);
%Camille Paoletti - 04/13

%compute probability to exit the bud for an aggregate from simulations
%whose last x coordinate is in x

Xcontact=sqrt(2500^2-650^2);

n=length(x);
mother=find(x<=Xcontact);
proba=numel(mother)/n;

end