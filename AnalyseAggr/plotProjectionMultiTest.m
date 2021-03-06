function [I]=plotProjectionMultiTest(n)
%Camille Paoletti - 04/2012
%n=nombre de pas test�s

global timeLapse;

% for j=1:numel(timeLapse.position.list)
%     for i=1:timeLapse.currentFrame
%         frame=i;
%         for k=1:numel(timeLapse.list)
%             if timeLapse.list(1,k).enableZStacks
%                 %for m=1:n
%                 m=1;
%                     framestr=num2str(frame);
%                     if numel(framestr)==2
%                         framestr=['0' framestr];
%                     end
%                     if numel(framestr)==1
%                         framestr=['00' framestr];
%                     end
%                     %maxProjection
%                     fullpath=strcat(timeLapse.realPath,timeLapse.pathList.channels(j,k),timeLapse.pathList.names(j,k),'-',framestr,'-st',num2str(1),'.jpg');
%                     [pathstr, name, ext, versn] = fileparts(cell2mat(fullpath));
%                     Name = strsplit('-st', name);
%                     A=imread(strcat(pathstr,'-projection-',num2str(m),'\',Name{1,1},'.jpg'));
%                     %focal plane
% %                     fullpath=strcat(timeLapse.realPath,timeLapse.pathList.channels(j,k),timeLapse.pathList.names(j,k),'-',framestr,'-st',num2str(am),'.jpg');
% %                     [pathstr, name, ext, versn] = fileparts(fullpath);
% %                     Name = strsplit('-st', name);
%                     B=imread(strcat(pathstr,'-projection-none','\',Name{1,1},'.jpg'));
%                     %3stacks projection
%                     C=imread(strcat(pathstr,'-projection-Stacks3With1�mStep','\',Name{1,1},'.jpg'));
%                     D=A-C;
%                     E=A-B;
%                     F=C-B;
%                     figure;
%                     subplot(2,3,1);imshow(A,[]);title('maxProj');
%                     subplot(2,3,2);imshow(B,[]);title('focalPlane');
%                     subplot(2,3,3);imshow(C,[]);title('3stacks');
%                     subplot(2,3,4);imshow(A-C,[]);title('A-C');
%                     subplot(2,3,5);imshow(A-B,[]);title('A-B');
%                     subplot(2,3,6);imshow(C-B,[]);title('C-B');
%                 %end
%             end
%
%         end
%     end
% end


% for j=1:numel(timeLapse.position.list)
%     for i=1:timeLapse.currentFrame
%         frame=i;
%         for k=1:numel(timeLapse.list)
%             if timeLapse.list(1,k).enableZStacks
%                 %for m=1:n
%                 m=1;
%                     framestr=num2str(frame);
%                     if numel(framestr)==2
%                         framestr=['0' framestr];
%                     end
%                     if numel(framestr)==1
%                         framestr=['00' framestr];
%                     end
%                     %maxProjection
%                     fullpath=strcat(timeLapse.realPath,timeLapse.pathList.channels(j,k),timeLapse.pathList.names(j,k),'-',framestr,'-st',num2str(1),'.jpg');
%                     [pathstr, name, ext, versn] = fileparts(cell2mat(fullpath));
%                     Name = strsplit('-st', name);
%                     A=imread(strcat(pathstr,'-projection-',num2str(m),'\',Name{1,1},'.jpg'));
%                     %focal plane
% %                     fullpath=strcat(timeLapse.realPath,timeLapse.pathList.channels(j,k),timeLapse.pathList.names(j,k),'-',framestr,'-st',num2str(am),'.jpg');
% %                     [pathstr, name, ext, versn] = fileparts(fullpath);
% %                     Name = strsplit('-st', name);
%                     B=imread(strcat(pathstr,'-projection-none','\',Name{1,1},'.jpg'));
%                     %3stacks projection
%                     C=imread(strcat(pathstr,'-projection-Stacks3With1�mStep','\',Name{1,1},'.jpg'));
%
%                     m=4;
%                     framestr=num2str(frame);
%                     if numel(framestr)==2
%                         framestr=['0' framestr];
%                     end
%                     if numel(framestr)==1
%                         framestr=['00' framestr];
%                     end
%                     %maxProjection
%                     fullpath=strcat(timeLapse.realPath,timeLapse.pathList.channels(j,k),timeLapse.pathList.names(j,k),'-',framestr,'-st',num2str(1),'.jpg');
%                     [pathstr, name, ext, versn] = fileparts(cell2mat(fullpath));
%                     Name = strsplit('-st', name);
%                     D=imread(strcat(pathstr,'-projection-',num2str(m),'\',Name{1,1},'.jpg'));
%
%                     figure;
%                     subplot(1,2,1);imshow(A,[]);title('maxProj');
%                     subplot(1,2,2);imshow(B,[]);title('focalPlane');
%                     figure
%                     subplot(1,2,1);imshow(C,[]);title('3stacks 1�m');
%                     subplot(1,2,2);imshow(D,[]);title('5stacks 1�m');
%
%
%
%                 %end
%             end
%
%         end
%     end
% end

load('L:\common\movies\Camille\2012\201204\120420_multiStacks_list.mat');
a=length(List);
for b=1:a
    load(List{b,1});
    for j=1
        for i=5
            frame=i;
            for k=1:numel(timeLapse.list)
                if timeLapse.list(1,k).enableZStacks
                    for m=1:n
                        %m=1;
                        framestr=num2str(frame);
                        if numel(framestr)==2
                            framestr=['0' framestr];
                        end
                        if numel(framestr)==1
                            framestr=['00' framestr];
                        end
                        %maxProjection
                        fullpath=strcat(timeLapse.realPath,timeLapse.pathList.channels(j,k),timeLapse.pathList.names(j,k),'-',framestr,'-st',num2str(1),'.jpg');
                        [pathstr, name, ext, versn] = fileparts(cell2mat(fullpath));
                        Name = strsplit('-st', name);
                        I(:,:,b,m)=imread(strcat(pathstr,'-projection-',num2str(m),'\',Name{1,1},'.jpg'));
                    end
                    %focal plane
                    I(:,:,b,5)=imread(strcat(pathstr,'-projection-none','\',Name{1,1},'.jpg'));
                    %3stacks projection
                    I(:,:,b,6)=imread(strcat(pathstr,'-projection-Stacks3With1�mStep','\',Name{1,1},'.jpg'));
                end
                
            end
        end
    end
end


end


figure;
subplot(2,3,1);imshow(I(:,:,4,1),[500 1500]);title('35deg 10% 11 stacks');
subplot(2,3,2);imshow(I(:,:,5,1),[500 1500]);title('35deg 20% 11 stacks');
subplot(2,3,3);imshow(I(:,:,6,1),[500 1500]);title('35deg 30% 11 stacks');
subplot(2,3,4);imshow(I(:,:,4,5),[500 1500]);title('35deg 30% 7 stacks');
subplot(2,3,5);imshow(I(:,:,5,5),[500 1500]);title('35deg 30% 7 stacks');
subplot(2,3,6);imshow(I(:,:,6,5),[500 1500]);title('35deg 30% 7 stacks');


