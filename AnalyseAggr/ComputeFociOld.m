function ComputeFociOld(displayImage,l)%[meancell,cc,vx,foci,meanbud,meancyto]=
%Gilles Charvin
%link foci and cell they belong to

global segmentation

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
        
        bw_bud=logical(zeros(size(displayImage,1),size(displayImage,2)));
        
        cc=0;
        
        for i=1:numel(segmentation.budnecks(l,:))
            
            %  l,i,segmentation.budnecks(l,i).n
            
            
            if segmentation.budnecks(l,i).n~=0
                
                x=segmentation.budnecks(l,i).x;
                y=segmentation.budnecks(l,i).y;
                
                
                % line(x,y,'Color','g');
                
                if mean(inpolygon(x,y,xc,yc))>0 % bud neck is inside the cell
                    
                    
                    bw_temp = poly2mask(x,y,size(displayImage,1),size(displayImage,2));
                    
                    %size(bw_temp)
                    bw_bud(bw_temp)=1;
                    
                    cc=cc+1;
                end
            end
        end
        
        
        %pix=find(bw_bud);
        [vy, vx] = bwlabel(bw_bud, 4);
        bw_cell(bw_bud)=0;
        % figure, imshow(bw_cell,[]);
        meancell=mean(img(bw_cell));
        meancyto=(meancell*length(find(bw_cell)));
        
        if numel(find(bw_bud))
            meanbud=(mean(img(bw_bud))-meancell)*length(find(bw_bud));
            foci=zeros(2,vx);
            
            for k=1:vx
                A=find(vy==k);
                foci(1,k)=numel(A);
                C=double(img(A))-meancell;
                foci(2,k)=mean(C);
            end
        else
            meanbud=0;
            foci=0;
        end
        
        
        
        segmentation.cells1(l,j).Mean=meanbud;%total intensity of pix in foci
        segmentation.cells1(l,j).Mean_cell=meancell;%mean value of cytoplasm
        segmentation.cells1(l,j).Nrpoints=cc; %length(find(bw_bud));
        segmentation.cells1(l,j).vx=vx;
        segmentation.cells1(l,j).vy=foci;
        segmentation.cells1(l,j).cell1=meanbud;%total intensity of pix in foci
        segmentation.cells1(l,j).cell2=meancyto;%total intensity of pix in the cytoplasm
        segmentation.cells1(l,j).fluoMean=meanbud;
        %if l==116
        %   meanbud,cc
        %end
    end
end
end