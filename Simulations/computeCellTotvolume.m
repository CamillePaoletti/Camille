function [V,Ratio,Vcell,Vbud]=computeCellTotvolume(Rcell,Rbud,Rcontact)
%Camille Paoletti - 02/13
%compute the volume of a cell and its bud

Vcell=computeVolumeCutBall(Rcell,Rcontact);
Vbud=computeVolumeCutBall(Rbud,Rcontact);
V=Vcell+Vbud;
Ratio=Vbud/Vcell;


end