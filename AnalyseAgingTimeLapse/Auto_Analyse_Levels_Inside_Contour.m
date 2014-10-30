function Auto_Analyse_Levels_Inside_Contour(user)

%loading data bases
load('L:\common\matlab\straindb\db\Data\Common_Data.mat');
%load('E:\Mes documents\MATLAB\phD\straindb\db\Data\Common_Data.mat');
DATA=database;
load('L:\common\matlab\straindb\db\Experiments\Common_Experiments.mat');
%load('E:\Mes documents\MATLAB\phD\straindb\db\Experiments\Common_Experiments.mat');
EXP=database;

%user's path
if strcmp(user,'Gilles')
    path=[];
elseif strcmp(user,'Steffen')
    path=[];
else
    path='L:\common\movies\';
    %path='E:\Mes documents\PhD\';
end

%%extracting data to plot
%all data points
numel=find(str2double(DATA.data(:,7))~=0 & strncmp('1G',DATA.data(:,1),2));
L=length(numel);
str=cell(L,1);
str2=cell(L,1);
str3=cell(L,1);
bud=cell(L,1);
interval=cell(L,1);
for k=1:L
    %creating path corresponding to cell number i (with i: line in database)
    ID=DATA.data(numel(k),1);
    %%%%%%%%Be careful, problem for more than 9*26 experiments!!!%%%%%%%%
    a=find(strncmp(ID,EXP.data(:,1),2));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    experimenter=EXP.data(a,2);
    date=str2double(EXP.data(a,3));
    folder=EXP.data(a,4);
    name=EXP.data(a,5);
    pos=DATA.data(numel(k),2);
    str{k}=strcat(path,experimenter,'\20',num2str(int8(date/1e4)),'\20',num2str(int16(date/1e2)),'\',folder,'\',name,'-pos',pos,'\segmentation.mat');
    str2{k}=strcat(path,experimenter,'\20',num2str(int8(date/1e4)),'\20',num2str(int16(date/1e2)),'\',folder,'\','BK-project.mat');
    %loading segmentation data
    load(str{k}{1});
    load(str2{k}{1});
    
    
    
    
    %-------------------------------------------------------------------------
    % prompt = {'Enter Min pixel value','Enter Max pixel value'};
    % dlg_title = 'Analyse fluorescence inside contours';
    % num_lines = 1;
    % def = {'10','10'};
    % answer = inputdlg(prompt,dlg_title,num_lines,def);
    % if isempty(answer)
    %     return
    % end
    %------------------------------------------------------------------------
    answer={'10','10'};
    
    % determine the link between budnecks and cells numbers
    
    if mean(segmentation.budnecksSegmented)~=0
        %status('Link budnecks to cell contours...',handles);
        phy_linkBudnecksToCells();
    end
    
    
    % compute fluo levels for cells and budnecks
    
    segmentedFrames=find(segmentation.cells1Segmented);%all segemented frames
    cells1=segmentation.cells1;
    budnecks=segmentation.tbudnecks;
    
    %status('Measure Fluorescence.... Be patient !',handles);
    
    c=0;
    phy_progressbar;
    
    
    %h=figure;
    
    %for all segmented images do the analyse
    for i=segmentedFrames
        
        %for i=205
        
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
        
        %create masks and get readouts
        for j=1:length(cells1(i,:))
            if cells1(i,j).n~=0 && ~isempty(cells1(i,j).x)
                mask = poly2mask(cells1(i,j).x,cells1(i,j).y,segmentation.sizeImageMax(1),segmentation.sizeImageMax(2));
                
                budmask=[];
                if length(cells1(i,j).budneck)~=0
                    budmask=zeros(segmentation.sizeImageMax(1),segmentation.sizeImageMax(2));
                    budmasksum=budmask;
                end
                
                for l=1:size(segmentation.colorData,1)
                    img=imgarr(:,:,l);
                    cells1(i,j).fluoMean(l)=mean(img(mask));
                    %  a=cells1(i,j).fluoMean(l)
                    cells1(i,j).fluoVar(l)=var(double(img(mask)));
                    valpix=img(mask);
                    [sorted idx]=sort(valpix,'descend');
                    
                    
                    minpix=min(str2num(answer{1}),length(sorted));
                    maxpix=min(str2num(answer{2}),length(sorted));
                    
                    if length(sorted)~=0
                        cells1(i,j).fluoMin(l)=mean(sorted(length(sorted)-minpix:length(sorted)));
                        cells1(i,j).fluoMax(l)=mean(sorted(1:maxpix));
                    else
                        cells1(i,j).fluoMin(l)=0;
                        cells1(i,j).fluoMax(l)=0;
                    end
                    %sorted
                    %return;
                    
                    
                    %    i,j  ,a=  cells1(i,j).budneck
                    if cells1(i,j).budneck~=0
                        for kl=1:length(cells1(i,j).budneck)
                            
                            
                            ind=cells1(i,j).budneck(kl);
                            fr=i-(budnecks(ind).Obj(1).image-1);
                            
                            budmask=poly2mask(budnecks(ind).Obj(fr).x,budnecks(ind).Obj(fr).y,segmentation.sizeImageMax(1),segmentation.sizeImageMax(2));
                            budmasksum= budmask | budmasksum;
                            
                            budnecks(ind).Obj(fr).fluoMean(l)=mean(img(budmasksum));
                            budnecks(ind).Obj(fr).fluoVar(l)=var(double(img(budmasksum)));
                            budnecks(ind).Obj(fr).fluoMin(l)=0;
                            budnecks(ind).Obj(fr).fluoMax(l)=0;
                            
                            cells1(i,j).fluoNuclMean(l)=mean(img(budmasksum));
                            cells1(i,j).fluoNuclVar(l)=var(double(img(budmasksum)));
                            cells1(i,j).fluoNuclMin(l)=0;
                            cells1(i,j).fluoNuclMax(l)=0;
                            
                            
                        end
                        
                        
                        
                        cytomask= budmask | mask;
                        pix= find(budmask);
                        
                        cytomask(pix)=0;
                        
                        % if j==4
                        % figure(h); imshow(cytomask,[0 1]); title(['frame' num2str(i) 'cell' num2str(j) ]);
                        %return;
                        % end
                        
                        cells1(i,j).fluoCytoMean(l)=mean(img(cytomask));
                        cells1(i,j).fluoCytoVar(l)=var(double(img(cytomask)));
                        cells1(i,j).fluoCytoMin(l)=0;
                        cells1(i,j).fluoCytoMax(l)=0;
                    else
                        
                        cells1(i,j).fluoNuclMean(l)=cells1(i,j).fluoMean(l);
                        cells1(i,j).fluoNuclVar(l)=cells1(i,j).fluoVar(l);
                        cells1(i,j).fluoNuclMin(l)=0;
                        cells1(i,j).fluoNuclMax(l)=0;
                        
                        
                        cells1(i,j).fluoCytoMean(l)=cells1(i,j).fluoMean(l);
                        cells1(i,j).fluoCytoVar(l)=cells1(i,j).fluoVar(l);
                        cells1(i,j).fluoCytoMin(l)=0;
                        cells1(i,j).fluoCytoMax(l)=0;
                        
                    end
                    % in case nuclei are scored separately, this allows to quantify
                    %    fluoCytoMean=0;
                    %    fluoCytoVar=0;
                    %    fluoCytoMin=0;
                    %    fluoCytoMax=0;
                    
                end
            end
        end
        
        
    end
    str3{k}=strcat(path,experimenter,'\20',num2str(int8(date/1e4)),'\20',num2str(int16(date/1e2)),'\',folder,'\',name,'-pos',pos,'\segmentation-test.mat');
    save(str3{k}{1},'segmentation');
end

end  
