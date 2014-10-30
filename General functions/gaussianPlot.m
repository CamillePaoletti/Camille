function []=gaussianPlot
%Camille Paoletti - 03/2011
%plot "histogram" deduced from a gaussian mixture distribution on the same
%graph for Pten and WT



%parameters
%Data=strcat('C:\Users\Camille\Analyses\Lengths.mat');
Data=strcat('E:\Mes documents\Studies\Stage 2011\Analyses\Lengths.mat');
%Data=strcat('C:\Analyses\Lengths.mat');
numGaus=[1,2];
AREA=[11.83,10.72];%mean area (wt,pten)
SqrtMeanArea=[3.40,3.30];
colors={[1 0 0],[0 0 1]};
step1 = 0.001;
nbins = 60;
LEGEND={'WT','PTEN'};
XLABEL={'Length (µm)','Length/sqrt(Area) (a.u)'};
m=[1,2;3,4];


%%data loading
fprintf('load Pluc Data: %s \n', Data);
load(Data,'data');
DATA=cell(1,2);
DATA{1}=data(1:6955,3);
DATA{2}=data(6956:end,3);
%DATA{3}=data(1:6955,3)/sqrt(AREA(1));
%DATA{4}=data(6956:end,3)/sqrt(AREA(2));
DATA{3}=data(1:6955,3)/SqrtMeanArea(1);
DATA{4}=data(6956:end,3)/SqrtMeanArea(2);



%figure 1
figure(1);
figure(2);

for k=1:2
    for i=1:2
        m(k,i)
        obj = gmdistribution.fit(DATA{m(k,i)},numGaus(i))
        f = @(x)pdf(obj,x);
        x = (0:step1:max(DATA{m(k,i)}))';
        y = f(x);
        
        figure(k+4);
        hold on;
        h=plot(x,y/3,'r');
        set(h,'Color', colors{i});
        hold off;
        
        [g,a]=ecdf(DATA{m(k,i)});
        g=g(2:end);
        a=a(2:end);
        xi=a(1);
        xf=a(end);
        I = sum(y * step1);
        step2 = (xf-xi) / nbins;
        
        figure;
        n = hist(DATA{m(k,i)},nbins);
        J = sum(n*step2);
        hist(DATA{m(k,i)},nbins);
        hold on;
        plot(x,y * J / I,'r-','linewidth',3);
        legend('length histogram','gaussian mixture distribution');
        xlabel(XLABEL(k));
        ylabel('Counts');
        title(strcat('Length distribution (',LEGEND(i),')'));
        hold off;
        
        j= y*step1;
        j=cumsum(j);
        figure;
        plot(a(2:end),g(2:end),'b');
        hold on;
        plot(x,j,'g');
        legend('experimental cdf','gaussian mixture integral');
        xlabel(XLABEL(k));
        ylabel('Density of probability (a.u.)');
        title(strcat('Cumulative distribution function of length (',LEGEND(i),')'));
        hold off;
    end

    figure(k);
    hold on;
    %legend('wt','pten');
    %xlabel(XLABEL{k});
    %ylabel('Counts');
    %title(['Distribution of ',XLABEL{k},' (gaussian mixture)']);
    hold off;
end

end