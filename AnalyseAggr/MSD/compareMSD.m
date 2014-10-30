function compareMSD(foci1,foci2,legend1,legend2)
%Camille Paoletti - 07/2013
%compare MSD of the same foci segmented differently in foci1 et foci2
%foic1 and foci2 have been computed trhough CorrectCoordinatesTcell.m
%legendi describes the field focii
%ex: compareMSD(foci3D,foci2D,'3D','2D');


mapping=mapImarisFoci(foci1,foci2);


for i=1:size(mapping,1)
    for j=1:size(mapping,2)
        if mapping(i,j)
            figure;
            plot(foci1{i,j}.MSD(:,1),'b+');
            hold on;
            plot(foci2{i,mapping(i,j)}.MSD(:,1),'r+');
            legend(legend1,legend2);
            
            hold off; 
        end
    end
end


end