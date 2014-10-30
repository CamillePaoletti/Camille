function plotMeanRatioAndCC(Data)
%Camille Paoletti - 09/2014
%plot mean and median B/M Ratio and Concentration in mother and bud upon 
%time for Data stored in "Data" and generated with
%"computeRatioBudMotherAllDataPoints.m"

clear m;
num=isnan(Data{2,1});
num2=isinf(Data{2,1});
num=num+num2;

numM=isnan(Data{1,1}(1,:,:));
numM2=isinf(Data{1,1}(1,:,:));
numM=numM+numM2;

numB=isnan(Data{1,1}(2,:,:));
numB2=isinf(Data{1,1}(2,:,:));
numB=numB+numB2;

for i=1:size(num,1);
ratio=[];
ccM=[];
ccB=[];
ratio=Data{2,1}(i,~num(i,:));
ccM=Data{1,1}(1,~num(i,:),i);
ccB=Data{1,1}(2,~num(i,:),i);
med(1,i)=median(ratio);
mea(1,i)=mean(ratio);
medM(1,i)=median(ccM);
meaM(1,i)=mean(ccM);
medB(1,i)=median(ccB);
meaB(1,i)=mean(ccB);
end
figure,
subplot(1,3,1);
plot(med);
hold on;
plot(mea,'r');
legend('median','mean');
title('ratio');
hold off;
subplot(1,3,2);
hold on;
plot(medM);
plot(meaM,'r');
legend('median','mean');
title('conc M');
hold off;
subplot(1,3,3);
hold on;
plot(medB,'g');
plot(meaB,'r');
ylim([0 35]);
legend('median','mean');
title('conc B');
hold off;


end