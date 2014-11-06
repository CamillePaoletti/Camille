function plotTraj(numel)
%Camille Paoletti - 11/2014
%plot trajectories for tcells1 whose number is indicated in numel
global segmentation

lmax=0;
n=length(numel);
divTime=cell(1,n);
for i=1:n
    tcell=segmentation.tcells1(1,numel(i));
    divTime{1,i}= tcell.budTimes(2:end)-tcell.budTimes(1:end-1);
    lm=length(divTime{1,i});
    if lm>lmax
       lmax=lm; 
    end
end

div=NaN(n,lmax);

for i=1:n
    div(i,1:length(divTime{1,i}))=divTime{1,i};
end

tabtrajiso(div);



end