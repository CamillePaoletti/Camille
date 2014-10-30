function maxProjectionMultiTest(n)
%Camille Paoletti - 04/2012
%n=nombre de pas testés

global timeLapse;

fprintf('doing max projection... \n');

for j=1:numel(timeLapse.position.list)
    for k=1:numel(timeLapse.list)
        if timeLapse.list(1,k).enableZStacks
            for m=1:n
                mkdir(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection-',num2str(m)));
            end
            mkdir(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection-none'));
            mkdir(strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection-Stacks3With1µmStep'));
        end
    end
end

for j=1:numel(timeLapse.position.list)
    for i=1:timeLapse.currentFrame
        for k=1:numel(timeLapse.list)
            if timeLapse.list(1,k).enableZStacks
                for m=1:n
                    nb=floor(timeLapse.list(1,k).ZStackNumber/m);
                    am=floor(timeLapse.list(1,k).ZStackNumber/2)+1;
                    if mod(nb,2)
                        x=[am-floor((nb-1)/2*m):m:am+floor((nb-1)/2)*m];
                    else
                        x=[am+1-floor((nb-1)/2*m):m:am+1+floor((nb-1)/2)*m];
                    end
                    A=zeros(1000/timeLapse.list(1,k).binning,1000/timeLapse.list(1,k).binning,length(x));
                    fprintf('position:%2.0f ; frame:%2.0f ; channel:%2.0f ; m:%2.0f ; Asize:%2.0f ; xLength:%2.0f \n',j,i,k,m,size(A,3),length(x))
                    for l=x%=1:floor(timeLapse.list(1,k).ZStackNumber)
                        [image,fullpath]=loadTimeLapseStackImage(j,i,k,l);
                        %printf('%s \n',fullpath);
                        [pathstr, name, ext, versn] = fileparts(fullpath);
                        A(:,:,l)=image;
                    end
                    B(:,:)=max(A,[],3);
                    Name = strsplit('-st', name);
                    imwrite(uint16(B),strcat(pathstr,'-projection-',num2str(m),'\',Name{1,1},'.jpg'), 'Bitdepth',16);
                    fprintf('%s \n' , strcat(pathstr,'-projection-',num2str(m),'\',Name{1,1},'.jpg'));
                    fprintf('.');
                end
                
                %no projection
                A=zeros(1000/timeLapse.list(1,k).binning,1000/timeLapse.list(1,k).binning,1);
                [image,fullpath]=loadTimeLapseStackImage(j,i,k,am);
                [pathstr, name, ext, versn] = fileparts(fullpath);
                A(:,:,1)=image;
                B(:,:)=max(A,[],3);
                Name = strsplit('-st', name);
                imwrite(uint16(B),strcat(pathstr,'-projection-none','\',Name{1,1},'.jpg'), 'Bitdepth',16);
                fprintf('.');
                
                %projection 3 stacks w/ 1µm step
                A=zeros(1000/timeLapse.list(1,k).binning,1000/timeLapse.list(1,k).binning,3);
                for l=[7,11,15]
                    [image,fullpath]=loadTimeLapseStackImage(j,i,k,l);
                    %printf('%s \n',fullpath);
                    [pathstr, name, ext, versn] = fileparts(fullpath);
                    A(:,:,l)=image;
                end
                B(:,:)=max(A,[],3);
                Name = strsplit('-st', name);
                imwrite(uint16(B),strcat(pathstr,'-projection-Stacks3With1µmStep','\',Name{1,1},'.jpg'), 'Bitdepth',16);
                fprintf('.');
                
            else
            end
            %fprintf('no z-stacks \n');
        end
    end
end


% deltaT=timeLapse.interval/60;
%
% fprintf('building movies while you are having a nap... \n');
%
% for j=1:numel(timeLapse.position.list)%j: position
%     for k=1:numel(timeLapse.list)%k: channel
%         [pathstr, name, ext, versn] = fileparts(fileparts(cell2mat(timeLapse.pathList.channels(j,k))));
%
%         if timeLapse.list(1,k).enableZStacks
%             for m=1:n
%                 filename=strcat(timeLapse.realPath,fileparts(cell2mat(timeLapse.pathList.channels(j,k))),'-projection-',num2str(m));
%                 filesave=strcat(timeLapse.realPath,name,'-projection-',num2str(m));
%                 lowLevel=500;
%                 highLevel=1500;
%                 binning=timeLapse.list(1,k).binning;
%                 makeAviMovieFromUint16Jpg(filename,filesave,deltaT,lowLevel,highLevel,binning);
%                 fprintf('.');
%             end
%         else
%             filename=strcat(timeLapse.realPath,cell2mat(timeLapse.pathList.channels(j,k)));
%             filesave=strcat(timeLapse.realPath,name);
%             lowLevel=800;%600
%             highLevel=2500;%1000
%             binning=timeLapse.list(1,k).binning;
%             makeAviMovieFromUint16Jpg(filename,filesave,deltaT,lowLevel,highLevel,binning);
%             fprintf('.');
%
%         end
%     end
% end
%
% fprintf('\n time to wake up! \n');

end
