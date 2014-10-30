function singleProjection(batch)
%Camille Paoletti - 03/2012

global timeLapse;




if batch==1
%     fprintf('doing max projection... \n');
%     
%     for j=1:numel(timeLapse.position.list)
%         for k=1:numel(timeLapse.list)
%             if timeLapse.list(1,k).enableZStacks
%                 mkdir(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection'));
%             end
%         end
%     end
%     
%     for j=1:numel(timeLapse.position.list)
%         for i=1:timeLapse.currentFrame
%             for k=1:numel(timeLapse.list)
%                 if timeLapse.list(1,k).enableZStacks
%                     A=zeros(1000/timeLapse.list(1,k).binning,1000/timeLapse.list(1,k).binning,timeLapse.list(1,k).ZStackNumber);
%                     for l=1:timeLapse.list(1,k).ZStackNumber
%                         [image,fullpath]=loadTimeLapseStackImage(j,i,k,l);
%                         [pathstr, name, ext, versn] = fileparts(fullpath);
%                         A(:,:,l)=image;
%                     end
%                     B(:,:)=max(A,[],3);
%                     Name = strsplit('-st', name);
%                     imwrite(uint16(B),strcat(pathstr,'-projection/',Name{1,1},'.jpg'), 'Bitdepth',16);
%                     fprintf('.');
%                 else
%                     %fprintf('no z-stacks \n');
%                 end
%             end
%         end
%     end
%     
%     fprintf('\n done! \n');
    
else
    [FileName,PathName] = uigetfile('*.mat','Select the M-file');
    load(strcat(PathName,FileName));
    timeLapse.realPath=PathName;
    save(strcat(PathName,FileName),'timeLapse');
    
    fprintf('doing max projection... \n');
    
    for j=1:numel(timeLapse.position.list)
        for k=1:numel(timeLapse.list)
            if timeLapse.list(1,k).enableZStacks
                mkdir(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection'));
                mkdir(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-stacks'));
            end
        end
    end
    
    for j=1:numel(timeLapse.position.list)
        for i=1:timeLapse.currentFrame
            for k=1:numel(timeLapse.list)
                if timeLapse.list(1,k).enableZStacks
                    %A=zeros(1000/timeLapse.list(1,k).binning,1000/timeLapse.list(1,k).binning,timeLapse.list(1,k).ZStackNumber);
                    %for l=1:timeLapse.list(1,k).ZStackNumber
                        %[image,fullpath]=loadTimeLapseStackImage(j,i,k,l);
                        %[pathstr, name, ext, versn] = fileparts(fullpath);
                        %A(:,:,l)=image;
                    %end
                    %B(:,:)=max(A,[],3);
                    l=floor(timeLapse.list(1,k).ZStackNumber/2)+1;
                    [image,fullpath]=loadTimeLapseStackImage(j,i,k,l);
                    [pathstr, name, ext, versn] = fileparts(fullpath);
                    B(:,:,l)=image;
                    Name = strsplit('-st', name);
                    imwrite(uint16(B),strcat(pathstr,'-projection/',Name{1,1},'.jpg'), 'Bitdepth',16);
                    fprintf('.');
                else
                    %fprintf('no z-stacks \n');
                end
            end
        end
    end
    
    for j=1:numel(timeLapse.position.list)
        for k=1:numel(timeLapse.list)
            if timeLapse.list(1,k).enableZStacks
                movefile(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'/'),strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-stacks/'));
                movefile(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection/'),strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'/'));
            end
        end
    end
    
    
    
    fprintf('\n done! \n');
end

end