function analyzeGrowth()
global segList

analyzeTimeLapse('Gilles');

% measure cell size as a function of age

sizeHistBud=zeros(1,60);
sizeHistBudVar=zeros(1,60);
sizeHistBudCount=zeros(1,60);

sizeHistDiv=zeros(1,60);
sizeHistDivVar=zeros(1,60);
sizeHistDivCount=zeros(1,60);

count=1;
for i=1:numel(segList)
   tcells=segList(i).s.tcells1(segList(i).line);
   
   %a=segList(i)
   
  % size at bud
   
   for j=1:numel(tcells.budTimes)
       
       t=tcells.budTimes(j)-tcells.detectionFrame+1;
       
       avg=(tcells.Obj(t).area+tcells.Obj(t+1).area+tcells.Obj(t-1).area)/3;
       sizeHistBud(j)=sizeHistBud(j)+avg;
       sizeHistBudVar(j)=sizeHistBudVar(j)+avg*avg;
       sizeHistBudCount(j)=sizeHistBudCount(j)+1;
   end
   
   % size at division
   
   for j=1:numel(tcells.divisionTimes)
       
       t=tcells.divisionTimes(j)-tcells.detectionFrame+1;
       
       avg=(tcells.Obj(t).area+tcells.Obj(max(1,t-1)).area+tcells.Obj(min(t+1,length(tcells.Obj))).area)/3;
       %avg=tcells.Obj(t).area;
       sizeHistDiv(j)=sizeHistDiv(j)+avg;
       sizeHistDivVar(j)=sizeHistDivVar(j)+avg*avg;
       sizeHistDivCount(j)=sizeHistDivCount(j)+1;
   end
   
   
   
   
   
end





% monitor cell size as a function generation number

% budding
pix=find(sizeHistBud~=0);
sizeHistBud=sizeHistBud(pix);
sizeHistBudCount=sizeHistBudCount(pix);
sizeHistBudVar=sizeHistBudVar(pix);

sizeHistBud=sizeHistBud./sizeHistBudCount;
sizeHistBudVar=sizeHistBudVar./sizeHistBudCount;


sizeHistBudVar=sqrt(sizeHistBudVar-sizeHistBud.^2)./sqrt(sizeHistBudCount);


figure, errorbar(sizeHistBud,sizeHistBudVar,'Marker','.','MarkerSize',10); hold on;
xlabel('Generations');
ylabel('Cell area (pixels)');
title(['n=' num2str(sizeHistBudCount(1)) 'cells']);

%division
pix=find(sizeHistDiv~=0);
sizeHistDiv=sizeHistDiv(pix);
sizeHistDivCount=sizeHistDivCount(pix);
sizeHistDivVar=sizeHistDivVar(pix);

sizeHistDiv=sizeHistDiv./sizeHistDivCount;
sizeHistDivVar=sizeHistDivVar./sizeHistDivCount;


sizeHistDivVar=sqrt(sizeHistDivVar-sizeHistDiv.^2)./sqrt(sizeHistDivCount);


errorbar(sizeHistDiv,sizeHistDivVar,'Marker','.','MarkerSize',10','Color','r');
xlabel('Generations');
ylabel('Cell area (pixels)');
title(['n=' num2str(sizeHistDivCount(1)) 'cells']);



% monitor cell size increase in G1 vs G2

diffG1=sizeHistBud-sizeHistDiv;
diffG2=sizeHistDiv(2:end)-sizeHistBud(1:end-1);


diffG1=sizeHistBud-sizeHistDiv;
diffG2=sizeHistDiv(2:end)-sizeHistBud(1:end-1);


for i=1:5
    
end

pl=[diffG1(1:20) ; diffG2(1:20)]'

figure, bar(pl); 


pl=[mean(diffG1(2:20)) ; mean(diffG2(2:20))]'

figure, bar(1,mean(diffG1(2:20))); hold on; bar(2,mean(diffG2(2:20)));


