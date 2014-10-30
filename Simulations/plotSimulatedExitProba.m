function [proba, Std, pSup, pMin, proba2, N]=plotSimulatedExitProba()
%Camille Paoletti - 04/2013
%plot exit probability from simulation (summary folder)


%path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/summaries/probaExit1div_summary';
%path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/summaries/probaExit1div_18_450_summary';
path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/summaries/probaExit1div_08_450_summary';

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
        proba(i,j)=simulationComputeExitProbability1div(temp_x);
        [bootstat] = bootstrp(1000,@simulationComputeExitProbability1div,temp_x);
        Mean(i,j)=mean(bootstat);
        Std(i,j)=std(bootstat);
        pSup(i,j)=Mean(i,j)+Std(i,j);
        pMin(i,j)=Mean(i,j)-Std(i,j);
    end
end

filename='/Users/camillepaoletti/Documents/Lab/Data/120823_probaExit.txt';
data=load(filename);
numel=find(data(:,3)==36 | data(:,3)==35)
data=data(numel,:);



Rstep=[0 850 1050 1250 10000];
proba2=zeros(length(Rstep)-1,1);
for i=1:length(Rstep)-1
    numel=find(data(:,2)>=Rstep(i));
    data_temp=data(numel,:);
    numel=find(data_temp(:,2)<Rstep(i+1));
    data_temp=data_temp(numel,:);
    numel=find(data_temp(:,4)~=2);
    temp_x=data_temp(numel,4);
    N(i)=length(temp_x);
    proba2(i)=computeExitProbability1div(temp_x);
    [bootstat, bootsam] = bootstrp(1000,@computeExitProbability1div,temp_x);
    Mean2(i)=mean(bootstat);
    Std2(i)=std(bootstat);
    pSup2(i)=Mean2(i)+Std2(i);
    pMin2(i)=Mean2(i)-Std2(i);
end




% offset=90;
% st=45;
offset=88;
st=36;

figure;
bar(step,horzcat(permute(proba,[2,1]),proba2));
hold on;
title('Probability for an aggregate to exit the bud depending on the initial bud radius');
xlabel('bud radius (nm)');
ylabel('exit probability');
set(gca,'XTickLabel',{'<850','850-1050','1050-1250','>1250'});
ylim([0 1.1]);
for i=1:length(r)
    errorbar(step-offset+i*st,Mean(i,:),Std(i,:),'k+');
end
errorbar(step-offset+4*st,Mean2,Std2,'k+');
for i=1:length(step)
    for j=1:length(r)
        text(step(i)-offset+j*st,Mean(j,i)+Std(j,i)+0.01,strcat('n=',num2str(1000)),'rotation',90);
    end
    text(step(i)-offset+4*st,Mean2(i)+Std2(i)+0.01,strcat('n=',num2str(N(i))),'rotation',90);
end
legend('R=200nm', 'R=300nm', 'R=400nm', 'experimental data');
hold off;




% hold on;
% bar(step,proba2,'g');
% errorbar(step,Mean2,Std2,'k+');
% legend('R=200nm', 'R=400nm','Experimental data');
% hold off;
n=3
N

toPlot=horzcat(transpose(proba(n,:)),proba2);


offset=90;
st=60;

figure;
bar(step,toPlot);
hold on;
title('Probability for an aggregate to exit the bud depending on the initial bud radius');
xlabel('bud radius (nm)');
ylabel('exit probability');
set(gca,'XTickLabel',{'<850','850-1050','1050-1250','>1250'});
a=get(gca,'XTick');
ylim([0 1.1]);
errorbar(step-offset+st,Mean(n,:),Std(n,:),'k+');
errorbar(step-offset+2*st,Mean2,Std2,'k+');
for i=1:length(step)
    text(step(i)-offset+st,Mean(n,i)+Std(n,i)+0.01,strcat('n=',num2str(1000)),'rotation',90);
    text(step(i)-offset+2*st,Mean2(i)+Std2(i)+0.01,strcat('n=',num2str(N(i))),'rotation',90);
end
legend('simulation', 'experimental data');
colormap autumn;
hold off;

end