function [Ratio,R,meanRatio,NbFoci,NbCell, AreaFoci,RatioCyto,MotherFoci,DaughterFoci]=plotBudMotherRatio(display)
%Camille Paoletti - 09/2012
%plot ratio of foci in bud/mother in function of time

global segmentation;
%global timeLapse;


% Mean=total intensity of pix in foci
% Mean_cell=mean value of cytoplasm
% Nrpoints=nb of foci
% cells1(l,j).vx=nb of foci
% cells1(l,j).vy=[nb of pixel;mean value of pix in foci]
% cells1(l,j).cell1=total intensity of pix in foci
% cells1(l,j).cell2=total intensity of pix in the cytoplasm
% cells1(l,j).fluoMean=total intensity of pix in foci
% cells1(l,j).area=cell area

nbFrames=numel(find(segmentation.cells1Segmented));
%motherhood=[1,3,5,7,20,16,14,30,18,9,10,11;
% 2,4,6,28,34,26,15,31,25,13,29,12];
motherhood=[1,3,5,7,8,17,20,16,14,30,18,9,10,11;
    2,4,6,28,35,33,34,26,15,31,25,13,29,12];
% motherhood=[17,19,20,23,28,29,31,30,24,26,25,34,53,54,75,33,49,45,47,46,51,27,41,43,37,36,38,1,2,3,5,4,9,8,18,15,70,86,12;
%            77,32,21,66,117,80,110,109,58,60,59,35,83,74,61,82,50,72,73,71,63,79,42,44,40,39,108,68,57,56,7,6,10,11,48,16,14,69,13];
n=length(motherhood);
Ratio=cell(6,n);
NbFoci=zeros(nbFrames,n);
NbCell=zeros(nbFrames,n);
RatioCyto=cell(1,n);
TotFluo=cell(2,n);
TotFluoFoci=cell(2,n);
TotFluoCyto=cell(2,n);
MotherCyto=cell(2,n);
DaughterCyto=cell(2,n);
MotherFoci=cell(2,n);
DaughterFoci=cell(2,n);
VolRatio=cell(1,n);
MotherNb=cell(1,n);
DaughterNb=cell(1,n);
% RatioNb=cell(1,n);
% RatioFluo=cell(1,n);
% RatioNbRenorm=cell(1,n);
% RatioFluoRenorm=cell(1,n);
% REnb=cell(1,n);
% REfluo=cell(1,n);


for j=1:numel(segmentation.tcells1)%j=cellNumber
    for k=1:n%n=number of mother cells
        if segmentation.tcells1(1,j).N==motherhood(1,k)
            for p=1:numel(segmentation.tcells1)
                if segmentation.tcells1(1,p).N==motherhood(2,k)
                    fprintf('mother cell n� %d - N= %f // daughter cell n� %d - N= %f \n', k, segmentation.tcells1(1,j).N, k, segmentation.tcells1(1,p).N);
                    for l=[segmentation.tcells1(1,j).detectionFrame:1:segmentation.tcells1(1,j).lastFrame]
                        if l<segmentation.tcells1(1,p).detectionFrame
                            Ratio{1,k}(l,1)=NaN;
                            Ratio{2,k}(l,1)=NaN;
                            Ratio{3,k}(l,1)=NaN;
                            Ratio{4,k}(l,1)=NaN;
                            i=l-segmentation.tcells1(1,j).detectionFrame+1;
                            NbFoci(l,k)=segmentation.tcells1(1,j).Obj(1,i).vx;
                            NbCell(l,k)=1;
                            if segmentation.tcells1(1,j).Obj(1,i).vx==0;
                                Ratio{5,k}(l,1)=NaN;%percentage of foci in mother
                                Ratio{6,k}(l,1)=NaN;%percentage of fluo (in foci) in mother
                            else
                                Ratio{5,k}(l,1)=1;%percentage of foci in mother
                                Ratio{6,k}(l,1)=1;%percentage of fluo (in foci) in mother
                            end
                        else
                            i=l-segmentation.tcells1(1,j).detectionFrame+1;
                            q=l-segmentation.tcells1(1,p).detectionFrame+1;
                            NbFoci(l,k)=segmentation.tcells1(1,j).Obj(1,i).vx+segmentation.tcells1(1,p).Obj(1,q).vx;
                            NbCell(l,k)=2;
                            if segmentation.tcells1(1,j).Obj(1,i).vx==0;
                                if segmentation.tcells1(1,p).Obj(1,q).vx==0;
                                    Ratio{1,k}(l,1)=NaN;
                                    Ratio{2,k}(l,1)=NaN;
                                    Ratio{3,k}(l,1)=NaN;
                                    Ratio{4,k}(l,1)=NaN;
                                    Ratio{5,k}(l,1)=NaN;
                                    Ratio{6,k}(l,1)=NaN;
                                else
                                    Ratio{1,k}(l,1)=NaN;
                                    Ratio{2,k}(l,1)=NaN;
                                    Ratio{3,k}(l,1)=NaN;
                                    Ratio{4,k}(l,1)=NaN;
                                    Ratio{5,k}(l,1)=0;
                                    Ratio{6,k}(l,1)=0;
                                end
                            else
                                Ratio{1,k}(l,1)=segmentation.tcells1(1,p).Obj(1,q).vx/segmentation.tcells1(1,j).Obj(1,i).vx;
                                Ratio{2,k}(l,1)=segmentation.tcells1(1,p).Obj(1,q).cell1/segmentation.tcells1(1,j).Obj(1,i).cell1;
                                Ratio{3,k}(l,1)=Ratio{1,k}(l,1)*(segmentation.tcells1(1,j).Obj(1,i).area/segmentation.tcells1(1,p).Obj(1,q).area)^(3/2);
                                Ratio{4,k}(l,1)=Ratio{2,k}(l,1)*(segmentation.tcells1(1,j).Obj(1,i).area/segmentation.tcells1(1,p).Obj(1,q).area)^(3/2);
                                Ratio{5,k}(l,1)=segmentation.tcells1(1,j).Obj(1,i).vx/(segmentation.tcells1(1,j).Obj(1,i).vx+segmentation.tcells1(1,p).Obj(1,q).vx);%percentage of foci in mother
                                Ratio{6,k}(l,1)=segmentation.tcells1(1,j).Obj(1,i).cell1/(segmentation.tcells1(1,j).Obj(1,i).cell1+segmentation.tcells1(1,p).Obj(1,q).cell1);%percentage of fluo (in foci) in mother
                            end
                        end
                    end
                end
            end
        end
    end
end




for j=1:numel(segmentation.tcells1)%j=cellNumber
    for k=1:n%n=number of mother cells
        if segmentation.tcells1(1,j).N==motherhood(1,k)
            for p=1:numel(segmentation.tcells1)
                if segmentation.tcells1(1,p).N==motherhood(2,k)
                    fprintf('mother cell n� %d - N= %f // daughter cell n� %d - N= %f \n', k, segmentation.tcells1(1,j).N, k, segmentation.tcells1(1,p).N);
                    for l=[segmentation.tcells1(1,j).detectionFrame:1:segmentation.tcells1(1,j).lastFrame]
                        if l<segmentation.tcells1(1,p).detectionFrame
                            i=l-segmentation.tcells1(1,j).detectionFrame+1;
                            NbFoci(l,k)=segmentation.tcells1(1,j).Obj(1,i).vx;
                            NbCell(l,k)=1;
                            if NbFoci(l,k)~=0
                                AreaFoci(l,k)=sum(segmentation.tcells1(1,j).Obj(1,i).vy(1,:));
                            else
                                AreaFoci(l,k)=0;
                            end
                        else
                            i=l-segmentation.tcells1(1,j).detectionFrame+1;
                            q=l-segmentation.tcells1(1,p).detectionFrame+1;
                            NbFoci(l,k)=segmentation.tcells1(1,j).Obj(1,i).vx+segmentation.tcells1(1,p).Obj(1,q).vx;
                            NbCell(l,k)=2;
                            if NbFoci(l,k)~=0
                                AreaFoci(l,k)=sum(segmentation.tcells1(1,j).Obj(1,i).vy(1,:))+sum(segmentation.tcells1(1,p).Obj(1,q).vy(1,:));
                            else
                                AreaFoci(l,k)=0;
                            end
                        end
                    end
                end
            end
        end
    end
end





for j=1:numel(segmentation.tcells1)%j=cellNumber
    for k=1:n%n=number of mother cells
        if segmentation.tcells1(1,j).N==motherhood(1,k)
            for p=1:numel(segmentation.tcells1)
                if segmentation.tcells1(1,p).N==motherhood(2,k)
                    fprintf('mother cell n� %d - N= %f // daughter cell n� %d - N= %f \n', k, segmentation.tcells1(1,j).N, k, segmentation.tcells1(1,p).N);
                    for l=[segmentation.tcells1(1,j).detectionFrame:1:segmentation.tcells1(1,j).lastFrame]
                        if l<segmentation.tcells1(1,p).detectionFrame
                            i=l-segmentation.tcells1(1,j).detectionFrame+1;
                            Mcyto=segmentation.tcells1(1,j).Obj(1,i).cell2-500*segmentation.tcells1(1,j).Obj(1,i).area;
                            Dcyto=0;
                            Mfoci=segmentation.tcells1(1,j).Obj(1,i).cell1;
                            Dfoci=0;
                            Mvolume=(segmentation.tcells1(1,j).Obj(1,i).area)^(3/2);
                            Dvolume=0;
                            Mnb=segmentation.tcells1(1,j).Obj(1,i).vx;
                            Dnb=NaN;
                            DaughterCyto{2,k}(l,1)=NaN;
                            DaughterFoci{2,k}(l,1)=NaN;
                        else
                            i=l-segmentation.tcells1(1,j).detectionFrame+1;
                            q=l-segmentation.tcells1(1,p).detectionFrame+1;
                            Mcyto=segmentation.tcells1(1,j).Obj(1,i).cell2-500*segmentation.tcells1(1,j).Obj(1,i).area;
                            Dcyto=segmentation.tcells1(1,p).Obj(1,q).cell2-500*segmentation.tcells1(1,p).Obj(1,q).area;
                            Mfoci=segmentation.tcells1(1,j).Obj(1,i).cell1;
                            Dfoci=segmentation.tcells1(1,p).Obj(1,q).cell1;
                            Mvolume=(segmentation.tcells1(1,j).Obj(1,i).area)^(3/2);
                            Dvolume=(segmentation.tcells1(1,p).Obj(1,q).area)^(3/2);
                            Mnb=segmentation.tcells1(1,j).Obj(1,i).vx;
                            Dnb=segmentation.tcells1(1,p).Obj(1,q).vx;
                            DaughterCyto{2,k}(l,1)=Dcyto/Dvolume;
                            DaughterFoci{2,k}(l,1)=Dfoci/Dvolume;
                            
                        end
                        RatioCyto{1,k}(l,1)=(Dcyto/Dvolume)/(Mcyto/Mvolume);
                        TotFluo{1,k}(l,1)=Mcyto+Dcyto+Mfoci+Dfoci;
                        TotFluo{2,k}(l,1)= TotFluo{1,k}(l,1)/(Mvolume+Dvolume);
                        TotFluoFoci{1,k}(l,1)=Mfoci+Dfoci;
                        TotFluoFoci{2,k}(l,1)=TotFluoFoci{1,k}(l,1)/(Mvolume+Dvolume);
                        TotFluoCyto{1,k}(l,1)=Mcyto+Dcyto;
                        TotFluoCyto{2,k}(l,1)=TotFluoCyto{1,k}(l,1)/(Mvolume+Dvolume);
                        MotherCyto{1,k}(l,1)=Mcyto;
                        DaughterCyto{1,k}(l,1)=Dcyto;
                        MotherCyto{2,k}(l,1)=Mcyto/Mvolume;
                        MotherFoci{1,k}(l,1)=Mfoci;
                        DaughterFoci{1,k}(l,1)=Dfoci;
                        MotherFoci{2,k}(l,1)=Mfoci/Mvolume;
                        VolRatio{1,k}(l,1)=Dvolume/Mvolume;
                        MotherNb{1,k}(l,1)=Mnb;
                        DaughterNb{1,k}(l,1)=Dnb;
                    end
                end
            end
        end
    end
end

R=cell(6,nbFrames);
meanRatio=zeros(6,nbFrames);
stdRatio=zeros(6,nbFrames);
errorRatio=zeros(6,nbFrames);
RC=cell(1,nbFrames);

for z=1:6
    for k=1:n
        for i=1:length(Ratio{z,k})
            R{z,i}=[R{z,i},Ratio{z,k}(i,1)];
        end
    end
    
end

for z=1:6
    for i=1:nbFrames
        TF = isnan(R{z,i});
        TF=1-TF;
        a=find(TF==1);
        meanRatio(z,i)=mean(R{z,i}(1,a));
        stdRatio(z,i)=std(R{z,i}(1,a));
        errorRatio(z,i)=std(R{z,i}(1,a))/sqrt(numel(a));
        
    end
    
end


%Ratio of fluorescence in cytoplasm in bud/mother
for k=1:n
    for i=1:length(RatioCyto{1,k})
        if RatioCyto{1,k}(i,1)==0
        else
            RC{1,i}=[RC{1,i},RatioCyto{1,k}(i,1)];
        end
    end
end
for i=1:nbFrames
    meanRC(1,i)=mean(RC{1,i}(1,:));
    stdRC(1,i)=std(RC{1,i}(1,:));
    errorRC(1,i)=std(RC{1,i}(1,:))/sqrt(numel(RC{1,i}(1,:)));
    
end




colors={'b','k','r','c','m','g','y','b','k','r','c','m','g','y'};
xLab={'time (frame)','time (frame)','time (frame)','time (min)','time (frame)','time (frame)'};
yLab={'Number of foci in bud versus in mother','Total Fluo of foci in bud versus in mother','Number of foci per unit of volume in bud versus in mother','Total Fluo of foci per unit of volume in bud versus in mother','Retention efficiency of foci','Retetion efficiency of fluorescence in foci'};
if display
    
    for z=1:6
        figure;
        hold on;
        for k=1:n
            plot([1:1:length(Ratio{z,k}(:,1))],Ratio{z,k}(:,1),'Color',colors{k});
            xlabel(xLab{z});
            ylabel(yLab{z});
            %title(Title{z});
        end
        hold off;
    end
    
    for z=1:6
        if z==4
            figure;
            hold on;
            errorbar([1:1:nbFrames]*3,meanRatio(z,:),errorRatio(z,:));
            if z==3
                plot([1:1:nbFrames],sum(NbFoci,2)./sum(NbCell,2),'r-');
            end
            xlabel(xLab{z});
            ylabel(yLab{z});
            %title(Title{z});
            hold off;
        end
    end
    
    
    
    figure;
    hold on;
    for k=1:n
        plot([1:1:length(Ratio{4,k}(:,1))],Ratio{4,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('ratio of fluo in foci per unit of volume in bud versus mother');
        %title(Title{z});
    end
    hold off;
    
    figure;
    hold on;
    for k=1:n
        plot([1:1:length(RatioCyto{1,k}(:,1))],RatioCyto{1,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('ratio of fluo-background in cyto in bud versus mother');
        %title(Title{z});
    end
    hold off;
    figure;
    hold on;
    errorbar([1:1:length(meanRC)],meanRC,stdRC);
    xlabel('frame');
    ylabel('ratio of fluo-background in cyto in bud versus mother');
    hold off;
    
    
    
    figure;
    hold on;
    for k=a:n
        plot([1:1:length(TotFluo{1,k}(:,1))],TotFluo{1,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('fluorescence total in bud+mother');
        %title(Title{z});
    end
    hold off;
    
    figure;
    hold on;
    for k=a:n
        plot([1:1:length(TotFluo{2,k}(:,1))],TotFluo{2,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('concentration of fluorescence total in bud+mother');
        %title(Title{z});
    end
    hold off;
    
    figure;
    hold on;
    for k=a:n
        plot([1:1:length(TotFluoFoci{1,k}(:,1))],TotFluoFoci{1,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('fluorescence total in foci (bud+mother)');
        %title(Title{z});
    end
    hold off;
    
    figure;
    hold on;
    for k=a:n
        plot([1:1:length(TotFluoFoci{2,k}(:,1))],TotFluoFoci{2,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('concentration of fluorescence total in foci (bud+mother)');
        %title(Title{z});
    end
    hold off;
    
    figure;
    hold on;
    for k=a:n
        plot([1:1:length(TotFluoCyto{1,k}(:,1))],TotFluoCyto{1,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('fluorescence total in cyto (bud+mother)');
        %title(Title{z});
    end
    hold off;
    
    figure;
    hold on;
    for k=a:n
        plot([1:1:length(TotFluoCyto{2,k}(:,1))],TotFluoCyto{2,k}(:,1),'Color',colors{k});
        xlabel('frame');
        ylabel('concentration of fluorescence total in cyto (bud+mother)');
        %title(Title{z});
    end
end
hold off;
xmin=0;
xmax=45;
ymin=0;
ymax=2;

% for i=1:n;
%     a=i;
%     %figure;
%     subplot(4,4,i);
%     hold on;
%     for k=a:a
%         %plot([1:1:length(MotherCyto{2,k}(:,1))],MotherCyto{2,k}(:,1),'r');
%         plot([1:1:length(MotherFoci{2,k}(:,1))],MotherFoci{2,k}(:,1),'b');
%         %plot([1:1:length(DaughterCyto{2,k}(:,1))],DaughterCyto{2,k}(:,1),'g');
%         plot([1:1:length(DaughterFoci{2,k}(:,1))],DaughterFoci{2,k}(:,1),'k');
%         plot([1:1:length(DaughterFoci{2,k}(:,1))],DaughterFoci{2,k}(:,1)./MotherFoci{2,k}(:,1),'m');
%         plot([1:1:length(DaughterFoci{2,k}(:,1))],DaughterCyto{2,k}(:,1)./MotherCyto{2,k}(:,1),'y');
%         xlim([xmin xmax]);
%         ylim([ymin ymax]);
%         xlabel('frame');
%         ylabel('concentration of fluorescence');
%         %legend('Mother cyto','Mother foci','Daughter cyto','Daughter foci','ratio D/M foci','ratio D/M cyto');
%         %legend('Mother foci','Daughter foci','ratio D/M foci','ratio D/M cyto');
%         title(strcat('cell ',num2str(motherhood(1,a)),'vi=',num2str(VolRatio{1,k}(4,1))));
%     end
%     hold off;
% end

% figure;
% for i=1:n;
%     a=i;
%     %figure;
%     subplot(4,4,i);
%     hold on;
%     for k=a:a
%         plot([1:1:length(MotherNb{1,k}(:,1))],MotherNb{1,k}(:,1),'m');
%         plot([1:1:length(DaughterNb{1,k}(:,1))],DaughterNb{1,k}(:,1),'b');
%         xlim([xmin xmax]);
%         ylim([ymin ymax]);
%         xlabel('frame');
%         ylabel('concentration of fluorescence');
%         %legend('Mother cyto','Mother foci','Daughter cyto','Daughter foci','ratio D/M foci','ratio D/M cyto');
%         legend('Mother foci nb','Daughter foci nb');
%         title(strcat('cell ',num2str(motherhood(1,a)),'vi=',num2str(VolRatio{1,k}(4,1))));
%     end
%     hold off;
% end



% for i=1:n;
%     a=i;
%     figure;
%     hold on;
%     for k=a:a
%         plot([1:1:length(MotherNb{1,k}(:,1))],MotherNb{1,k}(:,1),'m');
%         plot([1:1:length(DaughterNb{1,k}(:,1))],DaughterNb{1,k}(:,1),'b');
%         %         xlim([xmin xmax]);
%         %         ylim([ymin ymax]);
%         xlabel('frame');
%         ylabel('concentration of fluorescence');
%         %legend('Mother cyto','Mother foci','Daughter cyto','Daughter foci','ratio D/M foci','ratio D/M cyto');
%         legend('Mother foci nb','Daughter foci nb');
%         title(strcat('cell ',num2str(motherhood(1,a)),'vi=',num2str(VolRatio{1,k}(4,1))));
%     end
%     hold off;
% end


% for i=1:n;
%     a=i;
%     figure;
%     hold on;
%     for k=a:a
%         %plot([1:1:length(MotherCyto{2,k}(:,1))],MotherCyto{2,k}(:,1),'b');
%         plot([1:1:length(MotherFoci{2,k}(:,1))],MotherFoci{2,k}(:,1),'r');
%         %plot([1:1:length(DaughterCyto{2,k}(:,1))],DaughterCyto{2,k}(:,1),'k');
%         plot([1:1:length(DaughterFoci{2,k}(:,1))],DaughterFoci{2,k}(:,1),'g');
%         plot([1:1:length(DaughterFoci{2,k}(:,1))],DaughterFoci{2,k}(:,1)./MotherFoci{2,k}(:,1),'b');
%         %plot([1:1:length(DaughterFoci{2,k}(:,1))],DaughterCyto{2,k}(:,1)./MotherCyto{2,k}(:,1),'y');
%         %         xlim([xmin xmax]);
%         %         ylim([ymin ymax]);
%         xlabel('frame');
%         ylabel('concentration of fluorescence');
%         %legend('Mother cyto','Mother foci','Daughter cyto','Daughter foci','ratio D/M foci','ratio D/M cyto');
%         %legend('Mother foci','Daughter foci','ratio D/M foci','ratio D/M cyto');
%         legend('Foci in mother','Foci in Daughter','ratio Daughter/Mother');
%         title(strcat('cell ',num2str(motherhood(1,a)),'vi=',num2str(VolRatio{1,k}(4,1))));
%     end
%     hold off;
% end




% Rat=cell(2,n);
% RatM=cell(2,nbFrames);
% % meanRatM=zeros(2,nbFrames);
% stdRatM=zeros(2,nbFrames);
% errorRatM=zeros(2,nbFrames);
% for k=1:n
%     Rat{1,k}(:,1)=DaughterFoci{1,k}(:,1)./MotherFoci{1,k}(:,1);
%     Rat{2,k}(:,1)=DaughterFoci{2,k}(:,1)./MotherFoci{2,k}(:,1);
% end
%
% for z=1:2
%     for k=1:n
%         for i=1:length(Rat{z,k})
%             RatM{z,i}=[RatM{z,i},Rat{z,k}(i,1)];
%         end
%     end
% end
% for z=1:2
%     for i=1:nbFrames
%         meanRatM(z,i)=mean(RatM{z,i}(1,:));
%         stdRatM(z,i)=std(RatM{z,i}(1,:));
%         errorRatM(z,i)=std(RatM{z,i}(1,:))/sqrt(numel(RatM{z,i}(1,:)));
%
%     end
% end
%
% figure;
% hold on;
% errorbar([1:1:length(meanRatM(2,:))],meanRatM(2,:),errorRatM(2,:));
% xlabel('frame');
% ylabel('ratio of concentration of fluo in foci in bud versus mother');
% hold off;


% R1=cell(1,3);
% R2=cell(1,2);
% M1=cell(1,3);
% D1=cell(1,3);
% M2=cell(1,2);
% D2=cell(1,2);
%
% for k=1:n
%     if length(Ratio{4,k})>=8;
%         for i=6:8
%             R1{1,i-5}=[R1{1,i-5},Ratio{4,k}(i,1)];
%             M1{1,i-5}=[M1{1,i-5},MotherFoci{2,k}(i,1)];
%             D1{1,i-5}=[D1{1,i-5},DaughterFoci{2,k}(i,1)];
%         end
%
%     else
%         for i=6:length(Ratio{4,k})
%             R1{1,i-5}=[R1{1,i-5},Ratio{4,k}(i,1)];
%             M1{1,i-5}=[M1{1,i-5},MotherFoci{2,k}(i,1)];
%             D1{1,i-5}=[D1{1,i-5},DaughterFoci{2,k}(i,1)];
%         end
%     end
%     if length(Ratio{4,k})>10;
%         cc=1;
%         for i=length(Ratio{4,k})-1:length(Ratio{4,k})
%             R2{1,cc}=[R2{1,cc},Ratio{4,k}(i,1)];
%             M2{1,cc}=[M2{1,cc},MotherFoci{2,k}(i,1)];
%             D2{1,cc}=[D2{1,cc},DaughterFoci{2,k}(i,1)];
%             cc=cc+1;
%         end
%
%     end
% end
%
% R1tot=[];
% R2tot=[];
% M1tot=[];
% M2tot=[];
% D1tot=[];
% D2tot=[];
%
% for i=1:3
%     TF = isnan(R1{1,i});
%     TF=1-TF;
%     a=find(TF==1);
%     R1tot=[R1tot,R1{1,i}(1,a)];
%     M1tot=[M1tot,M1{1,i}(1,a)];
%     D1tot=[D1tot,D1{1,i}(1,a)];
% end
%
% for i=1:2
%     TF = isnan(R2{1,i});
%     TF=1-TF;
%     a=find(TF==1);
%     R2tot=[R2tot,R2{1,i}(1,a)];
%     M2tot=[M2tot,M2{1,i}(1,a)];
%     D2tot=[D2tot,D2{1,i}(1,a)];
% end
% R1tot=transpose(R1tot);
% R2tot=transpose(R2tot);
% figure;boxplot([R1tot],'notch','on');
% figure;boxplot([R2tot],'notch','on');
%
% d(3,1)=mean(R1tot);
% e(3,1)=std(R1tot)/sqrt(length(R1tot));
% d(6,1)=mean(R2tot);
% e(6,1)=std(R2tot)/sqrt(length(R2tot));
%
% d(1,1)=mean(M1tot);
% e(1,1)=std(M1tot)/sqrt(length(M1tot));
% d(4,1)=mean(M2tot);
% e(4,1)=std(M2tot)/sqrt(length(M2tot));
%
% d(2,1)=mean(D1tot);
% e(2,1)=std(D1tot)/sqrt(length(D1tot));
% d(5,1)=mean(D2tot);
% e(5,1)=std(D2tot)/sqrt(length(D2tot));
% handles = barweb(d, e, [], [], [], [], [], jet, [], 'bla', 1, 'axis');



figure;
hold on;
    plot([1:1:nbFrames]*3,sum(NbFoci,2)./sum(NbCell,2),'r-');  

title('Evolution of number and area of foci');
xlabel('Time (min)');
ylabel('Number of foci per cell');
%legend('�-fluidics','agar');
%legend1 = legend(ax1,'show');
%set(legend1,'Location','South');       
ax1 = gca;
set(ax1,'YColor','r')

ax2 = axes('Position',get(ax1,'Position'),...
           'YAxisLocation','right',...
           'Color','none',...
           'YColor','b');

line([1:1:nbFrames]*3,sum(AreaFoci,2)./sum(NbFoci,2));
% 'XAxisLocation','top',...
ylabel('Mean Area (pix)');
hold off;

end