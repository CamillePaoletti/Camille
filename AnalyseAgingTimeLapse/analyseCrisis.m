function [CrisisN,Times,tTOT]=analyseCrisis(segList)
%Camille Paoletti - 11/2011
%plot histo, survival curves and so on
%ex: []=analyseCrisis('');

%%%%%%%%%%%%%%%%%%%
timeLapse.interval=600;
%%%%%%%%%%%%%%%%%%%%%

L=numel(segList);
bud=cell(L,1);
interval=cell(L,1);
div=cell(L,1);
tTOT=zeros(L,1);
for i=1:L
    bud{i,1}=segList(i).s.tcells1(segList(i).line).budTimes(1,:);
    interval{i,1}=timeLapse.interval;
    div{i,1}=segList(i).s.tcells1(segList(i).line).divisionTimes(1,:);
    tTOT(i,1)=numel(div{i,1})-1;%number of generation
end


s=zeros(L,2);
for i=1:L
    s(i,1)=length(bud{i,1});
    s(i,2)=length(div{i,1});
end

Times=cell(L,3);
for i=1:L
    t=min(s(i,1),s(i,2));
    
    Times{i,1}=(bud{i,1}(1:t)-div{i,1}(1:t))*double(interval{i,1})/60;%G1
    
    if s(i,1)==s(i,2)
        Times{i,2}=(div{i,1}(2:t)-bud{i,1}(1:t-1))*double(interval{i,1})/60;%S/G2/M
    else
        Times{i,2}=(div{i,1}(2:t+1)-bud{i,1}(1:t))*double(interval{i,1})/60;%S/G2/M
    end
    Times{i,3}=(div{i,1}(2:end)-div{i,1}(1:end-1))*double(interval{i,1})/60;%cell cycle (G1/%S/G2/M)
end

cr={'G1','S/G2/M','cell cycle'};
crisis=cell(L,3);
CrisisN=cell(L,3);
for i=1:L
    crisis{i,1}=find(Times{i,1}(1:end)>50);% crisis position (generation number) for cell i
    CrisisN{i,1}=crisis{i,1}(2:end);% exclusion of first cell cycle
    crisis{i,2}=find(Times{i,2}(1:end)>70);
    CrisisN{i,2}=crisis{i,2}(2:end);
    crisis{i,3}=find(Times{i,3}(1:end)>130);
    CrisisN{i,3}=crisis{i,3};
end

M=max(max(s));
CrisisT=cell(3,1);
%n=zeros(3,1);
for k=1:3
    CrisisT{k,1}=cat(2,CrisisN{:,k});% all crisis events (generation number)
    %n(k,1)=max(CrisisT{k,1});
end

%histogramm

nb=zeros(M,1);
for i=1:M
    nb(i,1)=length(find(tTOT==double(i)));
end
nb=vertcat(0,nb);%add 0 at the beginning
cum=cumsum(nb);
cum=(L*ones(M+1,1)-cum);

%[f,x] = ecdf(tTOT,'function', 'survivor');
% figure; %to check "manual" RLS (cum)
% hold on;
% plot([0:1:M],cum/L,'b+');
% plot(x,f,'r*');
% legend('manual','matlab');
% title('Survival curve');
% xlabel('generation number');
% ylabel('survival');
% hold off;

CrisisHist=zeros(M,3);
for k=1:3
    for i=1:M
        CrisisHist(i,k)=length(find(CrisisT{k,1}==i))./cum(i);% frequency of crisis at gen i (nb crisis at i / nb cells at i)
    end
end

figure;
hold on;
%for k=1:3
    bar(CrisisHist(:,1:2));
%end
legend('G1','S/G2/M','total');
title('Distribution of crisis');
xlabel('generation number');
ylabel('frequency of crisis');
hold off;


CrisisTN=cell(3,1);
CrisisNorm=cell(3,1);
for k=1:3
    for i=1:L
        CrisisNorm{i,k}=CrisisN{i,k}./tTOT(i);% crisis events for cell number i (renormalization by cell life span)
    end
    CrisisTN{k,1}=cat(2,CrisisNorm{:,k});% all crisis events (renormalized)
end

CrisisHistN=zeros(10,3);
a=[0.05:0.1:0.95];
xscale=horzcat(transpose(a),transpose(a));
for k=1:3
    for i=1:10
        A=CrisisTN{k,1}>(i-1)/10;
        B=CrisisTN{k,1}<=i/10;
        C=A.*B;
        CrisisHistN(i,k)=length(find(C==1));
    end
end
% figure;
% hold on;
% %for k=1:3
% bar(xscale,CrisisHistN(:,1:2));
% %end
% legend('G1','S/G2/M','total');
% title('Distribution of crisis - normalized life span');
% xlabel('generation number (normalized)');
% ylabel('number of crisis');
% hold off;

% distribution of duration of crisis
CrisisD=cell(3,1);
for k=1:3
    for i=1:L
        b=size(CrisisN{i,k},2);
        for j=1:b
            CrisisD{i,k}(1,j)=Times{i,k}(1,CrisisN{i,k}(1,j));
        end
    end
end

CrisisDT=cell(3,1);
for k=1:3
    CrisisDT{k,1}=cat(2,CrisisD{:,k});
end

CrisisHistD=zeros(10,3);

a=[5:10:1995];
xscale=horzcat(transpose(a),transpose(a));
for k=1:3
    for i=1:200
        A=CrisisDT{k,1}>(i-1)*10;
        B=CrisisDT{k,1}<=i*10;
        C=A.*B;
        CrisisHistD(i,k)=length(find(C==1));
    end
end
% figure;
% hold on;
% %for k=1:3
% bar(xscale,CrisisHistD(:,1:2));
% %end
% legend('G1','S/G2/M','total');
% title('Distribution of duration of crisis');
% xlabel('duration of crisis (min)');
% ylabel('counts');
% hold off;

surv=cell(L,3);
survWC=cell(L,3);
for i=1:L
    for k=1:3
        if isempty(CrisisN{i,k})
            surv{i,k}=tTOT(i,1);
        else
            survWC{i,k}=tTOT(i,1);
        end
    end   
end

survN=cell(3,1);
survWCN=cell(L,3);
for k=1:3
    survN{k,1}=cat(2,surv{:,k});
    survWCN{k,1}=cat(2,survWC{:,k});
end

% for k=1:3
%     figure;
%     hold on;
%     [f,x] = ecdf(survN{k,1},'function', 'survivor');
%     stairs(x,f,'LineWidth',2,'Color',[0 1 0]);
%     m1=mean(survN{k,1});
%     M1=median(survN{k,1});
%     std1=std(survN{k,1});
%     [f,x] = ecdf(survWCN{k,1},'function', 'survivor');
%     stairs(x,f,'LineWidth',2,'Color',[1 0 0]);
%     m2=mean(survWCN{k,1});
%     M2=median(survWCN{k,1});
%     std2=std(survWCN{k,1});
%     legend(['wo/ crisis (',num2str(length(survN{k,1})),' cells)'],['experiencing crisis (',num2str(length(survWCN{k,1})),' cells)']);
%     title(['Survival curve',' (',cr{k},')',' m: mean; M:median; std : standard deviation',' - wo/ crisis (',num2str(length(survN{k,1})),' cells; m=',num2str(m1),'; M=',num2str(M1),'; std=',num2str(std1),')',' - experiencing crisis (',num2str(length(survWCN{k,1})),' cells ; m=',num2str(m2),'; M=',num2str(M2),'; std=',num2str(std2),')']);
%     xlabel('generation');
%     ylabel('survival');
%     hold off;
% end

c1=1;
c2=10;
survWOC10=cell(L,3);
survWC10=cell(L,3);
for i=1:L
    for k=1:3
        if isempty(find(CrisisN{i,k}<(c2+1)&CrisisN{i,k}>(c1-1)));
            survWOC10{i,k}=tTOT(i,1);
        else
            survWC10{i,k}=tTOT(i,1);
        end
    end   
end

survWOC10N=cell(3,1);
survWC10N=cell(L,3);
for k=1:3
    survWOC10N{k,1}=cat(2,survWOC10{:,k});
    survWC10N{k,1}=cat(2,survWC10{:,k});
end

for k=1:3
    figure;
    hold on;
    [f,x] = ecdf(survWOC10N{k,1},'function', 'survivor');
    stairs(x,f,'LineWidth',2,'Color',[0 1 0]);
    m1=mean(survWOC10N{k,1});
    M1=median(survWOC10N{k,1});
    std1=std(survWOC10N{k,1});
    [f,x] = ecdf(survWC10N{k,1},'function', 'survivor');
    stairs(x,f,'LineWidth',2,'Color',[1 0 0]);
    m2=mean(survWC10N{k,1});
    M2=median(survWC10N{k,1});
    std2=std(survWC10N{k,1});
    legend(['wo/ crisis between ',num2str(c1),' and ',num2str(c2),' (',num2str(length(survWOC10N{k,1})),' cells)'],['experiencing crisis between ',num2str(c1),' and ',num2str(c2),' (',num2str(length(survWC10N{k,1})),' cells)']);
    title(['Survival curve',' (',cr{k},')',' m: mean; M:median; std : standard deviation',' - wo/ crisis (',num2str(length(survWOC10N{k,1})),' cells; m=',num2str(m1),'; M=',num2str(M1),'; std=',num2str(std1),')',' - experiencing crisis (',num2str(length(survWC10N{k,1})),' cells ; m=',num2str(m2),'; M=',num2str(M2),'; std=',num2str(std2),')']);
    xlabel('generation');
    ylabel('survival');
    hold off;
end

%[p,h,stats] = ranksum(survN{1,1},survWCN{1,1});

end