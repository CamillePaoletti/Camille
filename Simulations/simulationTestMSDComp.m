function simulationTestMSDComp()
%Camille Paoletti - 06/2013
%compare 2 different simulations dR~t and dR~qrt(t)


path{1}='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusion/1_100/coordinates.txt';
path{2}='/Users/camillepaoletti/Documents/Lab/Simulations/SimulationAggregation/test/test_diffusionT/1_100/coordinates.txt';
tit={'sqrt(t)','t'};
N=1;
step=1;%time step in sec

for i=1:2
    data=load(path{i});
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
    
    MSD=MSD.*10^-6;
    MSD2=MSD2.*10^-6;
    MSD3=MSD3.*10^-6;
    MSD3D=MSD3D.*10^-6;
    
    
    n=length(MSD(:,1));
    
    figure(1);
    % errorbar(xd,yd,errd,'g+','LineWidth',2);
    subplot(1,2,i);
    plot([0:step:(n-1)*step],MSD(:,1),'k-');
    hold on;
    plot([0:step:(n-1)*step],MSD2(:,1),'b-');
    plot([0:step:(n-1)*step],MSD3(:,1),'g-');
    plot([0:step:(n-1)*step],MSD3D(:,1),'r-');
    % plot(xd,yfit,'g-');
    ylim([0 5e-1]);
    legend('x-y','x-z','y-z','3D');
    xlabel('time (s)');
    ylabel('MSD (µm^2/s)');
    title(tit{i});
    hold off;
    
    figure(2);
    % errorbar(xd,yd,errd,'g+','LineWidth',2);
    subplot(1,2,i);
    loglog([0:step:(n-1)*step],MSD(:,1),'k-');
    hold on;
    loglog([0:step:(n-1)*step],MSD2(:,1),'b-');
    loglog([0:step:(n-1)*step],MSD3(:,1),'g-');
    loglog([0:step:(n-1)*step],MSD3D(:,1),'r-');
    % plot(xd,yfit,'g-');
    legend('x-y','x-z','y-z','3D');
    xlabel('time (s)');
    ylabel('MSD (µm^2/s');
    title(tit{i});
    hold off;
    
    
end

end