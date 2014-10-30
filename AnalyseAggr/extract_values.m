function [concat,nNum,areaTot,volumeTot]=extract_values(path,file,position,initFrame, hsFrame, lastFrame,mode)

%Camille Paoletti - 04/2014
%mode='all' or 'hsCells' or 'newCells'
%ex: extract_values('','140314-control-CP03-1',[4],1, 40, 120,'hsCells')

global segmentation timeLapse segList

filen='segmentation-batch.mat';
[timeLapsepath , timeLapsefile]=setProjectPath(path,file);

Data=cell(4,1);
nNum=0;
areaTot=zeros(1,lastFrame-initFrame+1);
volumeTot=zeros(1,lastFrame-initFrame+1);

for l=position
    a=exist('segList');
    if a==0
        [segmentation , timeLapse]=phy_openSegmentationProject(timeLapsepath,timeLapsefile,l,1);%path/file/position/channel/handles
        
    else
        
        strPath=strcat(timeLapsepath,timeLapsefile);
        load(strPath);
        timeLapse.path=timeLapsepath;
        timeLapse.realPath=timeLapsepath;
        
        if exist(fullfile(timeLapse.path,timeLapse.pathList.position{l},filen),'file')
            % 'project already exist'
            load(fullfile(timeLapse.path,timeLapse.pathList.position{l},filen));
            
        else
            segmentation=phy_createSegmentation(timeLapse,l);
            save(fullfile(timeLapse.path,timeLapse.pathList.position{segmentation.position},filen),'segmentation');
        end
        
        [number,fluo,foci,radius,nNum_temp]=compareMeanFociNumber(initFrame, hsFrame, lastFrame,mode,0);
        [area,volume]=computeGrowth(initFrame, hsFrame, lastFrame,0);
        
        a=number(1,:);
        Data{1,1}=horzcat(Data{1,1},a(:));
        a=fluo(1,:);
        Data{2,1}=horzcat(Data{2,1},a(:));
        a=foci(1,:);
        Data{3,1}=horzcat(Data{3,1},a(:));
        a=radius(1,:);
        Data{4,1}=horzcat(Data{4,1},a(:));
        nNum=nNum+nNum_temp;
        areaTot=areaTot+area;
        volumeTot=volumeTot+volume;
        
    end
    
end

n=lastFrame-initFrame+1;
concat=cell(4,n);
for j=1:4
    for i=initFrame:lastFrame
        concat{j,i}=horzcat(Data{j,1}{i,:});
    end
end

end


function [timeLapsepath timeLapsefile]=setProjectPath(path,file)
global timeLapse

%str=strcat(path,file);

%load(str);

timeLapse.realPath=strcat(path);
timeLapse.realName=file;

timeLapsepath=timeLapse.realPath;
timeLapsefile=[timeLapse.filename '-project.mat'];

end