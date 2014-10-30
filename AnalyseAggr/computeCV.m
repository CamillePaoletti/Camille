function computeCV(displayImage,l)
%Camille Paoletti from Gilles Charvin - 06/2014
%compute fluo of precox in frame l

global segmentation;
binning=2;

img=displayImage;

%  figure, imshow(img,[]);

for j=1:numel(segmentation.cells1(l,:))
    segmentation.cells1(l,j).fluoNuclMean=0;
    segmentation.cells1(l,j).fluoNuclVar=0;
    
    if segmentation.cells1(l,j).n~=0
        xc=segmentation.cells1(l,j).x;
        yc=segmentation.cells1(l,j).y;
        
        % line(xc,yc,'Color','r');
        
        bw_cell = poly2mask(xc/binning,yc/binning,size(displayImage,1),size(displayImage,2));%%%%%%??????????%%%%%%%%binning??
        imch=uint16(bw_cell).*img;
        
        %comptation of variation in preCox signal
        pix=find(imch);
        me=mean(imch(pix));
        st=std(double(imch(pix)));
        cv=st/me;
        
        
        % %values of total cell
        % meancell=mean(img(bw_cell));
        % sumcell=meancell*length(find(bw_cell));
        %
        % %create a mask for cytoplasm
        % bw_cyto= bw_cell;
        % bw_cyto(bw_foci)=0;
        % % figure, imshow(bw_cell,[]);
        %
        % %values of cytoplasm
        % meancyto=mean(img(bw_cyto));%mean
        % sumcyto=(meancyto*length(find(bw_cyto)));
        
        % values for total foci
        % meanfoci=(mean(img(bw_foci))-meancyto);
        % sumfociCell=meanfoci*length(find(bw_foci));
        % meanfoci_raw=mean(img(bw_foci));
        % sumfociCell_raw=meanfoci_raw*length(find(bw_foci));
        
        segmentation.cells1(l,j).fluoNuclMean=me;%mean intensity of preCox signal
        segmentation.cells1(l,j).fluoNuclVar=cv;%cv of preCox signal
        
    end
end
end