function []=batchFociSegmentation(path,file,frames,pos)
%Camille Paoletti - 11/2013
%segment foci for path/file/frames/pos with parameters definined in
%phy_batchFociSegmentation

%ex: batchFociSegmentation('', '131029_HS_CDC10-HSP104', [1:119], [2:5])

    %cells segmentation
%phy_batchFociSegmentation(path,file,frames,pos,'cells');
    %cells mapping
%phy_batchFociSegmentation(path,file,frames,pos,'mapCells');
    
    %budnecks segmentation
%phy_batchFociSegmentation(path,file,frames,pos,'budencks');

    %foci segmentation
%phy_batchFociSegmentation(path,file,frames,pos,'foci');
    %foci computing
phy_batchComputing(path,file,pos,'foci');

%nucleus segmentation
%phy_batchFociSegmentation(path,file,frames,pos,'nucleus');

end