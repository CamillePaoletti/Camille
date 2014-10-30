function ComputeFociBatch(option)
%Camille Paoletti (from GC) - 04/2012 // !!! MODIFIED ON 02/2013 with computeFociNew !!! //
%link foci and cell they belong to

global segmentation;
global timeLapse;


%segmentation.budneckChannel=channel;
cc=0;
fprintf(['Processing segmentation ' num2str(cc) ' \n']);


% determine the link between foci and cells numbers
if option==0
    if mean(segmentation.budnecksSegmented)~=0
        %status('Link budnecks to cell contours...',handles);
        phy_linkBudnecksToCells();
    end
end

if nargin==4
    segmentedFrames=frames;
else
    segmentedFrames=find(segmentation.cells1Segmented);%all segemented frames
end

cells1=segmentation.cells1;

tfoci=segmentation.tfoci;
foci=segmentation.foci;



%status('Measure Fluorescence.... Be patient !',handles);

c=0;
phy_progressbar;


%h=figure;

%for all segmented images do the analyse
cc=0;

for i=segmentedFrames
    %fprintf('frame %d\n',i);
    
    %for i=61
    
    c=c+1;
    phy_progressbar(c/length(segmentedFrames));
    
    for l=1:size(segmentation.colorData,1)
        
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
    
    
    if option==0 % cytosplasmic fluorescence scoring
        cells1i=cells1(i,:);
        cells1(i,:)=measureFluorescence(i,imgarr,cells1i,tfoci,segmentation);
    end
    
    if option==1  || option ==2 % foci and mitochondria detection
        
        
        if option==1 % detect foci
            ComputeFoci(imgarr(:,:,segmentation.processing.parameters{3,6}{1,2}),i);
            computeFociNew(imgarr(:,:,segmentation.processing.parameters{3,6}{1,2}),i);
        end
        if option==2 % detect mitochondria
            ComputeMitochondria(imgarr(:,:,segmentation.budneckChannel),i)
        end
        
    end
    
    
    
end

pause(0.1);


save(fullfile(timeLapse.realPath,timeLapse.pathList.position{segmentation.position},'segmentation.mat'),'segmentation');

cc=cc+1;


fprintf(['Processing segmentation done ! \n']);