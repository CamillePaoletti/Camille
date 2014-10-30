function plotTracks(foci)
%Camille Paoletti - 02/2013
%plot foci tracks and cells contour for trajectories in 'foci'

global segmentation

n1=size(foci,1);
n2=size(foci,2);

Colors={'r-','c-','g-','b-','m-','y-','k-','r-','c-','g-','b-','m-','y-','k-'}

figure;
hold on;
for i=1:n1
    plot(segmentation.tcells1(i).Obj(1).x,segmentation.tcells1(i).Obj(1).y,'k');
    for j=1:n2
       if isempty(foci{i,j})
       else
           plot(foci{i,j}.x,foci{i,j}.y,Colors{j});
       end
    end
end

end