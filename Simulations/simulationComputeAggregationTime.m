function [t,box] = simulationComputeAggregationTime(filepath,method);
%
%Camille - 12/2012
%
%read .txt file containing t_agg, compute mean, standard error... and plot
%mustache box

%filepath='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/checkOut/';

step=[10 20 30 40 50 75 100 150 200 250 300 500];
rcell=[650 940 1500 2000 2500];
t=cell(length(step),1);


if method ~0
    filepath=strcat(filepath,'RCELL_',num2str(method),'/');
    lab=cell(length(step),1);
    
    j=0;
    
    for i=step;
        j=j+1;
        filename=strcat(filepath,'R_',num2str(i),'/t_agg.txt');
        a=dlmread(filename);
        t{j,1}=a;
    end
    
    box=[];
    for k=1:j
        box=[box,t{k,1}];
        lab{k,1}=num2str(step(k));
    end
    box=box./60;
    
    
    figure;
    hold on;
    boxplot(box,'notch','on','labels',lab);
    title(['Distributuion of time to escape from mother in function of aggregate radius (50 draws - Rcell = ',num2str(method) ,' )']);
    xlabel('radius (nm)');
    ylabel('time (min)');
    hold off;
    
    figure;
    hold on;
    boxplot(box,'notch','on','labels',lab);
    axis([0 5.5 0 1000]);
    title('Distributuion of time to escape from mother in function of aggregate radius (50 draws)');
    xlabel('radius (nm)');
    ylabel('time (min)');
    hold off;
    
    
    figure;
    hold on;
    boxplot(box,'notch','on','labels',lab);
    axis([0 8.5 0 2000]);
    title('Distributuion of time to escape from mother in function of aggregate radius (50 draws)');
    xlabel('radius (nm)');
    ylabel('time (min)');
    hold off;
    
    figure;
    hold on;
    boxplot(box,'notch','on','labels',lab);
    axis([0 12 0 10000]);
    title('Distributuion of time to escape from mother in function of aggregate radius (50 draws)');
    xlabel('radius (nm)');
    ylabel('time (min)');
    hold off;
    
else
    t=cell(length(step),length(rcell));
    lab=cell(length(rcell),1);
    cc=0;
    for l=rcell
        cc=cc+1;
        filepath_temp=strcat(filepath,'RCELL_',num2str(l),'/');
        j=0;
        for i=step;
            j=j+1;
            filename=strcat(filepath_temp,'R_',num2str(i),'/t_agg.txt');
            a=dlmread(filename);
            t{j,cc}=a;
        end
    end
    
    
    for l=1:length(step)
        box=[];
        for k=1:length(rcell)
            box=[box,t{l,k}];
            lab{k,1}=num2str(rcell(k));
        end
        box=box./60;
        figure;
        hold on;
        boxplot(box,'notch','on','labels',lab);
        title(['Distributuion of time to escape from mother in function of cell radius (50 draws - Ragg=',num2str(step(l)),' )']);
        xlabel('cell radius (nm)');
        ylabel('time (min)');
        %axis([0 5 0 600]);
        hold off;
    end
end

end