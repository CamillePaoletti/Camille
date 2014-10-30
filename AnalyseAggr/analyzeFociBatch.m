function [areaVal,meanVal,nbVal,cytoVal,MPfociVal,MPcytoVal] = analyzeFociBatch(filename)
%Camille Paoletti - 04/2012
%analyse Foci for every position of the folder filename
%ex: [areaVal,meanVal,nbVal,cytoVal] =
%analyzeFociBatch('L:\common\movies\Camille\2012\201204\120403_aggr_continuousStep35deg_analysis\120403_aggr35deg5stacks_analysis');

filenameTemp=strcat(filename,'-project.mat');
load(filenameTemp);

p=length(timeLapse.position.list);

areaVal=cell(1,p);
meanVal=cell(1,p);
nbVal=cell(1,p);
cytoVal=cell(1,p);
MPfociVal=cell(1,p);
MPcytoVal=cell(1,p);

for i=1:p
    filenameTemp=strcat(filename,'-pos',num2str(i),'/segmentation.mat'); 
    load(filenameTemp);
    [areaVal{1,i},meanVal{1,i},nbVal{1,i},cytoVal{1,i},MPfociVal{1,i},MPcytoVal{1,i},n]=analyzeFoci(0);
end

areaVal=cat(2,areaVal{:});
meanVal=cat(2,meanVal{:});
nbVal=cat(2,nbVal{:});
cytoVal=cat(2,cytoVal{:});
MPfociVal=cat(2,MPfociVal{:});
MPcytoVal=cat(2,MPcytoVal{:});


save(strcat(filename,'-fociAnalysis.mat'),'areaVal','meanVal','nbVal','cytoVal','MPfociVal','MPcytoVal');
end

