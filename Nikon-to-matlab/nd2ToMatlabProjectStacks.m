function r=nd2ToMatlabProject(fileName,binning,stacks,option)
global projarr timeLapse
% generate a project that is compatible with phyloCell from ND2 files
% created by Nikon NIS software

% binning : array [ 1 2 4 ] where each number corresponds to a channel in
% the movie :

% stacks : array [1 1 3] indicates the number of stacks for each channel in the movie. Performs max
% porjections

if nargin==4
    if ~exist('javitools.AVITools', 'class')
        p = mfilename('fullpath');
        [p f e]=fileparts(p);
        javaaddpath([p '/javitools.jar']);
    end
end

return;

%phy_saveProject(timeLapse.path,'BK-project.mat');
%phy_saveProject(timeLapse.path,[timeLapse.filename '-project.mat']);

localTimeLapse=timeLapse;

timing=[]; intens=zeros(meta.channels,2); count=0;



curpos=1;
projarr=zeros(meta.width,meta.height,meta.channels,to);

cc=1;
for k=1:npos
    
    fprintf('Reading position #%d', k);     fprintf('\n    ');
    
    for l=1:meta.nframes
        
        curstack=1;
        for s=k*nstacks-2:(k+1)*nstacks-3
            r.setSeries(s - 1);
            pixelType = r.getPixelType();
            bpp = loci.formats.FormatTools.getBytesPerPixel(pixelType);
            bppMax = power(2, bpp * 8);
            numImages = r.getImageCount();
            
            for i = 1:numImages
                
               % k,l,s,i
               
                zct = r.getZCTCoords(i - 1);
                
                qci=zct(2) + 1; % channel index
                qti=zct(3) + 1; % frame index
                
                if qti==l % find the right timing
                    
                    arr = bfGetPlane(r, i);
                    
                    if mod(cc, 72) == 1
                        fprintf('\n    ');
                    end
                    
                    fprintf('.');
                    
                    projarr(:,:,qci,curstack)=arr;
                    
                    cc=cc+1;
                   % figure, imshow(arr,[]);
                    
                end
                %pause
            end
            curstack=curstack+1;
        end
        
        for ch=1:meta.channels
            
        dirpos=strcat(timeLapse.filename,'-pos',num2str(k));
        chpos=strcat(timeLapse.filename,'-pos',num2str(k),'-ch',num2str(ch),'-',localTimeLapse.list(ch).ID);
        path2=strcat(timeLapse.path,dirpos,'/');
        fullpath=strcat(path2,chpos,'/');

        framenumber=num2str(l);
        
        nzer=max(3,length(num2str(meta.nframes)));
        
        for jk=1:nzer
            if (numel(framenumber)<nzer)
                framenumber=strcat('0',framenumber);
            end
        end
        
        
        destination=strcat(fullpath,timeLapse.filename,'-pos',num2str(k),'-ch',int2str(ch),'-',localTimeLapse.list(ch).ID,'-',framenumber,'.jpg');
        
        arrI=uint16(max(projarr(:,:,ch,:),[],4));
        
        
        if binning(ch)~=1
           arrI = imresize(arrI,1/binning(ch));
        end
        
        
        imwrite(arrI,destination,'BitDepth',16,'Mode','lossless');
        
        end
        
        
    end
    
    fprintf('\n    ');
end

            
           

r.close();

%timing=round(mean(diff(timing)));
%timeLapse.interval=timing;

%for i=1:numel(timeLapse.list)
%    timeLapse.list(i).setLowLevel=65535*intens(i,1);
%    timeLapse.list(i).setHighLevel=65535*intens(i,2);
%end

save([timeLapse.path,'/' timeLapse.filename '-project.mat'],'timeLapse','position');
save([timeLapse.path,'/BK-project.mat'],'timeLapse','position');

%%% optional : build movies using expert montage
% if nargin==2
%     
%     str='0 0 0 0';
%     
%     for i=1:numel(timeLapse.list)
%         if strcmp(timeLapse.list(i).ID,'DAPI')
%             str(1)=num2str(i);
%         end
%         if strcmp(timeLapse.list(i).ID,'Mcherry')
%             str(3)=num2str(i);
%         end
%         if strcmp(timeLapse.list(i).ID,'GFP')
%             str(5)=num2str(i);
%         end
%     end
%     
%     exportMontage('', timeLapse.filename, 1:numel(position.list), {str}, [], 0, []);
% end




function createTimeLapseDirectory()
global timeLapse;
global position;

warning off all

if (numel(position.list)==0)
    maxpos=1 ;
    localTimeLapse=timeLapse;
else
    maxpos=numel(position.list);
end

for i=1:maxpos
    
    if (numel(timeLapse.list)~=numel(position.list(i).timeLapse.list))
        localTimeLapse=position.list(i).timeLapse;
    else
        localTimeLapse=timeLapse;
    end
    
    dirpos=strcat(timeLapse.filename,'-pos',int2str(i));
    
    if isdir(strcat(timeLapse.path,dirpos))
        rmdir(strcat(timeLapse.path,dirpos),'s') ;
    end
    
    mkdir(timeLapse.path,dirpos);
    timeLapse.pathList.position(i)=cellstr(strcat(dirpos,'/'));
    
    for j=1:numel(localTimeLapse.list)
        chpos=strcat(timeLapse.filename,'-pos',int2str(i),'-ch',int2str(j),'-',localTimeLapse.list(j).ID);
        
        path2=strcat(timeLapse.path,dirpos);
        fullpath=strcat(path2,chpos);
        mkdir(path2,chpos);
        
        timeLapse.pathList.channels(i,j)=cellstr(strcat(dirpos,'/',chpos,'/'));
        timeLapse.pathList.names(i,j)=cellstr(chpos);
    end
end

warning on all

