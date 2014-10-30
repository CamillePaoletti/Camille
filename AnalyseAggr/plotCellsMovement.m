function plotCellsMovement()
%Camille Paoletti - 01/2013
%plot distance from the original frame for segmented cells
%idea: substract cells movement to get prcise aggregates movement
%(diffusive or not ?)



global segmentation;

cc=0;
for k=1:size(segmentation.cells1,2)
    if segmentation.cells1(1,k).n~0
        cc=cc+1;
        for i=1:length(segmentation.cells1)
            dist(i,cc)=sqrt((segmentation.cells1(i,k).ox-segmentation.cells1(1,k).ox)^2+(segmentation.cells1(i,k).oy-segmentation.cells1(1,k).oy)^2);
        end     
    end
end
%figure;
%plot(dist)

end