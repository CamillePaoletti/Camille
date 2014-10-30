%mch: mCherry raw image
function cv=aldea_test(phy_cell,mch,ncell)

binning=2;

xc=phy_cell(1,ncell).x;
yc=phy_cell(1,ncell).y; 
bw_cell = poly2mask(xc/binning,yc/binning,1024,1024);
imch=uint16(bw_cell).*mch;

%selection of the brightest pixels (>mean+2std)
pix=find(imch);
me=mean(imch(pix))
st=std(double(imch(pix)))
cv=st/me
% pix2=find(imch>me+2*st);
% [I,J] = ind2sub(size(imch),pix2) ;
% pix2_val=imch(pix2);
% [xg,yg]=gravity_center(I,J,pix2_val);
% 
% figure,imshow(imch,[300 1000]);hold on;line(xc/2,yc/2,'Color','r');
% imtest=imch;
% imtest(pix2)=0;
% figure,imshow(imtest,[300 1000]);hold on;line(xc/2,yc/2,'Color','r');
% 
% 
% %gravity center of brightest pixels
% 
% d=tot_distance(xg,yg,I,J,binning)
% a=phy_cell(1,ncell).area/(binning*binning);%area with the correct binning
% r=sqrt(a/pi);
% nuc_index=8*r/15/d;
end

function [xg,yg]=gravity_center(I,J,pix_val)
mtot=sum(pix_val);
xg=sum(I.*double(pix_val))/mtot;
yg=sum(J.*double(pix_val))/mtot;

end

function d=tot_distance(x,y,I,J,binning)
s=size(I,1);
x=x/binning;
y=y/binning;
X=ones(s,1)*x;
Y=ones(s,1)*y;
d=sqrt((X-I).^2+(Y-J).^2);
d=mean(d);
end
