function [meanNum,HISTO,meanFluo,HISTO2,meanFoci,HISTO3,meanRadius,HISTO4,y,y2]=compute_mean_and_histo(concat,initFrame,lastFrame)

%Camille Paoletti - 04/2014
%compute mean values and 2D histograms from data extracted in concat

%initialization
n=lastFrame-initFrame+1;
meanNum=zeros(1,n);
HISTO=zeros(n,11);
meanFluo=zeros(1,n);
HISTO2=zeros(n,13);
meanFoci=zeros(1,n);
HISTO3=zeros(n,13);
meanRadius=zeros(1,n);
HISTO4=zeros(n,11);

%computation
counter=0;
for i=initFrame:lastFrame
    
    counter=counter+1;
    number=concat{1,i};
    fluo=concat{2,i};
    foci=concat{3,i};
    radius=concat{4,i};
    
    %number of foci per cell evolution
    meanNum(1,counter)=mean(number);
    HISTO(counter,:) = histc(number,[0 1 2 3 4 5 6 7 8 9 10])./length(number);
    
    %mean fluo in foci in each cell 
    meanFluo(1,counter)=mean(fluo);
    ymax=6;
    y=[0:0.5:ymax];
    y=10.^y;
    HISTO2(counter,:) = histc(fluo,y)./length(fluo);
    
    %total fluo in each focus
    meanFoci(1,counter)=mean(foci);
    HISTO3(counter,:) = histc(foci,y)./length(foci);

    %radius of each focus
    meanRadius(1,counter)=mean(radius);
    y2=[0:0.05:0.5];
    HISTO4(counter,:) = histc(radius,y2)./length(radius);
     
end

end