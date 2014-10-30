function [n]=cellFluctationAnalysis()
%Camille Paoletti - 01/2012
%idea: FCS over cell number in order to evaluate growth rate

global timeLapse;
cellCellDistance=40;
display=1;

fprintf('Now I m counting cells, while you re dreaming... \n');

if (numel(timeLapse.position.list)==0)
    maxpos=1 ;
    localTimeLapse=timeLapse;
else
    maxpos=numel(timeLapse.position.list);
end

maxpos=2;

for i=1%i=1:maxpos
    dirpos=strcat(timeLapse.filename,'-pos',int2str(i));
    
    if (numel(timeLapse.list)~=numel(timeLapse.position.list(i).timeLapse.list))
        localTimeLapse=timeLapse.position.list(i).timeLapse;
    else
        localTimeLapse=timeLapse;
    end
    
    path2=strcat(timeLapse.path,dirpos,'\');
    %path2=strcat('L:\common\movies\Camille\2012\120104\',dirpos,'\');
    chpos=strcat(timeLapse.filename,'-pos',int2str(i),'-ch',int2str(1),'-',timeLapse.list(1).ID);
    filename=strcat(path2,chpos,'\',chpos,'-0',num2str(50),'.jpg');
    figure;
    im=imread(filename);
    imshow(im,[]);
    [px py]=getpts;
    
    
    
    for j=1:1%numel(localTimeLapse.list)
        chpos=strcat(timeLapse.filename,'-pos',int2str(i),'-ch',int2str(j),'-',timeLapse.list(j).ID);
        
        fprintf('processing');
        for k=1:timeLapse.numberOfFrames
            if k<10
                filename=strcat(path2,chpos,'\',chpos,'-00',num2str(k),'.jpg');
            elseif k>=10 && k<100
                filename=strcat(path2,chpos,'\',chpos,'-0',num2str(k),'.jpg');
            else
                filename=strcat(path2,chpos,'\',chpos,'-',num2str(k),'.jpg');
            end
            
            im=imread(filename);
            imdata=imcrop(im,[min(px),min(py),max(px)-min(px), max(py)-min(py)]);
            if k==386
                display=1;
            elseif k==385
                   display=1;  
            elseif k==387
                    display=1; 
            else display=0;
            end
            [listx listy distance imdistance]=phy_findCellCenters(imdata,display,cellCellDistance);
            n(k)=numel(listx);
            fprintf('.');
        end
        figure;
        plot([1:1:timeLapse.numberOfFrames],n)%plot(144,n)
        title(['number of cells']);
        fprintf('\n');
    end
     
end

end

