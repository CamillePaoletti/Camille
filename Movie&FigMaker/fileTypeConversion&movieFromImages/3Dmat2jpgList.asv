function []=a3Dmat2jpgList(filename,savingFilepath)
%Camille Paoletti - 06/20011
%create a list of images from a 3D matlab image
%ex: 3Dmat2jpgList('L:\common\movies\Camille\2011\110623\100mu_1sec.mat','L:\common\movies\Camille\2011\110623\100mu_1sec');

fprintf('loading %s \n',filename);
data=load(filename);
n=size(data.I,1);
p=size(data.I,2);
for i=1:n
    if i<10;
    a=strcat('00',num2str(i));
    elseif 10<=i && i<100;
        a=strcat('0',num2str(i));
    else
        a=num2str(i);
    end
    savingFilename=strcat(savingFilepath,'_fluo_',a,'.jpg');
    fprintf('saving %s \n',savingFilename);
    A(1:p,1:p)=data.I(i,:,:);
    imwrite(A,savingFilename,'BitDepth',16); 
end
end
    