function [areaTot,volTot]=computeGrowth(initFrame, hsFrame, lastFrame,display)
%
%Camille Paoletti - 10/2013

%compute growth over time for the current position

global segmentation;
global timeLapse;

areaTot=zeros(1,lastFrame-initFrame+1);
volTot=zeros(1,lastFrame-initFrame+1);

cc=0;
for i=initFrame:lastFrame
    cc=cc+1;
    cells=segmentation.cells1(i,:);
    num=[cells.n];
    numel=find(num);
    aTot=[cells(numel).area];
    vTot=4/3*sqrt(1/pi)*(aTot).^(3/2);
    areaTot(1,cc)=sum(aTot);
    volTot(1,cc)=sum(vTot);
end


timing=[1:lastFrame-initFrame+1].*double(timeLapse.interval/60);
%volTot=areaTot;

lim=[initFrame,hsFrame,hsFrame+30,lastFrame];
pol=cell(1,length(lim)-1);
for i=1:length(lim)-1
    x=[lim(i):lim(i+1)];
    x=x-initFrame+1;
    pol{i}=polyfit(timing(x),log(volTot(x)),1);
    val{i}=polyval(pol{i},timing(x));
end

if display
    figure;
    plot(timing,log(volTot));
    title('Evolution of total volume over time');
    xlabel('Time(min)');
    ylabel('Total volume');
    hold on;
    for i=1:length(lim)-1
        x=[lim(i):lim(i+1)];
        x=x-initFrame+1;
        plot(timing(x),val{i},'r-');
        a=pol{i};
        text(timing(x(1)),max(val{i}),[num2str(log(2)/a(1)),' min']);
    end
    hold off;
end


end