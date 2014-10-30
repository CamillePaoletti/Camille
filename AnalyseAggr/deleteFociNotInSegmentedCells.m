function [fociToKeepNumber,fociToKeep]=deleteFociNotInSegmentedCells(l)%[meancell,cc,vx,foci,meanbud,meancyto]=
%Camille Paoletti - 02/2013

%for the frame l, delete foci that are not in segmented cells
%BE CAREFUL : do not save segmentation variable to be able to undo (done in
%deleteFociNotInSegmentedCellsBatch)

global segmentation;

fociToKeep=cell(1,1);
fociToKeepNumber=cell(1,1);
%  figure, imshow(img,[]);

for j=1:numel(segmentation.foci(l,:))
    if segmentation.foci(l,j).n~=0
        xf=segmentation.foci(l,j).x;
        yf=segmentation.foci(l,j).y;
        
        
        
        for i=1:numel(segmentation.cells1(l,:))
            
            %  l,i,segmentation.foci(l,i).n
            
            
            if segmentation.cells1(l,i).n~=0
                
                xc=segmentation.cells1(l,i).x;
                yc=segmentation.cells1(l,i).y;
                
                
                % line(x,y,'Color','g');
                
                if mean(inpolygon(xf,yf,xc,yc))>0 % bud neck is inside the cell
                    fociToKeepNumber{1,1}=[fociToKeep{1,1},segmentation.foci(l,j).n];
                    fociToKeep{1,1}=[fociToKeep{1,1},j];
                end
            end
        end
        
    end   
        
end

%cc=0;
%for j=fociToKeep{1,1}
    %cc=cc+1;
    %segmentationFoci_temp(l,cc)=segmentation.foci(l,j);
for j=1:numel(segmentation.foci(l,:))
    if find(j==fociToKeep{1,1})
    else
        segmentation.foci(l,j).n=0;
        segmentation.foci(l,j).ox=0;
        segmentation.foci(l,j).oy=0;
    end
end

%ssegmentation.foci(l,:)=segmentationFoci_temp(l,:);

end