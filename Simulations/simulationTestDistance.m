function simulationTestDistance()
%Camille Paoletti - 05/13
%plot MSD of the coordinates saved in path


 path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/10_100/coordinates.txt';
  path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/1_100/coordinates.txt';
  path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/0dot1_100/coordinates.txt';
  %path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/0dot01_100/coordinates.txt';
N=1;


data=load(path);
x=data(1:N:end,1);
y=data(1:N:end,2);
z=data(1:N:end,3);

x0=0;
y0=0;
z0=0;

distance=sqrt((x-x0).*(x-x0)+(y-y0).*(y-y0));

figure;
% errorbar(xd,yd,errd,'g+','LineWidth',2);
plot(distance);
title('distance to center upon time');
hold off;

end