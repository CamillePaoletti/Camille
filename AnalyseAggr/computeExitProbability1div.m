function [proba]=computeExitProbability1div(x);
%Camille Paoletti - 04/13

%compute probability to exit the bud for an aggregate from binary experimental
%data (0:no exit 1: exit)

n=length(x);
mother=find(x);
proba=numel(mother)/n;

end