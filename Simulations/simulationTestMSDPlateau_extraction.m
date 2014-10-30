function [x,y,z]=simulationTestMSDPlateau_extraction(path,N)
%Camille Paoletti - 01/2014
%extract coordinates of the 100 simulations saved in path

%path='/Volumes/data7/paoletti/Simulations/data/MSD/T_1';

filepath=strcat(path,'/sim_',num2str(1),'/coordinates.txt');
data=load(filepath);
x=data(1:N:end,1);
y=data(1:N:end,2);
z=data(1:N:end,3);
n=size(x,1);
x=zeros(100,n);
y=zeros(100,n);
z=zeros(100,n);

for i=1:100
    filepath=strcat(path,'/sim_',num2str(i),'/coordinates.txt');
    %disp(['loading: ',filepath]);
    data=load(filepath);
    x(i,:)=data(1:N:end,1);
    y(i,:)=data(1:N:end,2);
    z(i,:)=data(1:N:end,3);
end

end
