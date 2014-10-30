function p=simulation_testTimeStep()
%Camille Paoletti  -01/2014
%plot mean MSD (over 100 sim) for different simulation dt_step with a same
%dt_save = 1 sec.
%extract mean diff coefficient (over the first "interp" sec)

path='/Volumes/data7/paoletti/Simulations/data/MSD_timeStep/';
path='/Volumes/data7/paoletti/Simulations/data/MSD_timeStep_R-10_dtsave-1/';
%path='/Volumes/data7/paoletti/Simulations/data/MSD_timeStep_R-129_dtsave-1/';
%x=[1 0.5 0.1 0.05 0.01 0.005 0.001 0.0005 0.0001 0.00005 0.00001 0.000005 0.000001];
x=[1 0.5 0.1 0.05 0.01 0.005 0.001 0.0005 0.0001 0.00005 0.00001 0.000005 0.000001];
%x=[0.001 0.005 0.01 0.05 0.1 0.5 1];
N=length(x);
p=zeros(1,N);
figure;
hold on;
for i=1:N
    path_temp=strcat(path,'T_',num2str(i));
    [p(i)]=simulationTestMSDPlateau(1,path_temp,3);
end
hold off;

figure;
semilogx(x,p/6,'b+');
ylim([0 0.035]);
hold on;
xlabel('Simulation Time Step (s)','fontsize',12);
ylabel('Diffusion Coefficient (µm^2/s)','fontsize',12);
hold off;
end