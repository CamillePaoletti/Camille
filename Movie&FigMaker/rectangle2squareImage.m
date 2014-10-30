function [img_square]=rectangle2squareImage(filename)
%Camille Paoletti - 01/2013
%crop a rectangle image and create the bigest square image from it

image=imread(filename);
s=min(size(image,1),size(image,2));
xmin=0;
ymin=0;
width=s;
height=s;
img_square=imcrop(image,[xmin ymin width height]);

end