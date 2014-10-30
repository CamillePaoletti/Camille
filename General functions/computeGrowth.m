function [polV,polA]=computeGrowth(initFrame, hsFrame, lastFrame)
%
%Camille Paoletti - 10/2013

%compute growth over time

display=1;
displayArea=1;

global segmentation;
global timeLapse;

areaTot=zeros(lastFrame-initFrame+1);

for i=initFrame:lastFrame
    cells=segmentation.cells1(i,:);
    num=[cells.n];
    numel=find(num);
    aTot=[cells(numel).area];
    areaTot(i)=sum(aTot);
end


timing=[initFrame:lastFrame].*double(timeLapse.interval/60);
vol=(areaTot).^(3/2);

lim=[initFrame,hsFrame,lastFrame];
temp=[30,38];
Int={-0.2;-0.4;-0.6};%Int={-0.05;-0.1;-0.15};
polV=cell(1,length(lim-1));
polA=cell(1,length(lim-1));

for i=1:length(lim)-1
    x=[lim(i):lim(i+1)];
    polV{i}=polyfit(timing(x),log(vol(x)),1);
    polA{i}=polyfit(timing(x),log(areaTot(x)),1);
    polvalV{i}=polyval(polV{i},x.*double(timeLapse.interval/60));
    polvalA{i}=polyval(polA{i},x.*double(timeLapse.interval/60));
end

if display
    fsize=12;
    figure;
    set(gca,'FontSize',fsize);
    plot(timing,log(vol));
    title('Growth rate','FontSize',fsize);
    xlabel('Time(min)','FontSize',fsize);
    ylabel('log(volume in pix^(3/2))','FontSize',fsize);
    hold on;
    for i=1:length(lim)-1
        x=[lim(i):lim(i+1)].*double(timeLapse.interval/60);
        plot(x,polvalV{i},'r-');
        ylim([16 20]);
    end
    
    %display doubling times
    a=get(gcf,'CurrentAxes');
    ax=floor(axis(a));
    b=1;e=200;
    str='doubling times:';
    text(ax(2)-e,ax(3)+b,str);
    for k=1:length(lim)-1
        str2=[num2str(temp(k)),'°C  - ', num2str(log(2)/polV{k}(1)),' min'];
        text(ax(2)-e,ax(3)+b+Int{k},str2);
    end
    hold off;
end

if displayArea
    figure;
    plot(timing,log(areaTot));
    title('Growth rate');
    xlabel('Time(min)');
    ylabel('log(area in pix^2)');
    hold on;
    for i=1:length(lim)-1
        x=[lim(i):lim(i+1)].*double(timeLapse.interval/60);
        plot(x,polvalA{i},'r-');
    end
     %display doubling times
    a=get(gcf,'CurrentAxes');
    ax=floor(axis(a));
    b=1;e=200;
    str='doubling times:';
    text(ax(2)-e,ax(3)+b,str);
    for k=1:length(lim)-1
        str2=[num2str(temp(k)),'°C  - ', num2str(log(2)/polA{k}(1)),' min'];
        text(ax(2)-e,ax(3)+b+Int{k},str2);
    end
    hold off;
end


end