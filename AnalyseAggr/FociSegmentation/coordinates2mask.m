function [BW]=phy_coordinates2mask(cx,cy,rad)


n=151;
cx=detections(:,1);
cy=detections(:,2);
rad=detections(:,3);
theta = 0:0.1:(2*pi+0.1);

cx1 = cx(:,ones(size(theta)));
cy1 = cy(:,ones(size(theta)));
rad1 = rad(:,ones(size(theta)));
theta = theta(ones(size(cx1,1),1),:);

X = cx1+cos(theta).*rad1;
Y = cy1+sin(theta).*rad1;

BW=zeros(n,n);
BW=logical(BW);
for i=1:size(X,1)
BW = poly2mask(X(i,:),Y(i,:), n, n) + BW;
end
%figure;imshow(double(BW),[]);

end