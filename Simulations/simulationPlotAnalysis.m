function [NbBud,NbTot]=simulationPlotAnalysis(filepath,N)
%Camille - 10/2012
%plot :
%   - fraction of aggregates in the mother among time
%   - concentration of aggregate in the mother among time


%for i=1:N
    %filepathSec=strcat(filepath,'/result_',num2str(i),'/');
    filepathSec=strcat(filepath);
    directory=dir(filepathSec);
    Ratio=[];
    RatioFluo=[];
    NbBud=[];
    NbTot=[];
    ccBud=[];
    ccMother=[];
    FccBud=[];
    FccMother=[];
   
    
    cc=0;
    for j=1:length(directory)
        if strfind(directory(j,1).name,'time')
            cc=cc+1;
        end
    end

    
    for k=0:cc-1
        str=strcat(filepathSec,'time_',num2str(k),'.txt');
        data=dlmread(str);
        test=data(:,2);
        radius=data(:,4);
        numel=find(test>2000);
        nbBud=length(numel);
        nbTot=length(radius);
        fluoBud=sum(radius(numel).*radius(numel).*radius(numel));
        fluoTot=sum(radius.*radius.*radius);
        ratio=nbBud/nbTot;
        NbBud=[NbBud,nbBud];
        NbTot=[NbTot,nbTot];
        Ratio=[Ratio,ratio];
        RatioFluo=[RatioFluo,fluoBud/fluoTot];
        bud=NbBud/(4/3*pi*1500^3);
        moth=(NbTot-NbBud)/(4/3*pi*2500^3);
        ccBud=[ccBud,bud];
        ccMother=[ccMother,moth];
        Fbud=fluoBud/(4/3*pi*1500^3);
        Fmoth=(fluoTot-fluoBud)/(4/3*pi*2500^3);
        FccBud=[FccBud,Fbud];
        FccMother=[FccMother,Fmoth];
    end
    
    n=length(Ratio);
    figure;plot([0:0.1:0.1*(n-1)],Ratio);
    hold on;
    title('Percentage of aggregates in bud');
    xlabel('time (sec)');
    ylabel('Nb of aggr or fluo in aggr / Nb tot');
    plot([0:0.1:0.1*(n-1)],RatioFluo,'r-');
    legend('number', 'fluo');
    hold off;
    
    
    figure;plot([0:0.1:0.1*(n-1)],ccBud./ccMother);
    hold on;
    title('Ratio of concentration in bud versus mother');
    xlabel('time (sec)');
    ylabel('Ratio');
    legend('number', 'fluo');
    plot([0:0.1:0.1*(n-1)],FccBud./FccMother,'r-');
    hold off;
%end





end