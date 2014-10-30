function [p]=simulationTestMSDPlateau(N,path,interp)
%Camille Paoletti - 01/2014
%plot mean MSD over 100 simulations for the simulations saved in path
%after having running simulationTestMSDPlateau_extraction(path)
%ex:
%path='/Volumes/data7/paoletti/Simulations/data/MSD/T_1';

[X,Y,Z]=simulationTestMSDPlateau_extraction(path,N);

N=1;
dt=1;
display = 1;

pixel=1e-3
pixel2=pixel*pixel;

% filepath=strcat(path,'/sim_',num2str(1),'/coordinates.txt');
% data=load(filepath);
% x=data(1:N:end,1);
% y=data(1:N:end,2);
% z=data(1:N:end,3);
% [MSD3D,]=computeMSD3D(x,y,z,0);
% n=size(MSD3D,1);
% MSD3D=zeros(100,n);


for i=1:100
%     filepath=strcat(path,'/sim_',num2str(i),'/coordinates.txt');
%     disp(['loading: ',filepath]);
%     data=load(filepath);
%     x=data(1:N:end,1);
%     y=data(1:N:end,2);
%     z=data(1:N:end,3);
    %disp(['computing MSD n°',num2str(i)]);
    x=X(i,1:N:end);
    y=Y(i,1:N:end);
    z=Z(i,1:N:end);
%     [MSD,err]=computeMSD(x,y,0);
%     [MSD2]=computeMSD(x,z,0);
%     [MSD3]=computeMSD(~y,z,0);
    [MSD,~]=computeMSD3D(x,y,z,0);
    MSD3D(i,:)=transpose(MSD(:,1));
end

n=size(MSD3D,2);
MSD=mean(MSD3D,1);
errMSD=std(MSD3D)./sqrt(size(MSD3D,1));
t=[0:1:n-1];
t=t.*dt;
tmin=t/60;

%interp=15;
y=MSD(1,1:interp)*pixel2;
x=t(1,1:interp);
p=polyfit(x,y,1);
val=polyval(p,x);
disp(p);
p=p(1);

if display
%     figure;
    hold on;
    plot(tmin,MSD*pixel2,'b-');
    %errorbar(tmin,MSD*pixel2,errMSD*pixel2,'b-');
    plot(tmin(1:interp),val,'r-');
    title('Mean Square Displacement','fontsize',12);
    xlabel('Time (min)','fontsize',12);
    ylabel('Mean Square Displacement (µm^{2})','fontsize',12);
    %ylim([0 5e5]);
    hold off;
    
%     figure;
%     plot(log(tmin),log(MSD*pixel2));
end

end

% N=20;
% x=t(1:N);
% y=MSD(1:N)*pixel2;
% p = polyfit(x,y,1);
% Y = polyval(p,x);
% 
% figure;
% % errorbar(xd,yd,errd,'g+','LineWidth',2);
% plot(t,MSD*pixel2,'b*');
% hold on;
% title('Mean Square Displacement','fontsize',12);
% xlabel('Time (s)','fontsize',12);
% ylabel('Mean Square Displacement (µm^{2})','fontsize',12);
% plot(x,Y,'r-');
% %ylim([0 5e5]);
% hold off;
% disp(p);
% 
% figure;
% % errorbar(xd,yd,errd,'g+','LineWidth',2);
% loglog(MSD*pixel2,'k-');
