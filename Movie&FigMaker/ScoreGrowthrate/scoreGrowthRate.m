function [fluoM,fluoD,areaM,areaD,bHSareaM,bHSareaD,HSareaM,HSareaD,bHSNrpointsM,HSNrpointsM,bHSNrpointsD,HSNrpointsD,SNrpointsM,SNrpointsD,SareaM,SareaD,bHSfluoM,bHSfluoD,HSfluoM,HSfluoD,SfluoM,SfluoD] =scoreGrowthRate()
%[fluoM,fluoD]=scoreGrowthRate()
%[bHSareaM,bHSareaD,HSareaM,HSareaD,bHSNrpointsM,HSNrpointsM,bHSNrpointsD,H
%SNrpointsD,SNrpointsM,SNrpointsD,SareaM,SareaD] =scoreGrowthRate()
%[area,areaTot,p,S,bud,ccTime,nb,bHSccTime,HSccTime,bHSccTimeD,bHSccTimeM,H
%SccTimeD,HSccTimeM,bHSarea,bHSareaM,bHSareaD,HSarea,HSareaM,HSareaD,bHSNrpointsM,HSNrpointsM,bHSNrpointsD,HSNrpointsD] =scoreGrowthRate()
%Camille Paoletti - 06/2012
%get tsum of areas of every cells in the cluster and plot it

global segmentation
global timeLapse

n=timeLapse.numberOfFrames;
m=length(segmentation.tcells1);
area=cell(n,1);
bud=cell(m,1);
areaTot=zeros(1,n);


for j=1:m
    if  segmentation.tcells1(1,j).N
        for i=1:length(segmentation.tcells1(1,j).Obj)
            area{i+segmentation.tcells1(1,j).detectionFrame-1,1}=horzcat(area{i+segmentation.tcells1(1,j).detectionFrame-1,1},segmentation.tcells1(1,j).Obj(1,i).area);
        end
        if segmentation.tcells1(1,j).budTimes
            bud{j,1}=segmentation.tcells1(1,j).budTimes(1,:);
        end
    end
end

for i=1:n
    areaTot(i)=sum(area{i,1});
end


t=[0:1:n-1].*timeLapse.interval/60;
t=double(t);

 l=2;
 fHS=323;%200;%323;%
 interval{1}=[20:1:63];%[70:1:320];%[20:1:160];
 interval{2}=[64:1:240];%[320:1:430];%%[180:1:400];

% l=3;
% fHS=63;
% delay=10;
% interval{1}=[20:1:63];%[1:1:10];
% interval{2}=[64:1:100];%[10:1:20];
% interval{3}=[105:1:240];%[20:1:40];

Colors={'r-','g-','c-'};
Int={-0.2;-0.6;-1};%Int={-0.05;-0.1;-0.15};
p=cell(l,1);
S=cell(l,1);
f=cell(l,1);
for k=1:l
    [p{k},S{k}] = polyfit(t(interval{k}),log(areaTot(interval{k})),1);
    f{k}=polyval(p{k},t(interval{k}));
end

figure;
plot(t,log(areaTot),'b*');
hold on;
title('Growth rate')
xlabel('time(min)');
ylabel('log(area in pix)');

a=get(gcf,'CurrentAxes');
ax=floor(axis(a));
b=2;e=500;
%b=1;e=50;
str='fit parametres:';
text(ax(2)-e,ax(3)+b,str);

for k=1:l
    plot(t(interval{k}),f{k},Colors{k});
    str1=['fit ',num2str(k),': a=',num2str(p{k}(1)),' b=',num2str(p{k}(2))];
    text(ax(2)-e+10,ax(3)+b+Int{k},str1);
    str2=['doubling time=', num2str(log(2)/p{k}(1))];
    text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
end
legend('exp data','fit1','fit2');
hold off;

volumeTot=areaTot.^(3/2);
p3=cell(l,1);
S3=cell(l,1);
f3=cell(l,1);
for k=1:l
    [p3{k},S3{k}] = polyfit(t(interval{k}),log(volumeTot(interval{k})),1);
    f3{k}=polyval(p3{k},t(interval{k}));
end

figure;
plot(t,log(volumeTot),'b*');
hold on;
title('Growth rate')
xlabel('time(min)');
ylabel('log(volume in pix^(3/2))');

a=get(gcf,'CurrentAxes');
ax=floor(axis(a));
b=2;e=500;
%b=1;e=50;
str='fit parametres:';
text(ax(2)-e,ax(3)+b,str);

for k=1:l
    plot(t(interval{k}),f3{k},Colors{k});
    str1=['fit ',num2str(k),': a=',num2str(p3{k}(1)),' b=',num2str(p3{k}(2))];
    text(ax(2)-e+10,ax(3)+b+Int{k},str1);
    str2=['doubling time=', num2str(log(2)/p3{k}(1))];
    text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
end
legend('exp data','fit1','fit2');
hold off;





%cell cycle timing
ccTime=cell(m,1);
for j=1:m
    if length(bud{j,1})>=2;
        ccTime{j,1}=bud{j,1}(1,2:end)-bud{j,1}(1,1:end-1);
    end
end


%number of cell and mean area
nb=zeros(1,n);
meanArea=zeros(1,n);
for i=1:n
    cc=0;
    area=[];
    for j=1:length(segmentation.cells1(i,:))
        if segmentation.cells1(i,j).n
            cc=cc+1;
            area=[area,segmentation.cells1(i,j).area];
        end
    end
    nb(1,i)=cc;
    meanArea(1,i)=mean(area);
end

p2=cell(l,1);
S2=cell(l,1);
f2=cell(l,1);
for k=1:l
    [p2{k},S2{k}] = polyfit(t(interval{k}),log(nb(interval{k})),1);
    f2{k}=polyval(p2{k},t(interval{k}));
end

%mean area
figure;
plot([1:1:n].*double(timeLapse.interval/60),log(nb),'b*');
hold on;
title('Growth rate')
xlabel('time(min)');
ylabel('log(nb of cells)');

a=get(gcf,'CurrentAxes');
ax=floor(axis(a));
b=2;e=500;
%b=1;e=50;
str='fit parametres:';
text(ax(2)-e,ax(3)+b,str);

for k=1:l
    plot(t(interval{k}),f2{k},Colors{k});
    str1=['fit ',num2str(k),': a=',num2str(p2{k}(1)),' b=',num2str(p2{k}(2))];
    text(ax(2)-e+10,ax(3)+b+Int{k},str1);
    str2=['doubling time=', num2str(log(2)/p2{k}(1))];
    text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
end
legend('exp data','fit1','fit2');
hold off;

figure;
plot([1:1:n].*double(timeLapse.interval/60),log(meanArea),'r-');
hold on;
title('mean Area versus time')
xlabel('time(min)');
ylabel('log(meanArea(pix))');
hold off;


repet=8;
tpulses=[0:10:repet*130];
pulses=repmat([1,1,0,0,0,0,0,0,0,0,0,0,0],1,repet);
pulses=[pulses,1];
figure;
plot([1:1:n].*double(timeLapse.interval/60),log(nb),'r*');
hold on;
title('Growth rate')
xlabel('time(min)');
ylabel('log scale');
plot(t,log(areaTot),'b*');
plot(tpulses,pulses,'g-');
legend('log(nb of cells)','log(area)','SCG-pulses');
hold off;


% figure;
% plot(bud{1,1}(1,2:end).*double(timeLapse.interval/60),ccTime{1,1}(1,:).*double(timeLapse.interval/60));
% hold on;
% for j=1:m
%     if ccTime{j,1}
%         plot(bud{j,1}(1,2:end).*double(timeLapse.interval/60),ccTime{j,1}(1,:).*double(timeLapse.interval/60));
%     end
% end
% hold off;

bHSccTime=[];
HSccTime=[];
bHSccTimeD=[];
HSccTimeD=[];
bHSccTimeM=[];
HSccTimeM=[];
bHSarea=[];
HSarea=[];
bHSareaD=[];
HSareaD=[];
bHSareaM=[];
HSareaM=[];
bHSNrpointsM=[];
HSNrpointsM=[];
bHSNrpointsD=[];
HSNrpointsD=[];
SNrpointsM=[];
SareaM=[];
SNrpointsD=[];
SareaD=[];
bHSfluoD=[];
HSfluoD=[];
bHSfluoM=[];
HSfluoM=[];
SfluoM=[];
SfluoD=[];
for j=1:m
    if ccTime{j,1}
        d=segmentation.tcells1(j).detectionFrame;
        %         for i=1:length(bud{j,1})-1
        %             if bud{j,1}(1,i)<fHS
        %                 bHSccTime=[bHSccTime,ccTime{j,1}(1,i)];
        %                 bHSarea=[bHSarea,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,i)).area];
        %             else
        %                 HSccTime=[HSccTime,ccTime{j,1}(1,i)];
        %                 HSarea=[HSarea,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,i)).area];
        %             end
        %         end
        %
        %         if segmentation.tcells1(j).N==1|segmentation.tcells1(j).N==3
        %             bHSccTimeM=[bHSccTimeM,ccTime{j,1}(1,1)];
        %             bHSareaM=[bHSareaM,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,1)).area];
        %         else
        %             if bud{j,1}(1,1)<fHS
        %                 bHSccTimeD=[bHSccTimeD,ccTime{j,1}(1,1)];
        %                 bHSareaD=[bHSareaD,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,i)).area];
        %             else
        %                 HSccTimeD=[HSccTimeD,ccTime{j,1}(1,1)];
        %                 HSareaD=[HSareaD,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,i)).area];
        %             end
        %         end
        %
        %         for i=2:length(bud{j,1})-1
        %             if bud{j,1}(1,i)<fHS
        %                 bHSccTimeM=[bHSccTimeM,ccTime{j,1}(1,i)];
        %                 bHSareaM=[bHSareaM,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,i)).area];
        %             else
        %                 HSccTimeM=[HSccTimeM,ccTime{j,1}(1,i)];
        %                 HSareaM=[HSareaM,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,i)).area];
        %             end
        %         end
        
        
        
                for i=1:length(segmentation.tcells1(1,j).Obj)
                    if d+i-1<fHS
                        %bHSccTime=[bHSccTime,ccTime{j,1}(1,i)];
                        bHSarea=[bHSarea,segmentation.tcells1(j).Obj(1,i).area];
                    else
                        %HSccTime=[HSccTime,ccTime{j,1}(1,i)];
                        HSarea=[HSarea,segmentation.tcells1(j).Obj(1,i).area];
                    end
                end
        
                for i=1:-d+1+bud{j,1}(1,1)-1
                    if segmentation.tcells1(j).N==1|segmentation.tcells1(j).N==3
                        if d+i-1<fHS
                        bHSNrpointsM=[bHSNrpointsM,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                        bHSareaM=[bHSareaM,segmentation.tcells1(j).Obj(1,i).area];
                        bHSfluoM=[bHSfluoM,segmentation.tcells1(j).Obj(1,i).fluoMean];
                        elseif d+i-1<fHS+delay
                        HSNrpointsM=[HSNrpointsM,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                        HSareaM=[HSareaD,segmentation.tcells1(j).Obj(1,i).area];
                        HSfluoM=[HSfluoM,segmentation.tcells1(j).Obj(1,i).fluoMean];
                        elseif d+i-1>300
                        SNrpointsM=[SNrpointsM,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                        SareaM=[SareaD,segmentation.tcells1(j).Obj(1,i).area];
                        SfluoM=[SfluoM,segmentation.tcells1(j).Obj(1,i).fluoMean];
                        end
                    else
                        if d+i-1<fHS
                            bHSNrpointsD=[bHSNrpointsD,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                            bHSareaD=[bHSareaD,segmentation.tcells1(j).Obj(1,i).area];
                            bHSfluoD=[bHSfluoD,segmentation.tcells1(j).Obj(1,i).fluoMean];
                        elseif d+i-1<fHS+delay
                            HSNrpointsD=[HSNrpointsD,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                            HSareaD=[HSareaD,segmentation.tcells1(j).Obj(1,i).area];
                            HSfluoD=[HSfluoD,segmentation.tcells1(j).Obj(1,i).fluoMean];
                        elseif d+i-1>100
                            SNrpointsD=[SNrpointsD,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                            SareaD=[SareaD,segmentation.tcells1(j).Obj(1,i).area];
                            SfluoD=[SfluoD,segmentation.tcells1(j).Obj(1,i).fluoMean];
                        end
                    end
                end
        
                for i=-d+1+bud{j,1}(1,1):length(segmentation.tcells1(1,j).Obj)
                    if d+i-1<fHS
                        bHSNrpointsM=[bHSNrpointsM,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                        bHSareaM=[bHSareaM,segmentation.tcells1(j).Obj(1,i).area];
                        bHSfluoM=[bHSfluoM,segmentation.tcells1(j).Obj(1,i).fluoMean];
                    elseif d+i-1<fHS+delay
                        HSNrpointsM=[HSNrpointsM,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                        HSareaM=[HSareaM,segmentation.tcells1(j).Obj(1,i).area];
                        HSfluoM=[HSfluoM,segmentation.tcells1(j).Obj(1,i).fluoMean];
                    elseif d+i-1>100
                        SNrpointsM=[SNrpointsM,segmentation.tcells1(j).Obj(1,i).Nrpoints];
                        SareaM=[SareaM,segmentation.tcells1(j).Obj(1,i).area];
                        SfluoM=[SfluoM,segmentation.tcells1(j).Obj(1,i).fluoMean];
                    end
                end
    end
end

fluoM=[];
fluoD=[];
areaM=[];
areaD=[];
for j=1:m
    if length(bud{j,1})>=1
        d=segmentation.tcells1(j).detectionFrame;
        k=1;
        l=1;
        %for i=1:length(bud{j,1})
            %if bud{j,1}(1,i)>=100;
            %                 j2=segmentation.tcells1(j).daughterList(1,k);
            %                 d2=segmentation.tcells1(j2).detectionFrame;
            %                 -d2+1+bud{j,1}(1,i)
            %                 -d+1+bud{j,1}(1,i)
            %                 fluoD=[fluoD,segmentation.tcells1(j2).Obj(-d2+1+bud{j,1}(1,i)).fluoMean];
            %                 fluoM=[fluoM,segmentation.tcells1(j).Obj(-d+1+bud{j,1}(1,i)).fluoMean];
            
            
            for i=1:length(segmentation.tcells1(j).divisionTimes)
                div=segmentation.tcells1(j).divisionTimes(1,l);
            if div>=100;
                j2=segmentation.tcells1(j).daughterList(1,k);
                d2=segmentation.tcells1(j2).detectionFrame;
                fluoD=[fluoD,segmentation.tcells1(j2).Obj(-d2+1+div).fluoMean];
                areaD=[areaD,segmentation.tcells1(j2).Obj(-d2+1+div).area];
                fluoM=[fluoM,segmentation.tcells1(j).Obj(-d+1+div).fluoMean];
                areaM=[areaM,segmentation.tcells1(j).Obj(-d+1+div).area];
                k=k+1;
                l=l+1;
            else
                k=k+1;
            end
        end
        
        
    end
    
end
end

