function computeFociNew(displayImage,l)
%Camille Paoletti from Gilles Charvin - 02/2013
%link foci and cell they belong to in frame l, compute fluo in foci and cell

global segmentation;

img=displayImage;

%  figure, imshow(img,[]);

for j=1:numel(segmentation.cells1(l,:))
    segmentation.cells1(l,j).Nrpoints=0;
    segmentation.cells1(l,j).Mean=0;
    
    if segmentation.cells1(l,j).n~=0
        xc=segmentation.cells1(l,j).x;
        yc=segmentation.cells1(l,j).y;
        
        % line(xc,yc,'Color','r');
        
        bw_cell = poly2mask(xc,yc,size(displayImage,1),size(displayImage,2));
        
        bw_foci=logical(zeros(size(displayImage,1),size(displayImage,2)));
        
        cc=0;
        
        %fill the mask bw_foci and segmentation.foci specific values
        for i=1:numel(segmentation.foci(l,:))
            if segmentation.foci(l,i).n~=0
                
                x=segmentation.foci(l,i).x;
                y=segmentation.foci(l,i).y;
                % line(x,y,'Color','g');
                in=inpolygon(x,y,xc,yc);
                n=length(in);
                in=sort(in);
                in=in(1:round(n/2));
                
                if mean(in)>0 % foci is inside the cell
                    bw_temp = poly2mask(x,y,size(displayImage,1),size(displayImage,2));
                    bw_foci(bw_temp)=1;
                    bw_temp_mat=uint8(bw_temp);
                    A=regionprops(bw_temp_mat,img,'WeightedCentroid','MeanIntensity','MaxIntensity','MinIntensity','Perimeter','Area');
                    
                    segmentation.foci(l,i).Mean=A.MeanIntensity;
                    segmentation.foci(l,i).Max=A.MaxIntensity;
                    segmentation.foci(l,i).Min=A.MinIntensity;
                    segmentation.foci(l,i).Nrpoints=A.Area;
                    segmentation.foci(l,i).vx=A.WeightedCentroid(1);
                    segmentation.foci(l,i).vy=A.WeightedCentroid(2);
                    cc=cc+1;
                end
            end
        end

        %values of total cell
        meancell=mean(img(bw_cell));
        sumcell=meancell*length(find(bw_cell));
        
        %label foci
        [vy, vx] = bwlabel(bw_foci, 4);
        
        %create a mask for cytoplasm
        bw_cyto= bw_cell;
        bw_cyto(bw_foci)=0;
        % figure, imshow(bw_cell,[]);
        
        %values of cytoplasm
        meancyto=mean(img(bw_cyto));%mean
        sumcyto=(meancyto*length(find(bw_cyto)));
        
        %values of cytoplasm and foci if there is at least one focus
        if numel(find(bw_foci))
            
            %values for cyto
            meancyto=mean(img(bw_cyto));
            sumcyto=(meancyto*length(find(bw_cyto)));
            
            %values for total foci
            meanfoci=(mean(img(bw_foci))-meancyto);
            sumfociCell=meanfoci*length(find(bw_foci));
            meanfoci_raw=mean(img(bw_foci));
            sumfociCell_raw=meanfoci_raw*length(find(bw_foci));
            foci=zeros(2,vx);
            
            %values for individual foci
            for k=1:vx
                A=find(vy==k);
                foci(1,k)=numel(A);%number of pixel of foci k in the cell
                C=double(img(A))-meancyto;
                foci(2,k)=mean(C);%mean value of fluorescence of pixel  of foci k (with substracted background)
            end
            
        else
            
            %values in case of no focus
            meanfoci=0;
            sumfociCell=0;
            foci=0;
            meanfoci_raw=0;
            sumfociCell_raw=0;
            
        end
        
        segmentation.cells1(l,j).fluoMean=meancell;%mean intensity in the cell
        segmentation.cells1(l,j).fluoVar=sumcell;%total intensity in the cell
        segmentation.cells1(l,j).fluoCytoMean=meancyto;%mean intensity in the cyto
        segmentation.cells1(l,j).fluoCytoVar=sumcyto;%total intensity in the cyto
        segmentation.cells1(l,j).Nrpoints=cc; %number of foci in the cell;
        segmentation.cells1(l,j).vx=vx;%number of foci in the cell
        segmentation.cells1(l,j).vy=foci;%number of pix and values of pix in each foci of the cell
        segmentation.cells1(l,j).fluoNuclMean=meanfoci;%mean intensity of pix in foci (with substracted background)
        segmentation.cells1(l,j).fluoNuclVar=sumfociCell;%total intensity of pix in foci (with substracted background)
        segmentation.cells1(l,j).fluoNuclMin=meanfoci_raw;%mean intensity of pix in foci (no background substraction)
        segmentation.cells1(l,j).fluoNuclMax=sumfociCell_raw;%total intensity of pix in foci (no background substraction)
       
    end
end
end