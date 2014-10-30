function []=computeNumberAndAreaBudMother(frame)
%[]=computeNumber&AreaBudMother(frame)
%Camille Paoletti - 05/2013 - corrected from computeRatioBudMother

%compute mean number of foci and mean area of foci in bud and in mother
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
fociArea=cell(1,2);

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
    fluo(:,:,i)=reshape([croppedCell(i,:,:).fluoNuclMean],2,K);%total fluo in foci
    Nrpoints(:,:,i)=reshape([croppedCell(i,:,:).Nrpoints],2,K);%Nb of foci per cell
    volume(:,:,i)=area(:,:,i).^(3/2);
    
    N=reshape([croppedCell(i,:,:).vx],2,K);
    A=[croppedCell(i,1,find(N(1,:))).vy];
    fociArea{1,i}(1,:)=A(1,:);
    A=[croppedCell(i,2,find(N(2,:))).vy];
    fociArea{1,i}(2,1:length(A),i)=A(1,:);
    
    NrCc(:,:,i)=Nrpoints(:,:,i)./volume(:,:,i);
    NrRatio(1,:,i)=Nrpoints(2,:,i)./Nrpoints(1,:,i);
    
    
    mM=mean(fociArea{1,i}(1,find(fociArea{1,i}(1,:))));%mean area in mother
    mB=mean(fociArea{1,i}(2,find(fociArea{1,i}(2,:))));%mean area in bud
    mT=mean([fociArea{1,i}(1,find(fociArea{1,i}(1,:))),fociArea{1,i}(2,find(fociArea{1,i}(2,:)))]);
    %mR=mean(ratio(i,:));%mean Ratio
    medianM=median(fociArea{1,i}(1,find(fociArea{1,i}(1,:))));%median area in mother
    medianB=median(fociArea{1,i}(2,find(fociArea{1,i}(2,:))));%median area in bud
    medianT=median([fociArea{1,i}(1,find(fociArea{1,i}(1,:))),fociArea{1,i}(2,find(fociArea{1,i}(2,:)))]);
    %medianR=median(ratio(i,:));%median ratio
    
    
    disp(['frame ', num2str(i)]);
    disp(['mean area in pix = ',num2str(mT)]);
    disp(['mean area in pix in bud = ',num2str(mB)]);
    disp(['mean area in pix in mother = ',num2str(mM)]);
    %disp(['mean ratio = ',num2str(mR)]);
    disp(['median area in pix= ',num2str(medianT)]);
    disp(['median area in pix in bud = ',num2str(medianB)]);
    disp(['median area in pix in mother = ',num2str(medianM)]);
    %disp(['median ratio = ',num2str(medianR)]);
    disp(['mean number of foci per cell = ',num2str(mean(mean(Nrpoints(:,:,i))))]);
    disp(['mean number of foci per bud = ',num2str(mean(Nrpoints(2,:,i)))]);
    disp(['mean number of foci mother = ',num2str(mean(Nrpoints(1,:,i)))]);
    disp(['mean ratio = ',num2str(mean(NrRatio(1,:,i)))]);
    disp(['median number of foci bud = ',num2str(median([Nrpoints(1,:,i),Nrpoints(2,:,i)]))]);
    disp(['median number of foci bud = ',num2str(median(Nrpoints(2,:,i)))]);
    disp(['median number of foci mother = ',num2str(median(Nrpoints(1,:,i)))]);
    disp(['median ratio number = ',num2str(median(NrRatio(1,:,i)))]);
    
    
    
    
    disp(['mean area of bud = ',num2str(mean(area(2,:,i)))]);
    disp(['mean area of mother = ',num2str(mean(area(1,:,i)))]);
    disp(['median area of bud = ',num2str(median(area(2,:,i)))]);
    disp(['median area of mother = ',num2str(median(area(1,:,i)))]);
    
    
end

figure;
boxplot([transpose(Nrpoints(1,:,1)),transpose(Nrpoints(2,:,1)),transpose(Nrpoints(1,:,2)),transpose(Nrpoints(2,:,2))],'notch','on');

figure;
boxplot([fociArea{1,1}(1,find(fociArea{1,1}(1,:))),fociArea{1,1}(2,find(fociArea{1,1}(2,:))),fociArea{1,2}(1,find(fociArea{1,2}(1,:))),fociArea{1,2}(2,find(fociArea{1,2}(2,:)))],'notch','on');

sum(Nrpoints(1,:,1))
sum(Nrpoints(2,:,1))

end