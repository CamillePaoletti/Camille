function computeNucleus(displayImage,l)%
%Camille Paoletti from computeFociNew - 11/2013
%link nucleus and cell they belong to in frame l, compute number of nucleus in cell

global segmentation;

img=displayImage;

%  figure, imshow(img,[]);

for j=1:numel(segmentation.cells1(l,:))
    segmentation.cells1(l,j).fluoCytoVar=0;
    %segmentation.cells1(l,j).Mean=0;
    
    if segmentation.cells1(l,j).n~=0
        xc=segmentation.cells1(l,j).x;
        yc=segmentation.cells1(l,j).y;
        
        % line(xc,yc,'Color','r');
        
        bw_cell = poly2mask(xc,yc,size(displayImage,1),size(displayImage,2));
        
        bw_nucleus=logical(zeros(size(displayImage,1),size(displayImage,2)));
        
        cc=0;
        
        for i=1:numel(segmentation.nucleus(l,:))
            if segmentation.nucleus(l,i).n~=0
                
                x=segmentation.nucleus(l,i).x;
                y=segmentation.nucleus(l,i).y;
                % line(x,y,'Color','g');
                
                if mean(inpolygon(x,y,xc,yc))>0 % nucleus is inside the cell
                    bw_temp = poly2mask(x,y,size(displayImage,1),size(displayImage,2));
                    bw_nucleus(bw_temp)=1;
                    bw_temp_mat=uint8(bw_temp);
                    A=regionprops(bw_temp_mat,img,'WeightedCentroid','MeanIntensity','MaxIntensity','MinIntensity','Perimeter','Area');
                    
%                     segmentation.foci(l,i).Mean=A.MeanIntensity;
%                     segmentation.foci(l,i).Max=A.MaxIntensity;
%                     segmentation.foci(l,i).Min=A.MinIntensity;
%                     segmentation.foci(l,i).Nrpoints=A.Area;
%                     segmentation.foci(l,i).vx=A.WeightedCentroid(1);
%                     segmentation.foci(l,i).vy=A.WeightedCentroid(2);
                    cc=cc+1;
                end
            end
        end

        %pix=find(bw_nucleus);
        [vy, vx] = bwlabel(bw_nucleus, 4);
        bw_cell(bw_nucleus)=0;
        % figure, imshow(bw_cell,[]);
        meancyto=mean(img(bw_cell));
        sumcyto=(meancyto*length(find(bw_cell)));
        
        if numel(find(bw_nucleus))
            bw_cyto= bw_cell;
            bw_cyto(bw_nucleus)=0;
            meancyto=mean(img(bw_cyto));
            
            sumcyto=(meancyto*length(find(bw_cell)));
            meannucleus=(mean(img(bw_nucleus))-meancyto);
            sumnucleusCell=(mean(img(bw_nucleus))-meancyto)*length(find(bw_nucleus));
            nucleus=zeros(2,vx);
            
            for k=1:vx
                A=find(vy==k);
                nucleus(1,k)=numel(A);%number of pixel of nucleus k in the cell
                C=double(img(A))-meancyto;
                nucleus(2,k)=mean(C);%value of fluorescence of pixel k (with substracted background)
            end
        else
            sumnucleusCell=0;
            nucleus=0;
            meannucleus=0;
        end
        
       
        %segmentation.cells1(l,j).Mean=meanfoci;%mean intensity in foci
        %segmentation.cells1(l,j).Mean_cell=meancyto;%mean value of cytoplasm
        %segmentation.cells1(l,j).Nrpoints=cc; %length(find(bw_foci))=number of foci in the cell;
        segmentation.cells1(l,j).fluoCytoVar=cc; %length(find(bw_foci))=number of foci in the cell;
        %segmentation.cells1(l,j).vx=vx;%number of foci in the cell
        %segmentation.cells1(l,j).vy=foci;%number of pix and values of pix in each foci of the cell
        %segmentation.cells1(l,j).fluoNuclMean=sumfociCell;%total intensity of pix in foci
        %%segmentation.cells1(l,j).fluoNuclVar=varfociCell;%total intensity of pix in foci
        %segmentation.cells1(l,j).fluoMean=sumcyto;%total intensity of pix in the cytoplasm
%        fprintf(['fluoMean ' num2str(segmentation.cells1(l,j).fluoMean) ' \n']);

        %if l==116
        %   meanbud,cc
        %end
    end
end
end

