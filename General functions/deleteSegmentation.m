function [] = deleteSegmentation(filePath)
%Camille - 08/2012
%set segmentation channels values and makeTimeLapseMontageMovies

if nargin==0
else
    load(filePath)
end



global timeLapse;
global segmentation;

phaseChannel=1;
budneckChannel=3;

for k=1:numel(timeLapse.position.list);
    position=k;
    str=strcat(timeLapse.realPath,timeLapse.filename,'-pos',num2str(position),'/segmentation.mat');
    delete(str);
    
end
end