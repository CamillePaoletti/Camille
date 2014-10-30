function [proba]=plotExitProbability(filename)
%Camille Paoletti - 03/2013

%plot probability to exit the bud for an aggregate from a data table.txt


%filename='/Users/camillepaoletti/Documents/Lab/Data/120823_probaExit.txt';

%%Parametres
step=[0 850 1050 1250 10000];
printedStep=[750 950 1150 1350];
temp=[30 32 33 35 36];
T=length(temp);



data=load(filename);

 numel=find(data(:,3)==36 | data(:,3)==35)
 data=data(numel,:);

proba=zeros(length(step)-1,4);

cc=0;
for i=1:length(step)-1
    cc=cc+1;
    [p,n,p2,n2]=computeExitProbability(data,step(i),step(i+1));
    proba(cc,1)=p;
    proba(cc,2)=n;
    proba(cc,3)=1-p2;
    proba(cc,4)=n2;
end




%proba=zeros(length(step)-1,4,T);

% for k=1:T
%     data=load(filename);
%     numel=find(data(:,3)==temp(k));
%     data=data(numel,:);
%     
%     cc=0;
%     for i=1:length(step)-1
%         cc=cc+1;
%         [p,n,p2,n2]=computeExitProbability(data,step(i),step(i+1));
%         proba(cc,1,k)=p;
%         proba(cc,2,k)=n;
%         proba(cc,3,k)=1-p2;
%         proba(cc,4,k)=n2;
%     end
% end



figure;
bar(printedStep,proba(:,1));
hold on;
errorbar(printedStep,proba(:,1),ones(4,1)*0.5./sqrt(proba(:,2)));
title('Probability for an aggregate to exit the bud depending on the initial bud radius');
xlabel('bud radius (nm)');
ylabel('exit probability');
set(gca,'XTickLabel',{'<850','850-1050','1050-1250','>1250'});
for i=1:length(step)-1
   text(printedStep(i),0.9-0.02,strcat(num2str(proba(i,2)),' cells'));   
end
ylim([0 0.9]);
hold off;


%figure;
% bar(printedStep,proba(:,3));
% hold on;
% title('Probability to have at least one aggregate in the bud depending on the initial bud radius');
% xlabel('bud radius (nm)');
% ylabel('exit probability');
% set(gca,'XTickLabel',{'<850','850-1050','1050-1250','>1250'});
% for i=1:length(step)-1
%    text(printedStep(i),1.1-0.02,strcat(num2str(proba(i,4)),' cells'));   
% end
% ylim([0 1.1]);
% hold off;

% figure;
% bar(printedStep,permute(proba(:,3,:),[1 3 2]));
% hold on;
% title('Probability to have at least one aggregate in the bud at t=12min');
% xlabel('bud radius (nm)');
% ylabel('probability to have at least one aggregate in the bud');
% set(gca,'XTickLabel',{'<850','850-1050','1050-1250','>1250'});
% for i=1:length(step)-1
%     for k=1:T
%         text(printedStep(i)+(k-1)*36-75,proba(i,3,k)+0.01,strcat('n=',num2str(proba(i,4,k))),'rotation',90);
%     end
% end
% ylim([0 1.1]);
% legend('31°C','34°C','36°C','38°C','39.5°C');
% hold off;

end

function [p,n,p2,n2]=computeExitProbability(data,Rmin,Rmax)
d=0;
dd=0;
for i=1:length(data)
    if Rmin<data(i,2) && data(i,2)<Rmax
        d=d+1;
        if data(i,4)==2
            dd=dd+1;
        end
    end   
end
p2=dd/d;
n2=d;

numel=find(data(:,4)~=2);
data=data(numel,:);
c=0;
cc=0;
for i=1:length(data)
    if Rmin<data(i,2) && data(i,2)<Rmax
        c=c+1;
        if data(i,4)
            cc=cc+1;
        end
    end   
end
p=cc/c;
n=c;
end
