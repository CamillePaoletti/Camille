function plotSingleMSDanalysis(foci,n)
%Camille Paoletti - 04/2013
%plot foci tracks and cell contour for trajectories in 'foci' for cell n° n
%plot MSD of foci for this cell

pixel=0.0830266;

global segmentation

n1=size(foci,1);
n2=size(foci,2);

Colors={'r-','c-','g-','b-','m-','y-','k-','r-','c-','g-','b-','m-','y-','k-'};


figure;
hold on;
%subplot(1,2,1);
hold on;
for i=51
    plot(segmentation.tcells1(i).Obj(1).x,-segmentation.tcells1(i).Obj(1).y,'k');
    set(gca, 'DataAspectRatio', [1 1 1]);
    for j=1:n2
       if isempty(foci{i,j})
       else
           plot(foci{i,j}.x,-foci{i,j}.y,Colors{j});
       end
    end
    set(gca, 'DataAspectRatio', [1 1 1]);
end
hold off;

%subplot(1,2,2);
figure;
hold on;
for i=n
    for j=1:n2
       if isempty(foci{i,j})
       else
           y=foci{i,j}.MSD(:,1);
           x=[0:1:length(y)-1].*15;
           plot(x,y*pixel.*pixel,Colors{j});
       end
    end
end
xlabel('time (sec)');
ylabel('MSD (µm^2)');
title(strcat('MSD of foci in cell n°',num2str(n)));

hold off;



end