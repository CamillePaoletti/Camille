function [meanNum,stdNum,nNum]=computeMeanFociNumber(initFrame, hsFrame, lastFrame)
%
%Camille Paoletti - 10/2013

%compute the evolution of the mean number of foci per cell present at HS
%ex: hsFrame=162;


%faire la même chose uniquement pour les cellules nées après le HS

global segmentation;
global timeLapse;

display=1;

cells=segmentation.cells1(hsFrame,:);
num=[cells.n];

cc=0;
meanNum=zeros(1,lastFrame-initFrame+1);
stdNum=zeros(1,lastFrame-initFrame+1);
nNum=zeros(1,lastFrame-initFrame+1);

for frame=initFrame:lastFrame
    cc=cc+1;
    cells=segmentation.cells1(frame,:);
    if frame>hsFrame
        n=[cells.n];
        ccc=0;
        for i=1:length(n)
            if find(num==n(i))
            else
                ccc=ccc+1;
                numelBud (ccc)= i;
            end
        end
        n=num;
    else
        n=[cells.n];
    end
    
    numel = find(n);
    
    N=[cells(numel).Nrpoints];
    meanNum(cc)=mean(N);
    stdNum(cc)=std(N);
    nNum(cc)=length(numel);
    
%     if numelBud
%         Nbud=[cells(numelBud).Nrpoints];
%         meanNumBud(cc)=mean(NBud);
%         stdNumBud(cc)=std(NBud);
%         nNumBud(cc)=length(numelBud);
%     else
%         Nbud=0;
%         meanNumBud(cc)=mean(NBud);
%         stdNumBud(cc)=std(NBud);
%         nNumBud(cc)=1;
%     end
    
end


if display
    timing=[initFrame:lastFrame].*double(timeLapse.interval/60);
    figure;
    errorbar(timing,meanNum,stdNum./sqrt(nNum));
    title('Evolution of the mean number of foci following heat shock');
    xlabel('Time (min)');
    ylabel('Mean number of foci per cell');
    text(max(timing)-3,max(meanNum)-1,['n = ',num2str(nNum(cc)),' cells'],'horizontalAlignment','right');
    hold on;
    errorbar(timing,meanNumBud,stdNumBud);
    hold off;
end

end