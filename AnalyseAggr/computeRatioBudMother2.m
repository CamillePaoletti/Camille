function [NrCc]=computeRatioBudMother2(frame)
%[ratio, motherCc, budCc]=computeRatioBudMother(l)
%Camille Paoletti - 05/2013 - corrected from computeRatioBudMother

%compute concentration of foci in bud and mother and ratio of concentration
%in frame l

global segmentation

cells=segmentation.cells1(frame,:);
coupleNum=vertcat([cells.mother],[cells.n]);
coupleNum=coupleNum(:,coupleNum(1,:)~=0);%list of the n° of [mother,bud]
K=length(coupleNum);
croppedCell(2,2,K)=phy_Object;
Cc=zeros(2,K,2);
CcArea=zeros(2,K,2);
NrCc=zeros(2,K,2);
ratio=zeros(2,K);
ratioA=zeros(2,K);

for i=1:2
    if i==2
        cells=segmentation.cells1(frame+20,:);
    end
     
    for k=1:K
        for l=1:2
            croppedCell(i,l,k)=cells([cells.n]==coupleNum(l,k));
        end
    end
    
    
    
    area(:,:,i)=reshape([croppedCell(i,:,:).area],2,K); %area of cells
    fluo(:,:,i)=reshape([croppedCell(i,:,:).fluoNuclVar],2,K);%total fluo in foci
    Nrpoints(:,:,i)=reshape([croppedCell(i,:,:).Nrpoints],2,K);%Nb of foci per cell
    volume(:,:,i)=area(:,:,i).^(3/2);
    
    %Cc(:,:,i)=fluo(:,:,i)./volume(:,:,i);
    CcArea(:,:,i)=fluo(:,:,i)./area(:,:,i);
    Cc(:,:,i)=fluo(:,:,i)./volume(:,:,i);
    NrCc(:,:,i)=Nrpoints(:,:,i)./volume(:,:,i);
  
    ratio(i,:)=Cc(2,:,i)./Cc(1,:,i);
    ratioA(i,:)=CcArea(2,:,i)./CcArea(1,:,i);
    
    mM=mean(Cc(1,:,i));%mean concentration in mother
    mB=mean(Cc(2,:,i));%mean concentration in bud
    mR=mean(ratio(i,:));%mean Ratio
    medianM=median(Cc(1,:,i));%median of concentration in mother
    medianB=median(Cc(2,:,i));%median of concentration in bud
    medianR=median(ratio(i,:));%median ratio
    
    
    disp(['frame ', num2str(i)]);
    disp(['mean concentration in bud = ',num2str(mB)]);
    disp(['mean concentration in mother = ',num2str(mM)]);
    disp(['mean ratio = ',num2str(mR)]);
    disp(['median concentration in bud = ',num2str(medianB)]);
    disp(['median concentration in mother = ',num2str(medianM)]);
    disp(['median ratio = ',num2str(medianR)]);
    
%     figure;
%     boxplot([transpose(budCc(i,:)),transpose(motherCc(i,:)),transpose(ratio(i,:))],'notch','on');
%     
%     
% %     figure;
% %     plot(budCc(i,:),motherCc(i,:),'b*');
%     

    disp(['concentration wikcoxon test']);
    [R,P]=corrcoef(Cc(1,:,i),Cc(2,:,i))
    [p,h] = ranksum(Cc(1,:,i),Cc(2,:,i))
    disp(['area wikcoxon test']);
    [R,P]=corrcoef(area(1,:,i),area(2,:,i))
    [p,h] = ranksum(area(1,:,i),area(2,:,i))
    
    %[R,P]=corrcoef(ratio,ratioA)
    %[p,h] = ranksum(ratio,ratioA)
    
   
    
    
end

numel=find(ratio(1,:));

disp(['ratio wikcoxon test']);
[R,P]=corrcoef(ratio(1,:),ratio(2,:))
[p,h] = ranksum(ratio(1,:),ratio(2,:))
disp(['non nul ratio wikcoxon test']);
[R,P]=corrcoef(ratio(1,numel),ratio(2,numel))
[p,h] = ranksum(ratio(1,numel),ratio(2,numel))

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
figure;
boxplot([transpose(ratio(1,:)),transpose(ratio(2,:)),transpose(zeros(1,K))],'notch','on');
% figure;
% boxplot([transpose(ratio(1,numel)),transpose(ratio(2,numel))],'notch','on');


end