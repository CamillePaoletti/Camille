function deleteFociNotInSegmentedCellsBatch
%Camille Paoletti - 02/2013

%for all frames of a project, delete foci that are not in segmented cells
%BE CAREFUL : save segmentation variable ! (yu won't be able to undo this
%process!!)


global segmentation;
global timeLapse;



fprintf(['Start to delete foci... \n']);

c=0;
phy_progressbar;


%h=figure;

%for all segmented images do the analyse

for i=1:length(segmentation.fociSegmented)
    i
    %fprintf('frame %d\n',i);
    
    %for i=61
    
    c=c+1;
    phy_progressbar(c/length(segmentation.fociSegmented));
    deleteFociNotInSegmentedCells(i);

end

pause(0.1);
save(fullfile(timeLapse.realPath,timeLapse.pathList.position{segmentation.position},'segmentation.mat'),'segmentation');

fprintf(['Deleting foci done ! \n']);