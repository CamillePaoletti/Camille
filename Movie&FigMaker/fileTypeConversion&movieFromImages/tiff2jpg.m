function []=tiff2jpg(filepath)
%Camille Paoletti - 04/2012

%filepath='L:\common\movies\Camille\2012\201201\120103\HS42';
%filepath='/Users/camillepaoletti/Documents/Lab/Movies/121130_confocal';




list=dir([filepath,'/*.tif']);
n=length(list);

if n==0
    list1=dir([filepath,'/Phase/*.tif']);
    list2=dir([filepath,'/Fluo/*.tif']);
    %list=vertcat(list1,list2);
    %n=length(list);
    n1=length(list1);
    n2=length(list2);
end

if n==0
    for i=1:n1
        [pathstr, name, ext, versn] = fileparts(list1(i,1).name);
        filesave=strcat(filepath,'/Phase/',name,'_16bits.jpg');
        im=imread(strcat(filepath,'/Phase/',name,ext));
        imwrite(im,filesave,'BitDepth',12,'Mode','lossless');
    end
    for i=1:n2
        [pathstr, name, ext, versn] = fileparts(list2(i,1).name);
        filesave=strcat(filepath,'/Fluo/',name,'_16bits.jpg');
        im=imread(strcat(filepath,'/Fluo/',name,ext));
        imwrite(im,filesave,'BitDepth',12,'Mode','lossless');
    end
    close(fig);
else
    %fig=figure;
    for i=1:n
        [pathstr, name, ext, versn] = fileparts(list(i,1).name);
        fileread=strcat(filepath,'/',name,ext);
        info = imfinfo(fileread);
        num_images = numel(info);
        for k = 1:num_images
            if k>=1 & k<10
                filesave=strcat(filepath,'/',name,'_12bits_00',num2str(k),'.jpg');
            elseif k>=10 & k<100
                filesave=strcat(filepath,'/',name,'_12bits_0',num2str(k),'.jpg');
            elseif k>=100 & k<1000
                filesave=strcat(filepath,'/',name,'_12bits_',num2str(k),'.jpg');
            end
            im = imread(fileread, k, 'Info', info);
            %imshow(im,[]);
            %F = getframe(fig);
            %im=F.cdata;
            %im=rgb2gray(im);
            imwrite(im,filesave,'BitDepth',12,'Mode','lossless');
        end
    end
    %close(fig);
end


