function ComputeFluoPoonam(displayImage,l,fluoChannel)
%Camille Paoletti - 11/2013

%link nucleus and cell they belong to / compute fluorescence in nucleus
%contours for the image channel

%displayImage: fluo image in which the fluo is scored
%l: frame number
%fluoChannel: number of the channel in which the fluo is scored


global segmentation;

img=displayImage;

%  figure, imshow(img,[]);

for j=1:numel(segmentation.cells1(l,:))
    
    if segmentation.cells1(l,j).n~=0
        %cell contours
        xc=segmentation.cells1(l,j).x;
        yc=segmentation.cells1(l,j).y;
       
        bw_cell = poly2mask(xc,yc,size(displayImage,1),size(displayImage,2));
        
        bw_bud=logical(zeros(size(displayImage,1),size(displayImage,2)));
        
        cc=0;
        
        for i=1:numel(segmentation.nucleus(l,:))
            
            if segmentation.nucleus(l,i).n~=0
                %nucleus contour
                x=segmentation.nucleus(l,i).x;
                y=segmentation.nucleus(l,i).y;
                
                in=inpolygon(x,y,xc,yc);
                n=length(in);
                in=sort(in);
                in=in(1:round(n/2));
                
                if mean(in)>0 % foci is inside the cell
                   
                    bw_temp = poly2mask(x,y,size(displayImage,1),size(displayImage,2));
                    
                    bw_bud(bw_temp)=1;
                    
                    cc=cc+1;%counter for the number of nucleus
                end
            end
        end
        
        meancell=mean(img(bw_cell));%mean value in cell
        totalcell=(meancell*length(find(bw_cell)));%total fluorescence in cell
        
        [vy, vx] = bwlabel(bw_bud, 4);
        bw_cell(bw_bud)=0;
        meancyto=mean(img(bw_cell));%mean value in cytoplasm
        totalcyto=(meancyto*length(find(bw_cell)));%total fluorescence in cytoplasm
        
        if numel(find(bw_bud))
            meancyto=mean(img(bw_cell));%mean value in cytoplasm
            totalcyto=meancyto*length(find(bw_cell));%total fluorescence in cytoplasm
            meanbud=mean(img(bw_bud)-meancyto);%mean value in the nucleus (denoized)
            %meanbud=mean(img(bw_bud));%mean value in the nucleus
            totalbud=meanbud*length(find(bw_bud));%total fluorescence in the nucleus
            
        else
            meanbud=0;
            totalbud=0;
        end
        
        segmentation.cells1(l,j).fluoMean(1,fluoChannel)=meancell;%mean value in cell
        segmentation.cells1(l,j).fluoVar(1,fluoChannel)=totalcell;%total value in cell
        segmentation.cells1(l,j).fluoNuclMean(1,fluoChannel)=meanbud;%mean value in the nucleus (denoized)
        segmentation.cells1(l,j).fluoNuclVar(1,fluoChannel)=totalbud;%total fluorescence in the nucleus (denoized)
        segmentation.cells1(l,j).fluoCytoMean(1,fluoChannel)=meancyto;%mean value in cytoplasm
        segmentation.cells1(l,j).fluoCytoVar(1,fluoChannel)=totalcyto;%total fluorescence in cytoplasm
        
    end
end
end