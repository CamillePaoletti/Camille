function simulationTestPlateau()
%Camille Paoletti - 06/13
%plot MSD of the coordinates saved in path


path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/data/test/test_dt_step_0dot0001';
path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/data/test/test_dt_step_0dot01';
path='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/data/test/test_dt_step_1';
N=1;
Nsim=20;
% close all;

x0=0;
y0=0;
z0=0;

for i=1:Nsim
    temp_path=[path,'/coordinates/sim_',num2str(i),'.txt'];
    data=load(temp_path);
    x=data(1:N:end,1);
    y=data(1:N:end,2);
    z=data(1:N:end,3);
    
    distance=sqrt((x-x0).*(x-x0)+(y-y0).*(y-y0));
    
    %[MSD,err]=computeMSD(x,y,0);
    %[MSD2]=computeMSD(x,z,0);
    %[MSD3]=computeMSD(y,z,0);
    [MSD3D,err3D]=computeMSD3D(x,y,z,0);
    % xd=[0:1:4];
    % yd=transpose(MSD(:,1));
    % errd=err(1:5,1);
    %
    % [p]=polyfit(xd,yd,1);
    % yfit=polyval(p,xd);
    % size(xd)
    % size(yfit)
    
    figure(4);
    % errorbar(xd,yd,errd,'g+','LineWidth',2);
    %plot(MSD(:,1),'k-');
    hold on;
    %plot(MSD2(:,1),'b-');
    %plot(MSD3(:,1),'g-');
    plot(MSD3D(:,1),'b-');
    % plot(xd,yfit,'g-');
    %ylim([0 5e5]);
    %legend('x-y','x-z','y-z','3D');
    hold off;
    
%     figure(2);
%     % errorbar(xd,yd,errd,'g+','LineWidth',2);
%     %loglog(MSD(:,1),'k-');
%     hold on;
%     %loglog(MSD2(:,1),'b-');
%     %loglog(MSD3(:,1),'g-');
%     loglog(MSD3D(:,1),'r-');
%     % plot(xd,yfit,'g-');
%     %legend('x-y','x-z','y-z','3D');
%     hold off;
%     
%     figure(3);
%     hold on;
%     plot(distance);
%     title('distance to center upon time');
%     hold off;
    
end

end