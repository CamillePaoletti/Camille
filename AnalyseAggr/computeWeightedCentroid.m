function [wc]=computeWeightedCentroid(foci,image)
%Camille Paoletti - 02/2013
%compute WeightedCentroids of segmented foci

bw_temp=poly2mask(foci.x,foci.y,size(image,1),size(image,2));
A=regionprops(bw_temp,image,'WeightedCentroid');
wc=A.WeightedCentroid;

end