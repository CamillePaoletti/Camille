function MSD=diffusion1D(ntraj,nsteps,ref,randominit,R)

% ntraj : number of independent trajectories 

display=1;
% reflection conditions
%ref=1; % 1: reflection ; 0 : if particle is at the edge, it just cannnot go further
d=1/2; %diffusion coef
%R=10; % max radius allowed for diffusion - confinement radius

M=zeros(ntraj,nsteps);

if randominit==1
    M(:,1)=2*R*(rand(ntraj,1)-0.5);
else% random initial state
    M(:,1)=zeros(ntraj,1); % centered initial state
end

for i=2:nsteps
    ran=randi(2,ntraj,1); 
    ran(ran==1)=-sqrt(2*d); ran(ran==2)=sqrt(2*d);
  
    M(:,i)=M(:,i-1)+ran; % iterate
    
    out=find(abs(M(:,i))>R); % particles that went out
    if ref % reflective boundary conditions 
       %M(out,i)=sign(M(out,i))*(R-1); 
       M(out,i)=sign(M(out,i)).*(R - abs( abs(M(out,i))-R ) ); 
    else % adsorption boundary conditions
       M(out,i)=sign(M(out,i))*R;  
    end
    
end


% plotting
[MSD,errMSD]=computeMSD(M,'Gilles');
%[MSD2,errMSD2]=computeMSD(M,'Camille');
if display
    figure;
    errorbar(MSD,errMSD,'b-');
    hold on;
    %errorbar(MSD2,errMSD2,'r-');
    xlabel('time');
    ylabel('MSD');
    
    x=-2*R:1:2*R;
    
    figure, subplot(2,1,1); hist(M(:,1),x);
    ylabel('# Particles');
    title('Position of particles at the beginning of simulation');
    
    subplot(2,1,2); hist(M(:,nsteps),x);
    xlabel('Position');
    ylabel('# Particles');
    title('Position of particles at the end of simulation');
end




function [MSD,errMSD]=computeMSD(M,style)

MSD=zeros(size(M)); errMSD=MSD;

if strcmp(style,'Camille')
    
    cc=size(M,2);

    MSD_temp=zeros(size(M,1),cc-5);
    errMSD=zeros(1,cc-5);

for i=1:cc-6
    M0=M(:,1:end-i);
    M1=M(:,i+1:end);
    MSD_temp(:,i+1)=mean((M1-M0).*(M1-M0),2);
end

MSD=mean(MSD_temp,1);

errMSD(:,1)=std(MSD)./sqrt(size(MSD,1));

    
    
end


if strcmp(style,'Gilles')
   for i=1:size(M,2)/2
       m=floor(size(M,2)/i);
       cc=1;
       for j=1:m
           MSD(:,i)=MSD(:,i)+(M(:,i*(j-1)+i)-M(:,i*(j-1)+1)).^2;
           cc=cc+1;
       end
       
       MSD(:,i)=MSD(:,i)/(cc-1);
   end
   
   MSD=MSD(:,1:size(M,2)/2);
   
   MSD=mean(MSD,1);
   errMSD=var(MSD,0,1)./sqrt(size(M,1));
end


