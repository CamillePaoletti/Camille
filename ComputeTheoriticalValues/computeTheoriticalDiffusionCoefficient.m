function [LNratio,D] = computeTheoriticalDiffusionCoefficient(r)
%Camille Paoletti - 11/2012
%compute theoritical diffusion coefficient from formula developped in "from
%biologistics : mobility in cells)
%parameters:
%   input:
%       r: radius of the molecule whose diffusion coefficient is computed
%       !!! in nm !!!
%   output:
%       D: diffusion coefficient in µm^2/sec
%       LNratio: ln(D0/D)

eta=0.7978e-3;%viscosity of water in Pa.s !!! at 30°C !!! (to modify if temperature is changed)
kb=1.380648813e-23;%Boltzmann constant
T=273.16+30;%temperature (in kelvin)

xi=0.7;
Rh=48;
a=0.54;

D0=(kb*T)/(6*pi*eta*r*1e-9);
LNratio=(xi^2/Rh^2+xi^2/r^2)^(-a/2);
D=D0/exp((xi^2/Rh^2+xi^2/r^2)^(-a/2))*1e12;

end