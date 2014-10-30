function []=MapCell_HS(initFrame, hsFrame, lastFrame)

%Camille Paoletti - 11/2013 - adapted from phyloCellMainGUI
%Segmentation_MapCell_Callback
%to automatically map cells in three run (before/during/after HS)

global segmentation segList


feat=segmentation.processing.selectedFeature;%feature = cells/foci/budnecks...
proc=9;  %segmentation.processing.selectedProcess(segmentation.processing.selectedFeature);%proc=segment/maping procedures

featname=segmentation.processing.features{feat};

parametres=segmentation.processing.parameters(feat,proc);
parametres=parametres{1,1};

cSeg1=find(segmentation.([featname 'Segmented']));

discard=find(segmentation.discardImage);

cSeg1=setdiff(cSeg1,discard);


if numel(cSeg1)==0
    warndlg('No segmentation done','Mapping error');
    return;
end

%---------------------

frames=[initFrame,hsFrame-1, hsFrame, lastFrame];
param={40,300,40};
disp('Map cells');
tic;

phy_progressbar;
pause(0.1);

cc=0;
ccTot=length(cSeg1)*3;
for j=1:3
    
    startFrame=frames(j);
    endFrame=frames(j+1);
    
    segmentation.([featname 'Mapped'])(startFrame)=1;
    segmentation.frameChanged(startFrame)=1;
    
    for i=1:length(cSeg1)%(endFrame-startFrame)%get(handles.slider1,'Max')
        cc=cc+1;
        phy_progressbar(cc/ccTot);
        
        if cSeg1(i)>startFrame && cSeg1(i)<=endFrame
            x=cSeg1(i);
            
            % map cell cavity in progress
            
            if i>1
                %startFrame,cSeg1(i-1)
                if x==startFrame+1
                    lastObjectNumber=max([segmentation.(featname)(startFrame,:).n]);
                end
                lastObjectNumber=max(lastObjectNumber, max([segmentation.(featname)(cSeg1(i-1),:).n]));
                segmentation.(featname)(x,:)=phy_mapCellsHungarian(segmentation.(featname)(cSeg1(i-1),:),segmentation.(featname)(x,:),lastObjectNumber, param{j}, parametres{3,2},parametres{4,2},parametres{5,2},parametres{6,2});
            end
            
            segmentation.([featname 'Mapped'])(x)=1;
            segmentation.frameChanged(x)=1;
        end
    end
    
    disp('Building tObjects');
    [segmentation.(['t' featname]) fchange]=phy_makeTObject(segmentation.(featname),segmentation.(['t' featname]));
    cur=find([segList.selected]==1);
    segList(cur).s=segmentation;
    
end
phy_progressbar(1);
toc;
phy_check_cells;
disp('Idle');