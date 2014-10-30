function [BW]=phy_coordinates2mask(cx,cy,rad,n1,n2)
%Camille - 10/2012
%get a logical mask of size n1*n2 from circles coordianates cx, cy ,rad

theta = 0:0.1:(2*pi+0.1);
cx1 = cx(:,ones(size(theta)));
cy1 = cy(:,ones(size(theta)));
rad1 = rad(:,ones(size(theta)));
theta = theta(ones(size(cx1,1),1),:);

X = cx1+cos(theta).*rad1;
Y = cy1+sin(theta).*rad1;

BW=zeros(n1,n2);
BW=logical(BW);
for i=1:size(X,1)
BW = poly2mask(X(i,:),Y(i,:), n1, n2) + BW;
end

%dilate les budnecks
se = strel('disk',1);
BW=imdilate(BW,se);
%figure;imshow(double(BW),[]);

end