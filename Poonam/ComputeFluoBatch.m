function ComputeFluoBatch()
%Camille Paoletti (from GC) -  //  !!! from computeFociBatch
%running process :
% 1)Open segmentation project within phyloCell
% 2)>ComputeFluoBatch()

global segmentation;
global timeLapse;


cc=0;
fprintf(['Processing segmentation ' num2str(cc) ' \n']);

segmentedFrames=find(segmentation.cells1Segmented);%all segemented frames

c=0;
phy_progressbar;


%for all segmented images do the analyse

n=segmentation.sizeImageMax;
lend=size(segmentation.colorData,1);
imgarr=zeros(n(1,1),n(1,2),lend);

for i=segmentedFrames
    c=c+1;
    phy_progressbar(c/length(segmentedFrames));
    
    for l=1:lend
        
        %read and scale the fluorescence image from appropriate channel
        
        if segmentation.discardImage(i)==0 % frame is good
            segmentation.frameToDisplay=i;
        else
            temp=segmentation.discardImage(1:i); % frame is discarded by user ; display previous frame
            segmentation.frameToDisplay=max(find(temp==0));
        end
        
        
        img=phy_loadTimeLapseImage(segmentation.position,segmentation.frameToDisplay,l,'non retreat');
        warning off all;
        img=imresize(img,segmentation.sizeImageMax);
        warning on all;
        
        imgarr(:,:,l)=img;
    end
    
    
    for ch=2:3%this corresponds to the list of channels in which the fluo has to be scored
        ComputeFluoPoonam(imgarr(:,:,ch),i,ch);
    end
    
end

pause(0.1);

fprintf(['Processing segmentation done ! \n']);

%save(fullfile(timeLapse.realPath,timeLapse.pathList.position{segmentation.position},'segmentation-batch.mat'),'segmentation');

%cc=cc+1;
fprintf(['segmentation variable saved ! \n']);
end
