function [totMax,totMaxTime]=computeFociNumberAllSC(initFrame, hsFrame, lastFrame)
%
%Camille Paoletti - 10/2013

%for each cell present at HS, compute the number of foci in the cell over time

global segmentation;

cells=segmentation.cells1(hsFrame,:);
num=[cells.n];
num=num(find(num));

totMax=[];
totMaxTime=[];
for i=num
    [Num,Max,MaxTime]=computeFociNumberSC(i, initFrame, lastFrame);
    totMax=[totMax,Max];
    totMaxTime=[totMaxTime,MaxTime];
end



end