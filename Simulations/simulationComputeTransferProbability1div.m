function [proba]=simulationComputeTransferProbability1div(x);
%Camille Paoletti - 04/13

%compute probability of transfer from the mother to the bud from simulations
%whose last x coordinate is in x

Xcontact=sqrt(2500^2-650^2);

n=length(x);
daughter=find(x>Xcontact);
proba=numel(daughter)/n;

end