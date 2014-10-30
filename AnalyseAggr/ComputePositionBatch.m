function position=ComputePositionBatch(segmentedFrames)
%Camille Paoletti - 05/2014
%save positions of foci and nucleus center (in cell referential) for each cell in a movie

global segmentation;

%segmentation.budneckChannel=channel;
cc=0;
fprintf(['Processing segmentation ' num2str(cc) ' \n']);


%segmentedFrames=find(segmentation.cells1Segmented);%all segemented frames
tcells1=segmentation.tcells1;
ncells=[tcells1.N];
ncells=find(ncells);%number of the column corresponding to a cell
c=0;
phy_progressbar;

for i=ncells
    %fprintf('frame %d\n',i);
    
    %for i=61
    c=c+1;
    phy_progressbar(c/length(ncells));
    disp(i);
    position(c)=ComputePosition(i,segmentedFrames);
end

pause(0.1);

fprintf(['Computing position done ! \n']);

end