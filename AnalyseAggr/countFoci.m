function Data=countFoci(path,file,position,frames)

global segmentation timeLapse segList

filen='segmentation-batch.mat';
[timeLapsepath , timeLapsefile]=setProjectPath(path,file);

Data=cell(3,3);
% areaTot=zeros(1,lastFrame-initFrame+1);
% volumeTot=zeros(1,lastFrame-initFrame+1);

cc=0;
for i=frames
    cc=cc+1;
    
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
            
            [n,nf,rf]=countFociOnce(i);
            
            a=n(1,:);
            Data{1,cc}=horzcat(Data{1,cc},a(:));
            a=nf(1,:);
            Data{2,cc}=horzcat(Data{2,cc},a(:));
            a=rf(1,:);
            Data{3,cc}=horzcat(Data{3,cc},a(1,:));
            
            
        end
        
    end
    
end

% n=length(frames);
% concat=cell(3,n);
% for j=1:3
%     for i=1:n
%         concat{j,i}=horzcat(Data{j,1}{i,:});
%     end
% end

end


function [n,nf,rf]=countFociOnce(frames)
global segmentation

for i=frames
    ncell=[segmentation.cells1(i,:).n];
    n=length(find(ncell));
    nfoci=[segmentation.foci(i,:).n];
    rf=[segmentation.foci(i,find(nfoci)).area];
    rf=rf(find(rf));
    nf=length(rf);
    rf=sqrt(rf/pi)*0.08;
end

end

function [timeLapsepath, timeLapsefile]=setProjectPath(path,file)
global timeLapse

%str=strcat(path,file);

%load(str);

timeLapse.realPath=strcat(path);
timeLapse.realName=file;

timeLapsepath=timeLapse.realPath;
timeLapsefile=[timeLapse.filename '-project.mat'];

end