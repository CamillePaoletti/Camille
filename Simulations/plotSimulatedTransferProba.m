function [proba, Std, pSup, pMin]=plotSimulatedTransferProba()
%Camille Paoletti - 04/2013
%plot exit probability from simulation (summary folder)

%path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/summaries/probaTransfer1div_18_450_summary';
path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/summaries/probaTransfer1div_08_450_summary';

c=0;
step=[750 950 1150 1350];
r=[200 300 400]
for k=r
    c=c+1;
    cc=0;
    for j=step
        cc=cc+1;
        x{c,cc}=load([path '/Ragg_' num2str(k) '/Rbud_' num2str(j) '.txt']);
    end
end

proba=zeros(c,cc);
Mean=zeros(c,cc);
Std=zeros(c,cc);

for i=1:c
    for j=1:cc
        temp_x=x{i,j};
        proba(i,j)=simulationComputeTransferProbability1div(temp_x);
        [bootstat] = bootstrp(1000,@simulationComputeTransferProbability1div,temp_x);
        Mean(i,j)=mean(bootstat);
        Std(i,j)=std(bootstat);
        pSup(i,j)=Mean(i,j)+Std(i,j);
        pMin(i,j)=Mean(i,j)-Std(i,j);
    end
end


offset=90;
st=45;


figure;
bar(step,permute(proba,[2,1]));
hold on;
title('Probability for an aggregate to be transfered to the mother depending on the initial bud radius');
xlabel('bud radius (nm)');
ylabel('transfer probability');
set(gca,'XTickLabel',{'<850','850-1050','1050-1250','>1250'});
ylim([0 1.1]);
for i=1:length(r)
    errorbar(step-offset+i*st,Mean(i,:),Std(i,:),'k+');
end

for i=1:length(step)
    for j=1:length(r)
        text(step(i)-offset+j*st,Mean(j,i)+Std(j,i)+0.01,strcat('n=',num2str(1000)),'rotation',90);
    end
    
end
legend('R=200nm', 'R=300nm', 'R=400nm');
hold off;

figure;
data=permute(proba,[2,1]);
data(2,1)=0;
bar(step(1:2), data(1:2,:));
hold on;
title('Probability for an aggregate to be transfered to the mother depending on the initial bud radius');
xlabel('bud radius (nm)');
ylabel('transfer probability');
%set(gca,'XTickLabel',{'A','B','C''});
ylim([0 1.1]);
Mean(1,2)=0;
Std(1,2)=0;
for i=1:3
    errorbar(step-offset+i*st,Mean(i,:),Std(i,:),'k+');
end
% 
for i=1:2
    for j=1:length(r)
        round(data(i,j))
        text(step(i)-offset+j*st,Mean(j,i)+Std(j,i)+0.01,strcat('n = ',num2str(1000),' - proba = ',num2str(round(data(i,j)*100)),'%'),'rotation',90);
    end
    
end
hold on;

legend('R=200nm', 'R=300nm', 'R=400nm');
hold off;




end