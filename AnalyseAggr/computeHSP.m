function computeHSP(displayImage,l)
%Camille Paoletti from Gilles Charvin - 06/2014
%compute fluo of precox in frame l

global segmentation;
binning=2;

img=displayImage;

%  figure, imshow(img,[]);

for j=1:numel(segmentation.cells1(l,:))
    segmentation.cells1(l,j).fluoCytoMean=0;
    segmentation.cells1(l,j).fluoCytoVar=0;
    
    if segmentation.cells1(l,j).n~=0
        xc=segmentation.cells1(l,j).x;
        yc=segmentation.cells1(l,j).y;
        
        % line(xc,yc,'Color','r');
        
        bw_cell = poly2mask(xc/binning,yc/binning,size(displayImage,1),size(displayImage,2));%%%%%%??????????%%%%%%%%binning??
        imgfp=uint16(bw_cell).*img;
        
        %comptation of variation in gfp signal
        pix=find(imgfp);
        me=mean(imgfp(pix));
        st=std(double(imgfp(pix)));
        cv=st/me;
        
        segmentation.cells1(l,j).fluoCytoMean=me;%mean intensity of preCox signal
        segmentation.cells1(l,j).fluoCytoVar=cv;%cv of preCox signal
        
    end
end
end