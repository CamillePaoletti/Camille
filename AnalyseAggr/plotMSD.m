function plotMSD(foci)
%Camille Paoletti - 02/2013
%plot MSD for trajectories in 'foci'

global segmentation

n1=size(foci,1);
n2=size(foci,2);

Colors={'k-','k','b-','c-','g-','y-','m-','r-','r-','r-','r-','r','r','r','r'};

figure;
hold on;
for i=1:20
    for j=1:n2
       if isempty(foci{i,j})
       else
           c=round(foci{i,j}.area/15)
           plot(foci{i,j}.MSD(:,1),Colors{c});
           %errorbar(foci{i,j}.MSD(:,1),foci{i,j}.err(1:length(foci{i,j}.MSD(:,1)),1),Colors{c});
       end
    end
end
hold off;




end