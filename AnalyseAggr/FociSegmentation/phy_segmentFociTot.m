function [budneck]=phy_segmentFociTot(img,parametres)
%Camille - 10/2012
%combination of classical phy_segementFoci and foci detections by gradient
%(copyright Vincent Delaitre :)

display=0;

imgor=img;
budneck=phy_Object;
%Classical phylocell foci segmentation
[L,cells_mean]=phy_segmentFociNew(img,parametres);
% %foci detection by gradient
% [detections]=phy_segmentFociGradient(img,parametres);
% cx=detections(:,1);
% cy=detections(:,2);
% rad=detections(:,3);
% n=size(imgor);
% [BW]=phy_coordinates2mask(cx,cy,rad,n(1),n(2));
% %all detected foci
% L=L+BW;

%--------------------------------------------------------------------------
%compute boundaries with a fine contour (resolution *10)
[B,L] = bwboundaries(L,4,'noholes');%hyst
m=max(max(L));
B=cell(m,1);
warning off all;
for i = 1:m
    bw=L==i;
    s=regionprops(bw,'BoundingBox');
    m=max(s.BoundingBox(3),s.BoundingBox(4))-1;
    rect=[s.BoundingBox(1),s.BoundingBox(2),m,m];
    a=imcrop(bw, rect);
    a=imresize(a,10);
    [b,a] = bwboundaries(a,4,'noholes');
    b{1,1}=b{1,1}/10;
    b{1,1}(:,1)=b{1,1}(:,1)+s.BoundingBox(2);
    b{1,1}(:,2)=b{1,1}(:,2)+s.BoundingBox(1);
    B{i}=b{1,1};
end;
warning on all;


if display
    figure;
    imshow(L,[]); title('bwboundaries');
    figure;
    imshow(imgor,[]); title('rawdata');
end


k=1;
for cc = 1:length(B)
    
    % obtain (X,Y) boundary coordinates corresponding to label 'k'
    boundary = B{cc};
    pix=find(L==cc);
    
    %numel(pix)
    
    if numel(pix)>round(parametres{4,2})
        %numel(pix)
        %calcul mean ,mode, min,max, intensity budneck
        % 'ok'
        
        if min(boundary(:,2))>10 && max(min(boundary(:,2)))<size(img,2)-10 && min(boundary(:,1))>10 && max(min(boundary(:,1)))<size(img,1)-10
            budneck(k).Mean=mean(img(pix));
            budneck(k).Median=median(img(pix));
            budneck(k).Min=min(img(pix));
            budneck(k).Max=max(img(pix));
            budneck(k).Nrpoints=length(pix); %number of point (aire)
            budneck(k).Mean_cell=cells_mean;
            budneck(k).fluoMean(2)=mean(imgor(pix));
            
            [r c]=ind2sub(size(img),pix); %transform from linear indice to matricial indice
            budneck(k).x=boundary(:,2);  %x contur
            budneck(k).y=boundary(:,1);   % y contur
            budneck(k).ox=mean(c); %x center
            budneck(k).oy=mean(r);  %y center
            budneck(k).n=k;
            
            k=k+1;
        end
    end
end
end