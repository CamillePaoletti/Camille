function R=computeMeanFociRadius(foci)
%Camille Paoletti - 04/2102
%Compute mean radius of foci corresponding to trajectories in'foci'generated by foci=computeMSDbatch()

global segmentation

pixel=0.0830266;

n1=size(foci,1);%number of cell
n2=size(foci,2);%number max of foic per cell

cc=0;
for i=1:n1
    for j=1:n2
        if isempty(foci{i,j})
        else
            cc=cc+1;
            listArea(cc)=foci{i,j}.area;
        end
    end
end

radius=sqrt(listArea.*pixel.*pixel./pi);
R=mean(radius);

disp(['R = ' num2str(R) ' �m']);
