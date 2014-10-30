% plot and analyze aggregates formation and mother enrichment

% Data variable from Camille :

% Data{1,1}=concentration
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

%%


% plot corr coefficient as a function of time

sm=10;

ratcorr=[];%corr coeff areaInit / ratio
arcorr=[];

of=0:70;

for j=of
    corrA=[];
    rat=[];%meanRatio (mean over 3 frames = j+1 to j+3)
    rat2=[];%final meanRatio (mean over 3 frames = end-2 to end)
    
    for i=1:92
        fluoM=Data{1,1}(1,i,:);
        fluoM=fluoM(:);
        fluoD=Data{1}(2,i,:);
        fluoD=fluoD(:);
        
        %     figure, plot(fluoM,'Color','r'); hold on; plot(fluoD,'Color','b');
        %     plot(smooth(fluoM,sm),'Color','k'); hold on; plot(smooth(fluoD,sm),'Color','b');
        %
        %     title(['Conc ' num2str(i)]);
        %     set(gcf,'Position',[100 100 600 400]);
        
        areaM=Data{3,1}(1,i,:);
        areaM=areaM(:);
        
        areaD=Data{3,1}(2,i,:);
        areaD=areaD(:);
        
        %     figure, plot(areaM,'Color','r'); hold on; plot(areaD,'Color','b');
        %     title(['Area ' num2str(i)]);
        %     set(gcf,'Position',[700 100 600 400]);
        
        
        ratio=Data{2,1}(:,i);
        pix=find(~isnan(ratio));
        ratio=ratio(pix);
        areaD=areaD(pix);
        
        pix=find(isinf(ratio));
        ratio(pix)=10;
        
        
        
        if length(ratio)>=j+3
            rat=[rat mean(ratio(j+1:j+3))];
            rat2=[rat2 mean(ratio(end-2:end))];
            corrA=[corrA mean(areaD(1:3))];
        end
        
        
        %     figure, plot(ratio,'Color','r'); hold on; plot(smooth(fluoD,sm)./smooth(fluoM,sm),'Color','r'); hold on;
        %
        %     title(['Ratio ' num2str(i)]);
        %     set(gcf,'Position',[1300 100 600 400]);
    end
    
    c=corrcoef(corrA,rat);
    c=c(1,2);
    ratcorr=[ratcorr c];
    
    if j==12
        figure, plot(corrA,rat,'Color','r'); title(['corr ' num2str(c) ' - mean ' num2str(mean(rat))]);
    end
    if j==6
        figure, plot(corrA,rat,'Color','r'); title(['corr ' num2str(c) ' - mean ' num2str(mean(rat))]);
    end
    %figure, plot(corrA,rat2,'Color','b'); corrcoef(corrA,rat2), mean(rat2)
end

%corrA,rat,rat2

%figure, plot(corrA,rat,'Color','r'); corrcoef(corrA,rat), mean(rat)
%figure, plot(corrA,rat2,'Color','b'); corrcoef(corrA,rat2), mean(rat2)

%ratcorr
figure, plot(of,ratcorr);


%% plot trajectories in fluo volume space


bud1=figure;
bud2=figure;
n=10;
col=colormap(jet(30));
cc1=1;
cc2=1;
for i=41:80
    fluoM=Data{1,1}(1,i,:);
    fluoM=fluoM(:);
    fluoD=Data{1}(2,i,:);
    fluoD=fluoD(:);
    
    %     figure, plot(fluoM,'Color','r'); hold on; plot(fluoD,'Color','b');
    %     plot(smooth(fluoM,sm),'Color','k'); hold on; plot(smooth(fluoD,sm),'Color','b');
    %
    %     title(['Conc ' num2str(i)]);
    %     set(gcf,'Position',[100 100 600 400]);
    
    areaM=Data{3,1}(1,i,:);
    areaM=areaM(:);
    
    areaD=Data{3,1}(2,i,:);
    areaD=areaD(:);
    
    %j=mod(i,10);
    if areaD(1)<700
        
        figure(bud1); plot(fluoM,'Color',col(cc1,:)); hold on;
        cc1=cc1+1;
    else
        figure(bud2); plot(fluoM,'Color',col(cc2,:)); hold on;
        cc2=cc2+1;
    end
end


%% ratio median as a function of growth rate

rat=[];
area=[];
area2=[];

for i=1:92
    fluoM=Data{1,1}(1,i,:);
    fluoM=fluoM(:);
    fluoD=Data{1}(2,i,:);
    fluoD=fluoD(:);
    
    %     figure, plot(fluoM,'Color','r'); hold on; plot(fluoD,'Color','b');
    %     plot(smooth(fluoM,sm),'Color','k'); hold on; plot(smooth(fluoD,sm),'Color','b');
    %
    %     title(['Conc ' num2str(i)]);
    %     set(gcf,'Position',[100 100 600 400]);
    
    areaM=Data{3,1}(1,i,:);
    areaM=areaM(:);
    
    areaD=Data{3,1}(2,i,:);
    areaD=areaD(:);
    
    ratio=Data{2,1}(:,i);
    
    div=Data{5,1}(i);
    
    if div==0
        continue
    end
    %
    %if div-42<5
    %    continue
    %end
    
    mine=max(div-42,5);
    xarr=1:1:mine;%frames to consider
    last=xarr(end);%last frame to consider
    
    
    areaD=areaD(xarr);
    areaM=areaM(xarr);
    
    
    %     p=polyfit(xarr',log(areaD),1);
    %     y=polyval(p,xarr);
    %     muD=p(1);
    %     %figure, plot(areaD); hold on; plot(exp(y),'Color','k');
    %
    %     p=polyfit(xarr',log(areaM),1);
    %     y=polyval(p,xarr);
    %     muM=p(1);
    %figure, plot(areaM); hold on; plot(exp(y),'Color','k');
    
    
    ratio2=mean(ratio(last-3:last));
    
    %figure, plot(ratio)
    %rmu=muM/muD;
    
    rmu=(areaD(end)-areaD(1))/areaD(1);
    rmu=rmu/length(xarr);
    
    rmu2=(areaM(end)-areaM(1))/areaM(1);
    rmu2=rmu2/length(xarr);
    
    %fluoM,fluoD
    %areaD
    c=10;
    if ~isnan(ratio2) & ~isinf(ratio2) & ~isnan(areaD(1))
        
        rat=[rat ratio2];
        area=[area rmu2/rmu];
        
        %fi= (1+c/rmu)./(1+c/rmu2);
        % area=[area fi];
        % area2=[area2 rmu2];
        % p=polyfit(1:1:length(areaD),log(areaD),1)
        
        %area=[area ];
    end
end

%size(rat)
%median(rat)
%mean(rat)

pix=find(rat<10 & rat>0 & area>0);
rat=rat(pix);
area=area(pix);
figure, loglog(area,rat,'r*'); hold on; loglog(0.001:0.001:10, 0.001:0.001:10,'Color','k');

corrcoef(log(area),log(rat))


