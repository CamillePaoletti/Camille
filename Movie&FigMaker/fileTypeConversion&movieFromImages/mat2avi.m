function []=mat2avi(filename)
%Camille Paoletti - 06/2011
%create an AVI moovie from a 3D matrix (.mat)
%ex: mat2avi('L:\common\movies\Camille\2011\110623\100mu_1sec');


data=load([filename,'.mat']);
n=size(data.M,1);
%n=120;
deltaT=0.7;



aviobj = avifile(strcat(filename,'.avi'),'compression','None','fps',10);
fig=figure;

for k=1:n
    M(:,:)=data.M(k,:,:);
%     Im=imcrop(I,[203,180,95,80]);
%     imshow(Im,[700 1500]);
    imshow(M,[500 9000]);
    %imshow(I,[500 16000]);
    rectangle('Position',[10,5,16,4], 'LineWidth',1, 'FaceColor',[1 0 0]);
    text(5,17,'20 µm','Color',[1 0 0]);
    str=strcat(num2str(k*deltaT),' s');
    text(65,17,str,'Color',[1 0 0]);
    F = getframe(fig);
    aviobj = addframe(aviobj,F);
end

close(fig);
aviobj = close(aviobj);


end