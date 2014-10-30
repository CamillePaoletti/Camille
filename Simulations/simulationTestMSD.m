function simulationTestMSD(path)
%Camille Paoletti - 05/13
%plot MSD of the coordinates saved in path


 %path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/10_100/coordinates.txt';
  %path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/1_100/coordinates.txt';
 % path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/0dot1_100/coordinates.txt';
%  path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/0dot01_100/coordinates.txt';
%path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusionT/1_100/coordinates.txt';

%path='/Volumes/data7/paoletti/Simulations/data/test/timeStep/compute/proportional/coordinates_2.txt';
N=1;

pixel=1e-3
pixel2=pixel*pixel;

data=load(path);
x=data(1:N:end,1);
y=data(1:N:end,2);
z=data(1:N:end,3);
[MSD,err]=computeMSD(x,y,0);
[MSD2]=computeMSD(x,z,0);
[MSD3]=computeMSD(y,z,0);
[MSD3D,err3D]=computeMSD3D(x,y,z,0);
% xd=[0:1:4];
% yd=transpose(MSD(:,1));
% errd=err(1:5,1);
% 
% [p]=polyfit(xd,yd,1);
% yfit=polyval(p,xd);
% size(xd)
% size(yfit)

figure;
% errorbar(xd,yd,errd,'g+','LineWidth',2);
plot(MSD(:,1)*pixel2,'k-');
hold on;
plot(MSD2(:,1)*pixel2,'b-');
plot(MSD3(:,1)*pixel2,'g-');
plot(MSD3D(:,1)*pixel2,'r-');
% plot(xd,yfit,'g-');
%ylim([0 5e5]);
legend('x-y','x-z','y-z','3D');
hold off;

figure;
% errorbar(xd,yd,errd,'g+','LineWidth',2);
loglog(MSD(:,1)*pixel2,'k-');
hold on;
loglog(MSD2(:,1)*pixel2,'b-');
loglog(MSD3(:,1)*pixel2,'g-');
loglog(MSD3D(:,1)*pixel2,'r-');
% plot(xd,yfit,'g-');
legend('x-y','x-z','y-z','3D');
hold off;