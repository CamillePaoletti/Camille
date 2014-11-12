function [hout hout2 vol2 rat idx2 iM iD]=agg_analysis(Data)

% code of Data variable

%  Data{1,1}=concentration
% 
% [ 2x92x78 double]
% 
% dim1: 1:mother / 2:bud
% 
% dim2: couple mother/bud
% 
% dim3: time evolution of concentration (renormalization by area)
% 
%         Data{2,1}=ratio
% 
%  [78x92    double]
% 
% dim1: time evolution of ratio (ccbud/ccmother)
% 
% dim2: couple mother/bud
% 
%         Data{3,1}=aire
% 
% [ 2x92x78 double]
% 
% same as concentration for area
% 
%         Data{4,1}=numéro des cellules
% 
%  [ 2x92    double]
% 
% dim1: 1:mother / 2:bud
% 
% dim2: numéro des cellules de chaque couple
% 
%         Data{5,1}=frame de division
% 
% [ 1x92    double]
% 
%         Data{6,1}=budding (first budding after division)
% 
%  [ 1x92    double]


% first filter and classify data

nz=70;

ncluster=5;

aM=zeros(1,nz);
aD=zeros(1,nz);

cM=zeros(1,nz);
cD=zeros(1,nz);

nM=zeros(1,nz);
nD=zeros(1,nz);

indM=zeros(1,nz);
indD=zeros(1,nz);

cc=1;

tdivarr=[];

cDsync=zeros(1,nz);
aDsync=zeros(1,nz);

for i=1:size(Data{5},2)
    
    concD=Data{1}(2,i,:); concD=concD(~isnan(concD));
    concM=Data{1}(1,i,:); concM=concM(~isnan(concM));
    
    areaM=Data{3}(1,i,:); areaM=areaM(~isnan(areaM));
    areaD=Data{3}(2,i,:); areaD=areaD(~isnan(areaD));
    
    numM=Data{7}(1,i,:); numM=numM(~isnan(numM));
    numD=Data{7}(2,i,:); numD=numD(~isnan(numD));
    
    indM=Data{4}(1,i); 
    indD=Data{4}(2,i); 

    tdiv=Data{5}(1,i);
    
    if tdiv<0
        continue
    end
    
    %length(areaD)
    
    if length(areaD)>=nz && length(areaM)>=nz
        
        aM(cc,:)=areaM(1:nz);
        aD(cc,:)=areaD(1:nz);%./areaM(1:nz); %M(cc,:);
        
        cM(cc,:)=concM(1:nz)./areaM(1:nz).^0;
        cD(cc,:)=concD(1:nz)./areaD(1:nz).^0;%./areaM(1:nz); %M(cc,:);
        
        nM(cc,:)=numM(1:nz)./areaM(1:nz).^0;
        nD(cc,:)=numD(1:nz)./areaD(1:nz).^0;%./areaM(1:nz); %M(cc,:);
       
        iD(cc)=indD;
        iM(cc)=indM;
        
        tdivarr=[tdivarr tdiv];
        cc=cc+1;
    end
    
end

IDX = kmeans(aD(:,1:5),ncluster,'replicates',100);

IDX=zeros(size(aD,1),1);


pix=find( mean(aD(:,1:5),2) < 300);
IDX(pix)=1;

pix=find( mean(aD(:,1:5),2) >= 300 & mean(aD(:,1:5),2) < 600);
IDX(pix)=2;

pix=find( mean(aD(:,1:5),2) >= 600 & mean(aD(:,1:5),2) < 1000);
IDX(pix)=3;
    
pix=find( mean(aD(:,1:5),2) >= 1000 & mean(aD(:,1:5),2) < 1500);
IDX(pix)=4;

pix=find( mean(aD(:,1:5),2) >= 1500);
IDX(pix)=5;

cmap=[  0         0.5000    1.0000
        0         1.0000    1.0000;
        0.0900    0.8200    0.4000
        1.0000    0.5000         0
        1.0000    0         0];

%IDX=IDX'

%figure;

%cmap=colormap(jet(ncluster));%POUR MODIFIER LE COLOR MAP !!

% for i=1:length(IDX)
%     plot(aD(i,:),'Color',cmap(IDX(i),:)); hold on;
% end

yl=[0 3200];
[rateD hAD]=plotA(aD,'Size B (10^3 pix.) ',ncluster,IDX,tdivarr,yl,cmap);

[rateM hAM]=plotA(aM,'Size M (10^3 pix.) ',ncluster,IDX,tdivarr,yl,cmap);


yl=[0 35];
[rateCM hCM] =plotC(cM,'[Fluo.M] (A.U.)',ncluster,IDX,tdivarr,rateM,0,yl,cmap);

[xyz    hCD] =plotC(cD,'[Fluo.B] (A.U.)',ncluster,IDX,tdivarr,rateD+rateCM,1,yl,cmap);


yl=[0 5.5];

[rateCM hNM]=plotC(nM,'# Foci M',ncluster,IDX,tdivarr,rateM,0,yl,cmap);

[xyz    hND]=plotC(nD,'# Foci B',ncluster,IDX,tdivarr,rateD+rateCM,1,yl,cmap);

%plotSync(aD,cD,tdivarr,IDX,ncluster)


%% plotting division timing as a function of bud size

vini=mean(aD(:,1:5),2);

hdiv=figure, plot(vini,3*tdivarr,'Marker','.','LineStyle','none','MarkerSize',8,'Color','k');
xlabel('Size B upon HS (10^3 pix.)');
ylabel('Time(HS-->Div) (min)');
xlim([0 2500]);
ylim([0 max(3*tdivarr)]);
set(gca,'XTick',[0 1000 2000])
set(gca,'XTickLabel',{'0','1','2'});




% plot groups of cells on ratio vs bud size plot

arrV=zeros(1,max(IDX));
stdV=zeros(1,max(IDX));

arrDiv=zeros(1,max(IDX));
stdDiv=zeros(1,max(IDX));

for i=1:max(IDX)
   pix1=find(IDX==i);
   temp=aD(pix1,1:5); % area bud averaged over 5 frames
   
   arrV(i)=mean(temp(:));
   stdV(i)=std(temp(:));%/sqrt(length(pix1));
   
   arrDiv(i)=3*mean(tdivarr(pix1));
   stdDiv(i)=std(3*tdivarr(pix1));%/sqrt(length(pix1));
   
end

% plot div time as a function of size at HS

figure, h1=errorbarxy(arrV, arrDiv, stdV, stdDiv,{'bo','b','b'});

set(h1.hMain,'LineWidth',1.5);
for i=1:length(h1.hErrorbar(:))
   set(h1.hErrorbar(i),'LineWidth',1.5);
end

% plot stall time as a function of size at HS

arrDiv=[63 45 30 0 0]; % guessed by eye !!! (error estimated by eye as well)
figure, h2=errorbarxy(arrV, arrDiv, stdV, 9*ones(1,5),{'bo','b','b'});

set(h2.hMain,'LineWidth',1.5);
for i=1:length(h2.hErrorbar(:))
   set(h2.hErrorbar(i),'LineWidth',1.5);
end

% plot ratio as a function size at HS

% size at HS : 
vini=mean(aD(:,1:5),2);

% ratio at division

rat=[];
vol2=[];
idx2=[];

cc=1;
for i=1:size(cD,1)
    inte=tdivarr(i)-1:tdivarr(i)+1;
    temp=mean(cD(i,inte))./mean(cM(i,inte));
    if ~isnan(temp)
    rat(cc)=temp;
    vol2(cc)=vini(i);
    idx2(cc)=IDX(i);
    cc=cc+1;
    end
end

hdiv2=figure;

plot(vol2,rat,'Marker','.','LineStyle','none','MarkerSize',8,'Color','k'); hold on;
plot(vol2(34),rat(34),'Marker','.','LineStyle','none','MarkerSize',8,'Color','r'); hold on;
plot(vol2(24),rat(24),'Marker','.','LineStyle','none','MarkerSize',8,'Color','r'); hold on;

arrR=zeros(1,max(IDX));
stdR=zeros(1,max(IDX));

for i=1:max(idx2)
   pix1=find(idx2==i);
   
   arrV(i)=mean(vol2(pix1));
   stdV(i)=std(vol2(pix1));%/sqrt(length(pix1));
   
   arrR(i)=mean(rat(pix1));
   stdR(i)=std(rat(pix1));%/sqrt(length(pix1));
end

%vol2(pix1)
%rat(pix1)


% plot div time as a function of size at HS
h3=errorbarxy(arrV, arrR, stdV, stdR,{'bo','b','b'});

set(h3.hMain,'LineWidth',1.5);
for i=1:length(h3.hErrorbar(:))
   set(h3.hErrorbar(i),'LineWidth',1.5);
end

xlabel('Size B upon HS (10^3 pix.)');
ylabel('Ratio [Fluo.B] / [Fluo.M] at div.');
xlim([0 2500]);
ylim([-0.2 4.4]);
set(gca,'XTickLabel',{'0','1','2'});


% output
hout=[hAD hAM hCD hCM hND hNM hdiv hdiv2];
hout2=[h1 h2 h3];

function plotSync(aD,cD,tdivarr,IDX,ncluster)

figure;

avgA=zeros(ncluster,21);
statsA=zeros(ncluster,21);

avgC=zeros(ncluster,21);
statsC=zeros(ncluster,21);

for i=1:ncluster
    pix1=find(IDX==i);
    for j=pix1'
        len=length(cD(j,:));
        tdiv=tdivarr(j);
        
        mine=max(1,tdiv-10);
        maxe=min(len,tdiv+10);
        
        arr=aD(j,mine:maxe);
        arrC=cD(j,mine:maxe);
        %i,j
       % figure, plot(cD(j,:));
       % figure, plot(aD(j,:));
        
        dif1=mine-(tdiv-10);
        dif2=maxe-(tdiv+10);
        
        avgA(i,1+dif1:21+dif2)=avgA(i,1+dif1:21+dif2)+arr;
        
        avgC(i,1+dif1:21+dif2)=avgC(i,1+dif1:21+dif2)+arrC;
        
        cc=zeros(1,21); cc(1+dif1:21+dif2)=1;
        statsA(i,1:21)=statsA(i,1:21)+cc;
        
      %  break
    end
end

%statsA,avgA,avgC
avgA=avgA./statsA;
avgC=avgC./statsA;

figure;
%cmap=colormap(lines(ncluster));
    
for i=1:ncluster
    plot(avgA(i,:),'Color',cmap(i,:)); hold on
end

line([11 11],[0 2500],'Color','k');

figure;
%cmap=colormap(jet(ncluster));

for i=1:ncluster
    plot(avgC(i,:),'Color',cmap(i,:)); hold on
end

line([11 11],[0 30],'Color','k');



function [rate hout]=plotA(dat,ylabe,ncluster,IDX,tdiv,yl,cmap)

hout=figure;

%cmap=colormap(jet(ncluster));
framerate=3;
rate=[];
for i=1:ncluster
    
    pix1=find(IDX==i);
    avg1=mean(dat(pix1,:),1);
    
      tim=3*(1:1:length(avg1));
      
    plot(tim,avg1,'Color',cmap(i,:),'lineWidth',2); hold on;
    
    line([mean(framerate*tdiv(pix1)) mean(framerate*tdiv(pix1))],[0 yl(2)],'Color',cmap(i,:),'lineStyle','--','lineWidth',1);
    
    % fit exponentiel
    first=max(1,round(mean(tdiv(pix1)))-15);
    last=round(mean(tdiv(pix1)))-2;
    x=first:last;
    
    %p=polyfit(x,log(avg1(x)),1);
    
    %y=exp(polyval(p,x));
    
    %plot(x,y,'Color',cmap(i,:),'LineStyle','--','lineWidth',2);
    
    
    %rate(i)=max(0,p(1));
    
    
end

set(gca,'FontSize',24);
xlabel('Time (min)');
ylabel(ylabe);
xlim([0 max(tim)]);
ylim(yl);
%text(-10,3100,'x10^3','FontSize',24);
x=[0 1 2 3];%get(gca,'YTickLabel');
set(gca,'YTickLabel',sprintf('%1.0f|',x));

function [rate hout]=plotC(dat,ylabe,ncluster,IDX,tdiv,ratein,typ,yl,cmap)

hout=figure;

%cmap=colormap(jet(ncluster));

framerate=3;

rate=[];
for i=1:ncluster
    
    pix1=find(IDX==i);
    avg1=mean(dat(pix1,:),1);
    
    tim=framerate*(1:1:length(avg1));
    
    plot(tim,avg1,'Color',cmap(i,:),'lineWidth',2); hold on;
    
    line([mean(framerate*tdiv(pix1)) mean(framerate*tdiv(pix1))],[0 yl(2)],'Color',cmap(i,:),'lineStyle','--','lineWidth',1);
    
    
    x=1:length(avg1);
    y=avg1;
    
%     % Fit: 'untitled fit 1'.
%     [xData, yData] = prepareCurveData( x, y );
%     
%     % Set up fittype and options.
%     ft = fittype( 'a*(1-exp(-b*x))/b', 'independent', 'x', 'dependent', 'y' );
%     opts = fitoptions( ft );
%     opts.Display = 'Off';
%     
%     if typ==0
%         
%         opts.Lower = [0.99 0];
%         opts.StartPoint = [1 0.01];
%         opts.Upper = [1.01 Inf];
%         
%     else
%         %ratein
%         opts.Lower = [0.99 0.99*ratein(i)];
%         opts.StartPoint = [1 ratein(i)];
%         opts.Upper = [1.01 1.01*ratein(i)];
%         
%     end
%     
%     % Fit model to data.
%     [fitresult, gof] = fit( xData, yData, ft, opts );
%     fitresult
%     fdata = feval(fitresult,xData);
%     
%     plot(xData,fdata,'Color',cmap(i,:),'LineStyle','--','lineWidth',2);
%     
%     rate(i)=fitresult.b-ratein(i);
    %h = plot( fitresult, xData, yData );
    
end

set(gca,'FontSize',24);
xlabel('Time (min)');
ylabel(ylabe);
xlim([0 max(tim)]);
ylim(yl);

