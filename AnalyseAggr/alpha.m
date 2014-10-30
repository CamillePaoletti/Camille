function [c,h_fig,area,rat,pval,s]=alpha(Data,alpha,display)
%% ratio median as a function of growth rate

rat=[];
area=[];
area2=[];
alpha_exp=[];

for i=1:size(Data{2,1},2)
    fluoM=Data{1,1}(1,i,:);
    fluoM=fluoM(:);
    fluoD=Data{1,1}(2,i,:);
    fluoD=fluoD(:);
    
%         sm=10;
%         figure, plot(fluoM,'Color','r'); hold on; plot(fluoD,'Color','b'); xlabel('frame');ylabel('fluo');legend('mother','bud');
%         plot(smooth(fluoM,sm),'Color','k'); hold on; plot(smooth(fluoD,sm),'Color','b');
%         title(['Conc ' num2str(i)]);
%         set(gcf,'Position',[100 100 600 400]);
    
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
    %c=10;
    %alpha=0.01;
    if ~isnan(ratio2) & ~isinf(ratio2) & ~isnan(areaD(1))
        
        rat=[rat ratio2];
        area=[area (rmu2+alpha)/(rmu+alpha)];
        alpha_exp=[alpha_exp (rmu2-ratio2*rmu)/(ratio2-1)];
        
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
% m=min(min(rat),min(area))
% M=max(max(rat),max(area))
if display
    figure, loglog(area,rat,'r*'); hold on; loglog(0.001:0.001:10, 0.001:0.001:10,'Color','k');xlim([1e-3 1e1]);ylim([1e-3 1e1]);hold off;
    %figure, plot(area,rat,'r*'); hold on; plot(0.001:0.001:10, 0.001:0.001:10,'Color','k');
end

h_fig(1)=gca;

[c,pval]=corrcoef(log(area),log(rat));
[~,S] = polyfit(log(area),log(rat),1);
c=c(1,2);
pval=pval(1,2);
s=sum((log(area)-log(rat)).^2);
%disp(['Corr Coef = ',num2str(c)]);

% if display
%     figure;
%     hist(alpha_exp,[-1:0.005:1]);
%     mean(alpha_exp)
%     median(alpha_exp)
% end