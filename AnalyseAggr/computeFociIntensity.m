function []=computeFociIntensity(initFrame, lastFrame)
%
%Camille Paoletti - 10/2013

%compute foci total intensity (pix*value) over time

display=1;

global segmentation;
global timeLapse;

areaTot=zeros(1,lastFrame-initFrame+1);
intensityFociTot=zeros(1,lastFrame-initFrame+1);
intensityCytoTot=zeros(1,lastFrame-initFrame+1);
intensityFociMean=zeros(1,lastFrame-initFrame+1);
intensityCytoMean=zeros(1,lastFrame-initFrame+1);

cc=0;
for i=initFrame:lastFrame
    cc=cc+1;
    cells=segmentation.cells1(i,:);
    num=[cells.n];
    numel=find(num);
    area=[cells(numel).area];
    areaTot(1,cc)=sum(area);
    intensity=[cells(numel).fluoNuclMax];%var
    intensityFociTot(1,cc)=sum(intensity);%sum of total intensity of fluorescence in foci in all cells
    intensity=[cells(numel).fluoCytoVar];
    intensityCytoTot(1,cc)=sum(intensity);%sum of total intensity of fluorescence in cytoplasm in all cells
    intensity=[cells(numel).fluoNuclMin];%mean
    pix=find(intensity);
    intensityFociMean(1,cc)=mean(intensity(pix));%mean intensity in foci (mean over all cells)
    intensity=[cells(numel).fluoCytoMean];
    intensityCytoMean(1,cc)=mean(intensity);%mean intensity in cytoplasm (mean over all cells)
end

intensityTot=intensityFociTot+intensityCytoTot;


timing=[initFrame:lastFrame].*double(timeLapse.interval/60);

if display
    %figure 1: evolution of fluorescence over time (total and mean fluo)
    figure;
    subplot(1,2,1);
    plot(timing,intensityFociTot,'r-');
    hold on;
    plot(timing,intensityCytoTot,'g-');
    title('Evolution of Total Fluo Intensity');
    xlabel('Time(min)');
    ylabel('Total fluo');
    legend('foci','cytoplasm');
    hold off;
    
    subplot(1,2,2);
    plot(timing,intensityFociMean,'r-');
    hold on;
    plot(timing,intensityCytoMean,'g-');
    title('Evolution of Mean Fluo Intensity');
    xlabel('Time(min)');
    ylabel('Mean fluo');
    legend('foci','cytoplasm');
    hold off;
    
    %figure 2: evolution of renormalized fluo over time
    figure;
    plot(timing,intensityFociTot./intensityTot,'r-');
    hold on;
    plot(timing,intensityCytoTot./intensityTot,'g-');
    title('Evolution of renormalized Total Fluo Intensity');
    xlabel('Time(min)');
    ylabel('Total fluo');
    legend('foci','cytoplasm');
    hold off;
    
    %figure 3 : evolution of fluo over time
    figure;
    plot(timing,intensityFociTot./areaTot,'r-');
    hold on;
    plot(timing,intensityCytoTot./areaTot,'g-');
    plot(timing,intensityTot./areaTot,'b-');
    title('Evolution of Total Fluo Intensity (renormalized by area)');
    xlabel('Time(min)');
    ylabel('Total fluo');
    legend('foci','cytoplasm','total');
    hold off;
end


end