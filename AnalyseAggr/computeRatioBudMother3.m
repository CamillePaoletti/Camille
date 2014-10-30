function [Cc,ratio,area,coupleNum,CcMean,ratioMean]=computeRatioBudMother3(hsFrame,lastFrame,meanLen,display)
%Camille Paoletti - 11/2013 - adapted from computeRatioBudMother2.m to
%unsynchronides cells
%
%compute concentration of foci in bud and mother and ratio of concentration
%for couples present at frame hsFrame+offset
global segmentation

%paramètres
offset=3;%offset=1;
%meanLen=1;%moyenne sur n frames
eventsLen=2;%nombres d'événements (hs, division, budding...)
totLen=meanLen*eventsLen;
individualDisplay=0;
meanDisplay=0;
individualPlot=0;

%initialisation des couples à considérer
cells=segmentation.cells1(hsFrame+offset,:);
coupleNum=vertcat([cells.mother],[cells.n]);
coupleNum=coupleNum(:,coupleNum(1,:)~=0);%list of the n° of [mother,bud]
%coupleNum=[11,4,6,5,9,19,20,26;214,215,287,209,206,194,201,208];
%coupleNum=[27,30,28,32,35,34,38,39;210,260,259,207,213,512,511,205];
K=length(coupleNum);

%initialisation des variables
croppedCell(totLen,2,K)=phy_Object;
area=zeros(2,K,totLen);
fluo=zeros(2,K,totLen);
Nrpoints=zeros(2,K,totLen);
volume=zeros(2,K,totLen);
Cc=zeros(2,K,totLen);
CcArea=zeros(2,K,totLen);
NrCc=zeros(2,K,totLen);
ratio=zeros(totLen,K);
ratioA=zeros(totLen,K);

for i=1:totLen
    if i<=meanLen
        cells=segmentation.cells1(hsFrame+offset-1+i,:);
        for k=1:K
            for l=1:2
                croppedCell(i,l,k)=cells([cells.n]==coupleNum(l,k));
            end
        end
    elseif i>meanLen && i<=2*meanLen
        tcells=segmentation.tcells1;
        for k=1:K
            numel=find([tcells.N]==coupleNum(1,k));
            if ~isempty(tcells(numel).divisionTimes)%il y a au moins 1 divisionTime
                if tcells(numel).divisionTimes==0;%il n'y a pas de division (~isempty because of a 0)
                else
                    frnumel=find(tcells(numel).divisionTimes);
                    tcelldiv=tcells(numel).divisionTimes(frnumel);
                    frame=tcelldiv(1);
                    frame=frame-meanLen+i-1;
                    if frame>lastFrame
                        for l=1:2
                            croppedCell(i,l,k).area=NaN;
                            croppedCell(i,l,k).fluoNuclVar=NaN;
                            croppedCell(i,l,k).Nrpoints=NaN;
                        end
                    else
                        cells=segmentation.cells1(frame,:);
                        for l=1:2
                            numel=find([cells.n]==coupleNum(l,k));
                            if numel %la cellule existe encore
                                croppedCell(i,l,k)=cells(numel);
                            else %la cellule n'existe plus
                                croppedCell(i,l,k).area=NaN;
                                croppedCell(i,l,k).fluoNuclVar=NaN;
                                croppedCell(i,l,k).Nrpoints=NaN;
                            end
                        end
                    end
                end
            else %s'il n'y a pas de division, on ne prend pas le point en compte
                for l=1:2
                    croppedCell(i,l,k).area=NaN;
                    croppedCell(i,l,k).fluoNuclVar=NaN;
                    croppedCell(i,l,k).Nrpoints=NaN;
                end
            end
            %         cells=segmentation.cells1(hsFrame+23,:);
            %         for k=1:K
            %             for l=1:2
            %                 croppedCell(i,l,k)=cells([cells.n]==coupleNum(l,k));
            %             end
            %         end
        end
    elseif i>2*meanLen && i<=3*meanLen
        tcells=segmentation.tcells1;
        for k=1:K
            numel=find([tcells.N]==coupleNum(1,k));
            if ~isempty(tcells(numel).budTimes)%il y a au moins 1 budTimes
                if length(tcells(numel).budTimes)>1;%il y a au moins un budding après le HS
                    frnumel=find(tcells(numel).budTimes);
                    tcellbud=tcells(numel).budTimes(frnumel);
                    frame=tcellbud(2);
                    frame=frame-2*meanLen+i-1;
                    if frame>119
                        for l=1:2
                            croppedCell(i,l,k).area=NaN;
                            croppedCell(i,l,k).fluoNuclVar=NaN;
                            croppedCell(i,l,k).Nrpoints=NaN;
                        end
                    else
                        cells=segmentation.cells1(frame,:);
                        for l=1:2
                            if l==1
                                numel=find([cells.n]==coupleNum(l,k));
                            elseif l==2
                                numel=find([tcells.N]==coupleNum(1,k));
                                numel=find([cells.n]==tcells(numel).daughterList(2));
                            end
                            if numel %la cellule existe encore
                                croppedCell(i,l,k)=cells(numel);
                            else %la cellule n'existe plus
                                croppedCell(i,l,k).area=NaN;
                                croppedCell(i,l,k).fluoNuclVar=NaN;
                                croppedCell(i,l,k).Nrpoints=NaN;
                            end
                        end
                    end
                end
            else %s'il n'y a pas de budding, on ne prend pas le point en compte
                for l=1:2
                    croppedCell(i,l,k).area=NaN;
                    croppedCell(i,l,k).fluoNuclVar=NaN;
                    croppedCell(i,l,k).Nrpoints=NaN;
                end
            end
        end
        
        
%     elseif i>3*meanLen && i<=4*meanLen
%         tcells=segmentation.tcells1;
%         for k=1:K
%             
%             frame=119;
%             cells=segmentation.cells1(frame,:);
%             for l=1:2
%                 
%                 numel=find([cells.n]==coupleNum(l,k));
%                 
%                 if numel %la cellule existe encore
%                     croppedCell(i,l,k)=cells(numel);
%                 else %la cellule n'existe plus
%                     croppedCell(i,l,k).area=NaN;
%                     croppedCell(i,l,k).fluoNuclVar=NaN;
%                     croppedCell(i,l,k).Nrpoints=NaN;
%                 end
%                 
%                 
%             end
%         end
%         
    end
    
    area(:,:,i)=reshape([croppedCell(i,:,:).area],2,K); %area of cells
    fluo(:,:,i)=reshape([croppedCell(i,:,:).fluoNuclVar],2,K);%total fluo in foci
    numel=find(fluo<0);fluo(numel)=0;
    Nrpoints(:,:,i)=reshape([croppedCell(i,:,:).Nrpoints],2,K);%Nb of foci per cell
    volume(:,:,i)=area(:,:,i).^(3/2);
    
    %area(:,:,i)=area(:,:,1);
    %volume(:,:,i)=volume(:,:,1);
    
    %Cc(:,:,i)=fluo(:,:,i)./volume(:,:,i);
    %CcArea(:,:,i)=fluo(:,:,i)./area(:,:,i);
    Cc(:,:,i)=fluo(:,:,i)./area(:,:,i);
    %Cc(:,:,i)=Nrpoints(:,:,i);
    NrCc(:,:,i)=Nrpoints(:,:,i)./volume(:,:,i);
    
    
    ratio(i,:)=Cc(2,:,i)./Cc(1,:,i);
    ratioA(i,:)=CcArea(2,:,i)./CcArea(1,:,i);
    
    
    
    if individualDisplay
        displayStatCc(Cc(:,:,i),ratio(i,:),area(:,:,i),1);      
    end
    
    
end


if individualDisplay
     displayStatRatio(ratio(1:2,:));
     displayStatRatio(ratio(2:3,:));
end

CcMean=zeros(2,K,eventsLen);
ratioMean=zeros(eventsLen,K);
for i=1:eventsLen
        Cc_temp=Cc(:,:,1+(i-1)*meanLen:meanLen+(i-1)*meanLen);
        CcMean(:,:,i)=mean(Cc_temp,3);
        ratio_temp=ratio(1+(i-1)*meanLen:meanLen+(i-1)*meanLen,:);
        ratioMean(i,:)=mean(ratio_temp,1);
end

if meanDisplay
    
    displayStatCc(CcMean,ratioMean,area,3);
    displayStatRatio(ratioMean);
end

if individualPlot
   for i=1:K
       figure;
       plot(permute(CcMean(1,i,:),[3 1 2]),'b-');
       hold on;
       plot(permute(CcMean(2,i,:),[3 1 2]),'r-');
       hold off;
   end
end

% figure;
% hold on;
% plot(ratio(1,numel)-ratio(2,numel),'b+');
% line([0 130],[0 0]);
% plot(ratio(1,numel),'r*');
% hold off;
%
%
% figure;
% boxplot([transpose(NrCc(1,:,1)),transpose(NrCc(2,:,1)),transpose(NrCc(1,:,2)),transpose(NrCc(2,:,2))],'notch','on');
%
% figure;
% boxplot([transpose(ratio(1,:)),transpose(ratio(2,:))],'notch','on');
%
% [R,P]=corrcoef(NrCc(2,:,1),NrCc(2,:,1))
% [p,h] = ranksum(NrCc(2,:,1),NrCc(2,:,1))
%
% [R,P]=corrcoef(NrCc(2,:,2),NrCc(2,:,2))
% [p,h] = ranksum(NrCc(2,:,2),NrCc(2,:,2))
%
%
% figure;
% plot(volume(2,numel,2)/volume(2,numel,1),Cc(2,numel,2)./Cc(2,numel,1));
%
% figure;
% plot(fluo(2,numel,2)./fluo(2,numel,1),'r+');
% hold on;
% plot(fluo(1,numel,2)./fluo(1,numel,1),'b+');
% hold off;
%
% %figure;
% % boxplot([transpose(fluoBud(2,numel)./fluoBud(1,numel)),transpose(fluoMother(2,numel)./fluoMother(1,numel))],'notch','on');
% % mean(transpose(fluoBud(2,numel)./fluoBud(1,numel)))
% % mean(transpose(fluoMother(2,numel)./fluoMother(1,numel)))
% %
% % boxplot([transpose(volumeBud(2,numel)./volumeBud(1,numel)),transpose(volumeMother(2,numel)./volumeMother(1,numel))],'notch','on');
% % mean(transpose(volumeBud(2,numel)./volumeBud(1,numel)))
% % mean(transpose(volumeMother(2,numel)./volumeMother(1,numel)))
%
% size(numel)
%
%
% figure;
% boxplot([transpose(Cc(1,:,1)),transpose(Cc(2,:,1)),transpose(ratio(1,:)),transpose(Cc(1,:,2)),transpose(Cc(2,:,2)),transpose(ratio(2,:))],'notch','on');
if display
    figure(2);
    boxplot([transpose(ratioMean(1,:)),transpose(ratioMean(2,:)),transpose(ratioMean(3,:))],'notch','on');
end
% figure%(3);
% numel=find(ratio(1,:));
% boxplot([transpose(ratioMean(1,numel)),transpose(ratioMean(2,numel))],'notch','on');


end


function displayStatCc(Cc,ratio,area,eventsLen)

for i=1:eventsLen
    numel=~isnan(Cc(1,:,i));
    numel=find(numel);
    mM=mean(Cc(1,numel,i));%mean concentration in mother
    medianM=median(Cc(1,numel,i));%median of concentration in mother
    
    numel=~isnan(Cc(2,:,i));
    numel=find(numel);
    mB=mean(Cc(2,numel,i));%mean concentration in bud
    medianB=median(Cc(2,numel,i));%median of concentration in bud
    
    numel=~isnan(ratio(i,:));
    numel=find(numel);
    mR=mean(ratio(i,numel));%mean Ratio
    medianR=median(ratio(i,numel));%median ratio
    
    disp(['frame ', num2str(i)]);
    disp(['mean concentration in bud = ',num2str(mB)]);
    disp(['mean concentration in mother = ',num2str(mM)]);
    disp(['mean ratio = ',num2str(mR)]);
    disp(['median concentration in bud = ',num2str(medianB)]);
    disp(['median concentration in mother = ',num2str(medianM)]);
    disp(['median ratio = ',num2str(medianR)]);
    
    
    disp('---');
    disp('concentration wikcoxon test');
    numel1=~isnan(Cc(1,:,i));
    numel2=~isnan(Cc(2,:,i));
    numel=numel1.*numel2;
    numel=find(numel);
    [R,P]=corrcoef(Cc(1,numel,i),Cc(2,numel,i));
    [p] = ranksum(Cc(1,numel,i),Cc(2,numel,i));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
    disp('---');
    disp('area wikcoxon test');
    [R,P]=corrcoef(area(1,numel,i),area(2,numel,i));
    [p] = ranksum(area(1,numel,i),area(2,numel,i));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
    disp('***');
    disp('***');
end
%[R,P]=corrcoef(ratio,ratioA)
%[p,h] = ranksum(ratio,ratioA)

end

function displayStatRatio(ratio)
    numel1=~isnan(ratio(1,:));
    numel2=~isnan(ratio(2,:));
    numel=numel1.*numel2;
    numel=find(numel);
    disp('ratio wikcoxon test - 1VS2');
    [R,P]=corrcoef(ratio(1,numel),ratio(2,numel));
    [p] = ranksum(ratio(1,numel),ratio(2,numel));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
    
    disp('ratio wilcoxon test - 2VS3')
    numel1=~isnan(ratio(3,:));
    numel2=~isnan(ratio(2,:));
    numel=numel1.*numel2;
    numel=find(numel);
    disp('ratio wikcoxon test');
    [R,P]=corrcoef(ratio(3,numel),ratio(2,numel));
    [p] = ranksum(ratio(3,numel),ratio(2,numel));
    disp(['covariance = ', num2str(R(1,2))]);
    disp(['p-value significant correlation = ',num2str(P(1,2))]);
    disp(['p-value median significantly different = ',num2str(p)]);
    
    
    
%     numel=find(ratio(1,:));
%     disp('non nul ratio wikcoxon test');
%     [R,P]=corrcoef(ratio(1,numel),ratio(2,numel));
%     [p] = ranksum(ratio(1,numel),ratio(2,numel));
%     disp(['covariance = ', num2str(R(1,2))]);
%     disp(['p-value significant correlation = ',num2str(P(1,2))]);
%     disp(['p-value median significantly different = ',num2str(p)]);

end