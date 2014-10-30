function [] = makeSegmentation(filePath,level)
%Camille - 08/2012
%set segmentation channels values and makeTimeLapseMontageMovies

if nargin==0
else
    load(filePath)
end

global timeLapse;
global segmentation;

fprintf('loading %s\n',timeLapse.filename);


warning off all;


for position=1:numel(timeLapse.position.list);
    
    fprintf('position %s\n',num2str(position));
    timeLapsepath=timeLapse.realPath;
    timeLapsefile=[timeLapse.filename '-project.mat'];
    str=strcat(timeLapse.realPath,timeLapse.filename,'-pos',num2str(position),'/segmentation.mat');
    delete(str);
    [segmentation timeLapse]=phy_openSegmentationProject(timeLapsepath,timeLapsefile,position,[1 2 3]);
    segmentation.parametres.trackSingleCells=0;
    %segmentation=phy_createSegmentation(timeLapse,position);
    
    segmentation.colorData=[1,1,1,0.01,0.1,1;0,1,0,0.0078,0.03,1;1,0,0,0.01,0.012,1];
    for i=segmentation.channels
        timeLapse.list(1,i).setLowLevel=segmentation.colorData(i,4)*2^16;
        timeLapse.list(1,i).setHighLevel=segmentation.colorData(i,5)*2^16;
    end
    
    segmentation.processing.selectedProcess=[3 5 6 1 1];
    segmentation.colorData=[1,1,1,0.00,level,1;0,1,0,0.0078,0.03,1;1,0,0,0.01,0.012,1];
    segmentation.sizeImageMax=[1000 1000];
    
    %%%%%% segment cells %%%%%%%
        fprintf('segmenting cells\n');
        segmentation.processing.selectedFeature=1;
        clear param;
        param{1,2}=1;
        param{2,2}=40;
        param{3,2}=500;
        param{4,2}=10000;
        param{5,2}=0;
        param{6,2}=150;
        param{7,2}=1;
        param{8,2}=0.04;
        param{9,2}=0.2;
        param{10,2}=0;
        param{11,2}=1;
        param{12,2}=0;
        for i=1:length(param)
         segmentation.processing.parameters{segmentation.processing.selectedFeature,segmentation.processing.selectedProcess(segmentation.processing.selectedFeature)}{i,2}=param{i,2};
        end
        parametres=segmentation.processing.parameters(segmentation.processing.selectedFeature,segmentation.processing.selectedProcess(segmentation.processing.selectedFeature));
        parametres=parametres{1,1};
    
        for frame=1:timeLapse.numberOfFrames
            fprintf('frame %s / %d \n',num2str(frame),timeLapse.numberOfFrames);
            [image]=phy_loadTimeLapseImage(position,frame,parametres{1,2});
            segmentation.cells1(frame,:)=phy_Object;
            celltemp=phy_segmentCellsOmothetie(image,parametres);
            % discard ghost cells
            i=1;
            cell=phy_Object;
            for l=1:length(celltemp)
                if celltemp(l).n~=0
                    xf=celltemp(l).x;
                    yf=celltemp(l).y;
                    if polyarea(xf,yf)>param{3,2} && polyarea(xf,yf)<param{4,2}  %area cutoff
                        cell(i)=celltemp(l);
                        cell(i).n=i;
                        i=i+1;
                    end
                end
            end
            %
            for l=1:length(cell)
                cell(l).image=frame;
                %                     if get(handles.checkbox_Use_Cropped_Image,'value')
                %                         cell(l).x=cell(l).x+ax(1)-1;
                %                         cell(l).y=cell(l).y+ax(3)-1;
                %                         cell(l).ox=cell(l).ox+ax(1)-1;
                %                         cell(l).oy=cell(l).oy+ax(3)-1;
                %                     end
                segmentation.cells1(frame,l)=cell(l);
            end
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%% segment budnecks %%%%%%%
    fprintf('segmenting budnecks\n');
    segmentation.processing.selectedFeature=2;
    clear param;
    param{1,2}=3;
    param{2,2}=20;
    param{3,2}=1000;
    param{4,2}=20;
    param{5,2}=0;
    
    for i=1:length(param)
        segmentation.processing.parameters{segmentation.processing.selectedFeature,segmentation.processing.selectedProcess(segmentation.processing.selectedFeature)}{i,2}=param{i,2};
    end
   
    parametres=segmentation.processing.parameters(segmentation.processing.selectedFeature,segmentation.processing.selectedProcess(segmentation.processing.selectedFeature));
    parametres=parametres{1,1};
    
    for frame=1:timeLapse.numberOfFrames
        fprintf('frame %s / %d \n',num2str(frame),timeLapse.numberOfFrames);
        [image]=phy_loadTimeLapseImage(position,frame,parametres{1,2});
        image=imresize(image,segmentation.sizeImageMax);
        segmentation.budnecks(frame,:)=phy_Object;
        budnecktemp=phy_segmentBudneck(image,param);
        % discard ghost objects
        i=1;
        budneck=phy_Object;
        for l=1:length(budnecktemp)
            if budnecktemp(l).n~=0
                budneck(i)=budnecktemp(l);
                budneck(i).n=i;
                i=i+1;
            end
        end
        
        for j=1:length(budneck)
            budneck(j).image=frame;
            %             if get(handles.checkbox_Use_Cropped_Image,'value')
            %                 budneck(j).x=budneck(j).x+ax(1)-1;
            %                 budneck(j).y=budneck(j).y+ax(3)-1;
            %                 budneck(j).ox=budneck(j).ox+ax(1)-1;
            %                 budneck(j).oy=budneck(j).oy+ax(3)-1;
            %             end
            segmentation.budnecks(frame,j)=budneck(j);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%% segment foci %%%%%%%
    fprintf('segmenting foci\n');
    segmentation.processing.selectedFeature=3;
    clear param;
    param{1,2}=2;
    param{2,2}=20;
    param{3,2}=1000;
    param{4,2}=5;
    param{5,2}=105;
    
    for i=1:length(param)
        segmentation.processing.parameters{segmentation.processing.selectedFeature,segmentation.processing.selectedProcess(segmentation.processing.selectedFeature)}{i,2}=param{i,2};
    end
    
    for frame=1:timeLapse.numberOfFrames
        fprintf('frame %s / %d \n',num2str(frame),timeLapse.numberOfFrames);
        [image]=phy_loadTimeLapseImage(position,frame,param{1,2});
        image=imresize(image,segmentation.sizeImageMax);
        segmentation.foci(frame,:)=phy_Object;
        budnecktemp=phy_segmentFoci(image,param);
        % discard ghost objects
        i=1;
        budneck=phy_Object;
        for l=1:length(budnecktemp)
            if budnecktemp(l).n~=0
                budneck(i)=budnecktemp(l);
                budneck(i).n=i;
                i=i+1;
            end
        end
        
        for j=1:length(budneck)
            budneck(j).image=segmentation.frame1;
            %             if get(handles.checkbox_Use_Cropped_Image,'value')
            %                 budneck(j).x=budneck(j).x+ax(1)-1;
            %                 budneck(j).y=budneck(j).y+ax(3)-1;
            %                 budneck(j).ox=budneck(j).ox+ax(1)-1;
            %                 budneck(j).oy=budneck(j).oy+ax(3)-1;
            %             end
            segmentation.foci(frame,j)=budneck(j);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    str=strcat(timeLapse.realPath,timeLapse.filename,'-pos',num2str(position),'/segmentation.mat');
    save(str,'segmentation');
    fprintf('segmentation.mat saved\n');
    
end

str=strcat(timeLapse.realPath,timeLapse.realName);
save(str,'timeLapse');
fprintf('timeLapse.mat saved\n');

warning on all;

end