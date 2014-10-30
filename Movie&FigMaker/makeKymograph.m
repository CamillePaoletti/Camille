function []=makeKymograph()

%chose profil along which you want to get a kymo

profil=1;

global timeLapse;


fprintf('Now I m building the asked kymograph, while you re dreaming... \n');

if (numel(timeLapse.position.list)==0)
    maxpos=1 ;
    localTimeLapse=timeLapse;
else
    maxpos=numel(timeLapse.position.list);
end

maxpos=2;

for i=34%i=1:maxpos
    dirpos=strcat(timeLapse.filename,'-pos',int2str(i));
    
    if (numel(timeLapse.list)~=numel(timeLapse.position.list(i).timeLapse.list))
        localTimeLapse=timeLapse.position.list(i).timeLapse;
    else
        localTimeLapse=timeLapse;
    end
    
    for j=1:numel(localTimeLapse.list)
        chpos=strcat(timeLapse.filename,'-pos',int2str(i),'-ch',int2str(j),'-',timeLapse.list(j).ID);
        
        %path2=strcat(timeLapse.path,dirpos,'\');
        path2=strcat('L:\common\movies\Camille\2012\120104\',dirpos,'\');
        for k=1:144%timeLapse.numberOfFrames
            if k<10
                filename=strcat(path2,chpos,'\',chpos,'-00',num2str(k),'.jpg');
            elseif k>=10 && k<100
                filename=strcat(path2,chpos,'\',chpos,'-0',num2str(k),'.jpg');
            else
                filename=strcat(path2,chpos,'\',chpos,'-',num2str(k),'.jpg');
            end
            
            A=imread(filename);
            kymo(:,k)=A(:,profil);
        end
        figure;
        imshow(kymo,[]);
        title(['Kymograph along x=',num2str(profil),' (pos.',num2str(i),')']);
        [x,y]= getline;
        K2 = imcrop(kymo,[1,min(y),size(kymo,2),max(y)-min(y)]);
        figure;imshow(K2,[]);
        frequencyAnalysis(K2,i);
        
    end
    
    
    
     
end
end
