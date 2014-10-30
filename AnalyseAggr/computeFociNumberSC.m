function [Num,Max,MaxTime]=computeFociNumberSC(N, initFrame, lastFrame)
%
%Camille Paoletti - 10/2013

%compute the number of foci in the cell N over time

global segmentation;
global timeLapse;

display=1;

tcells=segmentation.tcells1(N);

stFrame=max(initFrame-tcells.detectionFrame+1,1);
if initFrame-tcells.detectionFrame+1<1
    initPlot=tcells.detectionFrame;
else
    initPlot=initFrame;
end

endFrame=min(lastFrame-tcells.detectionFrame+1,tcells.lastFrame-tcells.detectionFrame+1);
if tcells.lastFrame-tcells.detectionFrame+1<lastFrame
    endPlot=tcells.lastFrame;
else
    endPlot=lastFrame;
end

Num=[tcells.Obj(stFrame:endFrame).Nrpoints];
[Max,MaxTime]=max(Num);
MaxTime=MaxTime+initPlot-1;
timing=[initPlot:endPlot].*double(timeLapse.interval/60);

if display
    figure;
    plot(timing,Num);
    title(['Evolution of the number of foci in the cell n°',num2str(N),' following heat shock']);
    xlabel('Time (min)');
    ylabel('Mean number of foci per cell');
    ylim([0 13]);
    xlim([initFrame.*double(timeLapse.interval/60) lastFrame.*double(timeLapse.interval/60)]);
end

end