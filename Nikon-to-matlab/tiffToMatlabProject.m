function tiffToMatlabProject(folderName,binning,stacks,ID)

global timeLapse
global position
% generate a project that is compatible with phyloCell from tiff files
% created by Nikon NIS software

% binning : array [ 1 2 4 ] where each number corresponds to a channel in
% the movie :

% stacks: array [1 1 3] indicates the number of stacks for each channel in the movie. Performs max
% projections

% nframe: number of frames

% npos: number of of position


% get file path
[pat,nam,ex] = fileparts(folderName);

%get nframes and npos
listing = dir(folderName);
lastname=listing(end,1).name;
clear listing;
t=strfind(lastname,'t');t=t(1);
y=strfind(lastname,'y');
z=strfind(lastname,'z');
nframes=str2double(lastname(t+1:y-2));
npos=str2double(lastname(y+1:z-1));


channels=length(binning);
nstacks=max(stacks);
midstacks=floor(nstacks/2)+1;

% create timeLapse structure

timeLapse=[];
timeLapse.numberOfFrames=nframes;
timeLapse.currentFrame=nframes;
timeLapse.interval=600; % to be determined later
timeLapse.sequencer=[];
timeLapse.seqFrame=[];

%timeLapse.path=['/Volumes/charvin1/Camille/test2', '/'];
timeLapse.path=[nam , '/'];
timeLapse.filename=nam;
timeLapse.realPath=timeLapse.path;
timeLapse.realName=timeLapse.filename;

%timeLapse.startedDate=datestr(now);
%timeLapse.startedClock=clock;

timeLapse.comments='This project was converted from tiff Nikon file';
timeLapse.status='done';

for i=1:channels
    
    timeLapse.list(i).ID= ID(i);
    im=imread([folderName,'/t001xy01z',num2str(midstacks),'c',num2str(i),'.tif']);
    s=size(im);
    
    timeLapse.list(i).videoResolution(1)=s(1);
    timeLapse.list(i).videoResolution(2)=s(2);
    
    if i==1
        timeLapse.list(i).phaseFluo=2;
    else
        timeLapse.list(i).phaseFluo=5;
    end
    timeLapse.list(i).setLowLevel=0;
    timeLapse.list(i).setHighLevel=0;
    timeLapse.list(i).filterCube=i+1;
    timeLapse.list(i).binning=binning(i);
end

position=[];
position.list=[];

for i=1:npos
    position.list(i).name='';
    position.list(i).timeLapse.list=timeLapse.list;
end

timeLapse.position=position;

%cd(timeLapse.realPath);

createTimeLapseDirectory();

%phy_saveProject(timeLapse.path,'BK-project.mat');
%phy_saveProject(timeLapse.path,[timeLapse.filename '-project.mat']);

localTimeLapse=timeLapse;


im=imread([folderName,'/t001xy01z',num2str(midstacks),'c1.tif']);
% s=size(im);
% width=s(1);
% height=s(2);

%projarr=zeros(width,height,channels,nstacks);


nzerfr=max(3,length(num2str(nframes)));
nzerfrRead=length(num2str(nframes));
nzerposRead=length(num2str(npos));

for pos=1:npos
    fprintf('Reading position #%d', pos);     fprintf('\n    ');
    posnumber=num2str(pos);
    for jk=1:nzerposRead
        if (numel(posnumber)<nzerposRead)
            posnumber=strcat('0',posnumber);
        end
    end
    dirpos=strcat(timeLapse.filename,'-pos',num2str(pos));
    path2=strcat(timeLapse.path,dirpos,'/');
    for ch=1:channels
        chpos=strcat(timeLapse.filename,'-pos',num2str(pos),'-ch',num2str(ch),'-',localTimeLapse.list(ch).ID);
        fullpath=strcat(path2,chpos,'/');
        for frame=1:nframes
            framenumber=num2str(frame);
            for jk=1:nzerfr
                if (numel(framenumber)<nzerfr)
                    framenumber=strcat('0',framenumber);
                end
            end
            framenumberRead=num2str(frame);
            for jk=1:nzerfrRead
                if (numel(framenumberRead)<nzerfrRead)
                    framenumberRead=strcat('0',framenumberRead);
                end
            end
            if stacks(ch)==1
                im=imread([folderName,'/t',framenumberRead,'xy',posnumber,'z',num2str(midstacks),'c',num2str(ch),'.tif']);
            else
                A=zeros(timeLapse.list(ch).videoResolution(1),timeLapse.list(ch).videoResolution(1),nstacks);
                for st=1:stacks(ch)
                    image=imread([folderName,'/t',framenumberRead,'xy',posnumber,'z',num2str(st),'c',num2str(ch),'.tif']);
                    A(:,:,st)=image;
                end
                clear im;
                im(:,:)=max(A,[],3);
            end
            im=uint16(im);
            if binning(ch)~=1
                im = imresize(im,1/binning(ch));
            end
            destination=strcat(fullpath,timeLapse.filename,'-pos',num2str(pos),'-ch',int2str(ch),'-',localTimeLapse.list(ch).ID,'-',framenumber,'.jpg');
            imwrite(im,destination{1},'BitDepth',16,'Mode','lossless');
            fprintf('.');
        end
    end
    fprintf('\n    ');
end

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
        fullpath=strcat(path2,'/',chpos);
        class(fullpath);
        mkdir(fullpath{1});
        
        timeLapse.pathList.channels(i,j)=cellstr(strcat(dirpos,'/',chpos,'/'));
        timeLapse.pathList.names(i,j)=cellstr(chpos);
    end
end

warning on all

