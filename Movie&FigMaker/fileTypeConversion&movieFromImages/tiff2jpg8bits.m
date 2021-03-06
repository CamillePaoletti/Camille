function []=tiff2jpg8bits(filepath)
%Camille Paoletti - 04/2012

%filepath='L:\common\movies\Camille\2012\201201\120103\HS42';




list=dir([filepath,'\*.tif']);
n=length(list);

if n==0
    list1=dir([filepath,'\Phase\*.tif']);
    list2=dir([filepath,'\Fluo\*.tif']);
    %list=vertcat(list1,list2);
    %n=length(list);
    n1=length(list1);
    n2=length(list2);
end

if n==0
    for i=1:n1
        [pathstr, name, ext, versn] = fileparts(list1(i,1).name);
        filesave=strcat(filepath,'\Phase\',name,'_8bits.jpg');
        im=imread(strcat(filepath,'\Phase\',name,ext));
        im = imadjust(im);
        im=im2uint8(im);
        imwrite(im,filesave,'BitDepth',8);
    end
    fig=figure;
    for i=1:n2
        [pathstr, name, ext, versn] = fileparts(list2(i,1).name);
        filesave=strcat(filepath,'\Fluo\',name,'_8bits.jpg');
        im=imread(strcat(filepath,'\Fluo\',name,ext));
        imshow(im,[]);
        F = getframe(fig);
        im=F.cdata;
        imwrite(im,filesave,'BitDepth',8);
    end
    close(fig);
else
    fig=figure;
    for i=1:n
        [pathstr, name, ext, versn] = fileparts(list(i,1).name);
        filesave=strcat(filepath,'\',name,'_8bits.jpg');
        im=imread(strcat(filepath,'\',name,ext));
        imshow(im,[]);
        F = getframe(fig);
        im=F.cdata;
        imwrite(im,filesave,'BitDepth',8);
    end
    close(fig);
end


