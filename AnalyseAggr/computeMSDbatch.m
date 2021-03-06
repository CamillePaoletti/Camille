function foci=computeMSDbatch()

%Camille Paoletti - 02/2013

%build a cell array "foci" in which the cell (i,j) contains {MSD,err,x,y,N} for
%the foci j of the cell i

global segmentation

pixel=0.083; %taille selon x d'un pixel
foci=cell(1,1);
figure;
for j=1:length(segmentation.tcells1)
    if segmentation.tcells1(1,j).N~=0
        cc=0;
        N=segmentation.tcells1(1,j).N
        xc=segmentation.tcells1(1,j).Obj(1).x;
        yc=segmentation.tcells1(1,j).Obj(1).y;
        for i=1:length(segmentation.tfoci)
            if segmentation.tfoci(1,i).N~=0
                xf=segmentation.tfoci(1,i).Obj(1).x;
                yf=segmentation.tfoci(1,i).Obj(1).y;
                if mean(inpolygon(xf,yf,xc,yc))>0 % foci is inside the cell
                    cc=cc+1;
                    
                    plot(xc,512-yc,'-b');
                    hold on
                    plot(xf,512-yf,'+r');
                    
                    Nfoci=segmentation.tfoci(1,i).N
                    detectionFrame=segmentation.tfoci(1,i).detectionFrame;
                    lastFrame=segmentation.tfoci(1,i).lastFrame;
                    cellDetectionFrame=segmentation.tcells1(1,j).detectionFrame;
                    %cellLastFrame=segmentation.tcells1(1,j).lastFrame;
                    x=zeros(1,lastFrame-detectionFrame+1);
                    y=zeros(1,lastFrame-detectionFrame+1);
                    for k=1:(lastFrame-detectionFrame+1)
%                         x(k)=segmentation.tfoci(1,i).Obj(1,k).vx-(segmentation.tcells1(1,j).Obj(1,cellDetectionFrame+k-1).ox-segmentation.tcells1(1,j).Obj(1,1).ox);%BECAREFUL, wrong correction
%                         y(k)=segmentation.tfoci(1,i).Obj(1,k).vy-(segmentation.tcells1(1,j).Obj(1,cellDetectionFrame+k-1).oy-segmentation.tcells1(1,j).Obj(1,1).oy);
                        x(k)=segmentation.tfoci(1,i).Obj(1,k).vx-(segmentation.tcells1(1,j).Obj(1,detectionFrame+k-1).ox-segmentation.tcells1(1,j).Obj(1,detectionFrame).ox);%correction wrt focus starting position and not cell starting one
                        y(k)=segmentation.tfoci(1,i).Obj(1,k).vy-(segmentation.tcells1(1,j).Obj(1,detectionFrame+k-1).oy-segmentation.tcells1(1,j).Obj(1,detectionFrame).oy);
                    end
                    [MSD,err]=computeMSD(x,y,1);
                    Obj.Nfoci=Nfoci;
                    Obj.x=x*pixel;
                    Obj.y=y*pixel;
                    Obj.MSD=MSD;
                    Obj.err=err;
                    Obj.area=segmentation.tfoci(1,i).Obj(1,1).area;
                    foci{N,cc}=Obj;
                end
            end
        end
    end
end
        



              
                    
                   
%                         x(k)=C(k,1,i)-pixelx*(segmentation.tcells1(1,j).Obj(1,firsttime+k-1).ox-segmentation.tcells1(1,j).Obj(1,firsttime).ox);
%                         y(k)=512*pixely-(C(k,2,i)-pixely*(512-(segmentation.tcells1(1,j).Obj(1,firsttime+k-1).oy-segmentation.tcells1(1,j).Obj(1,firsttime).oy)));
%                         z(k)=C(k,3,i); %en um
%                     end
%                     [MSD,err]=computeMSD3DDel(x,y,z);
%                     Obj.Nfoci=C(1,5,i);
%                     Obj.x=x;
%                     Obj.y=y;
%                     Obj.z=z;
%                     Obj.MSD=MSD;
%                     Obj.err=err;
%                     %Obj.area=segmentation.tfoci(1,i).Obj(1,1).area;
%                     foci{N,cc}=Obj;
%                 end
%             %end
%         end
%     end
% end
%                 


end