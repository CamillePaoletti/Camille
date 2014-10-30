function []=RGB2grayBatch(filepath)
%Cmaille Paoletti - 01/2013
%implement because timeLapse Project created with CreateProjectGui gives
%RGB images instead of gray scale images

list=dir([filepath,'/*.jpg']);
n=length(list);
for i=1:n
    [pathstr, name, ext, versn] = fileparts(list(i,1).name);
    fileread=strcat(filepath,'/',name,ext);
    im = imread(fileread);
    size(im)
    imsave=rgb2gray(im);
    imwrite(imsave,fileread,'BitDepth',12,'Mode','lossless');
end

end