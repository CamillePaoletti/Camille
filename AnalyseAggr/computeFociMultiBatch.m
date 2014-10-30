function [] = computeFociMultiBatch(filename)
%Camille Paolett - 04/2012
%compute, for each cell of a FOLDER:
%   nb of foci ->seg.Nrpoint & wx
%   mean fluo of foci (pix*mean fluo) ->seg.Mean
%   mean cytoplasmic level -> seg.MeanCell
%   mean fluo and area for every foci ->seg.vy
%ex: computeFociMultiBatch('L:\common\movies\Camille\2012\201204\120411_aggr_analysis\120411_aggr_analysis');

filenameTemp=strcat(filename,'-project.mat');
load(filenameTemp);

for i=1:length(timeLapse.position.list)
    filenameTemp=strcat(filename,'-pos',num2str(i),'/segmentation.mat');
    
    load(filenameTemp);
    ComputeFociBatch(1);
    
end
end

