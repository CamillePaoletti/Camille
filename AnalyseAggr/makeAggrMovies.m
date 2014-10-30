function [] = makeAggrMovies(filePath)
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
    segmentation=phy_createSegmentation(timeLapse,position);%phy_createSegmentation(timeLapse,phaseChannel,budneckChannel,position);
    segmentation.colorData=[1,1,1,0.01,0.1,1;0,1,0,0.0078,0.03,1;1,0,0,0.01,0.012,1];
    for i=segmentation.channels
        timeLapse.list(1,i).setLowLevel=segmentation.colorData(i,4)*2^16;
        timeLapse.list(1,i).setHighLevel=segmentation.colorData(i,5)*2^16;
    end 
    
    str=strcat(timeLapse.realPath,timeLapse.filename,'-pos',num2str(position),'/segmentation.mat');
    save(str,'segmentation');
    
end

str=strcat(timeLapse.realPath,timeLapse.realName);
save(str,'timeLapse');


makeTimeLapseMontageMovies();

end

