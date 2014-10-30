function [ ] = multiMat2Avi(filepath, low, high)
%
%Camille Paoltti - 01/2012
%ex: multiMat2Avi('L:\common\movies\Camille\2012\201201\120126',500,3000);

filenameList=dir(strcat(filepath,'\*.mat'));

for i=1:length(filenameList)
    filename=filenameList(i,1).name;
    [pathstr, name, ext, versn] = fileparts(filename) ;
    filename=strcat(filepath,'\',name);
    fprintf('making movie %s \n',filename);
    mat2avi2(filename,low,high);
end
fprintf('all movies have been made \n');

end

