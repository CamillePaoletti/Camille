function [div]=plotDivisionTimes()

global segmentation
global timeLapse

n=length(segmentation.tcells1);
dT=timeLapse.interval/60;
div=cell(1,n);
for i=1:n
   div{1,i}=(segmentation.tcells1(1,i).divisionTimes(2:end)-segmentation.tcells1(1,i).divisionTimes(1:end-1))*dT; 
end

figure;
plot()

end