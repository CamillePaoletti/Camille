function [] = rectangle2squareImage_Batch( filepath )
%Camille Paoletti - 01/2013


list=dir([filepath,'/*.jpg']);
n=length(list);

fig=figure;

for i=1:n
    [pathstr, name, ext, versn] = fileparts(list(i,1).name);
    filename=strcat(filepath,'/',name,ext);
    [im]=rectangle2squareImage(filename);
    imshow(im,[]);
    F = getframe(fig);
    im=F.cdata;
    imwrite(im,filename,'BitDepth',8);
    
    
end

end

