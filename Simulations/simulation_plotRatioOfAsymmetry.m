function [number,area,mass,radius]=simulation_plotRatioOfAsymmetry()
%Camille Paoletti - 02/2014
%import data from server and plot ratio of assymmetry for number and
%mass(fluo) for raw data and volume renormalization

filepath='/Volumes/data7/paoletti/Simulations/data/abaques_noGrowth/';
filename={'number','area','mass','radius'};

nthr=2;%number of threshold
nr=1;%number of different radius tested
nn=1;%number of different initial condition for number tested

R=[8,20,100];
N=[1000,3800,10000,23000];
thr=[0 50];
Col={'r','g','b'};
Mark={'-','*','-*','--'};

number=ones(100,201,2*nthr,nr,nn);
area=zeros(100,201,2*nthr,nr,nn);
mass=zeros(100,201,2*nthr,nr,nn);
radius=zeros(100,201,2,nr,nn);


for r=1:nr% R=8-20-100
    for n=1:nn% N=1000-3800-10000-23000
        filepath_temp=strcat(filepath,'R_',num2str(R(r)),'-N_',num2str(N(n)),'/computeMB/');
        for h=1:4
            str=strcat(filepath_temp,filename{h});
            for i=1:100
                str_temp=strcat(str,'/sim_',num2str(i),'.txt');
                disp(str_temp);
                A=importdata(str_temp);
                switch h
                    case 1
                        number(i,1:size(A,1),:,r,n)=A;
                        B=number(i,size(A,1),:,r,n);
                        C=repmat(B,[1 size(number,2)-size(A,1) 1]);
                        number(i,size(A,1)+1:end,:,r,n)=C;
                    case 2
                        area(i,1:size(A,1),:,r,n)=A;
                        B=area(i,size(A,1),:,r,n);
                        C=repmat(B,[1 size(area,2)-size(A,1) 1]);
                        area(i,size(A,1)+1:end,:,r,n)=C;
                    case 3
                        mass(i,1:size(A,1),:,r,n)=A;
                        B=mass(i,size(A,1),:,r,n);
                        C=repmat(B,[1 size(mass,2)-size(A,1) 1]);
                        mass(i,size(A,1)+1:end,:,r,n)=C;
                    case 4
                        radius(i,1:size(A,1),:,r,n)=A;
                        B=radius(i,size(A,1),:,r,n);
                        C=repmat(B,[1 size(radius,2)-size(A,1) 1]);
                        radius(i,size(A,1)+1:end,:,r,n)=C;
                end
            end
        end
    end
end

[conc_number]=compute_concentration(number,nthr,radius);
[conc_mass]=compute_concentration(mass,nthr,radius);
[conc_area]=compute_concentration(area,nthr,radius);

NUM=mean(number,1);
plotfig(NUM,Col,Mark,nthr,nr,nn,R,N,'number',thr);

MASS=mean(mass,1);
plotfig(MASS,Col,Mark,nthr,nr,nn,R,N,'mass',thr);

AREA=mean(area,1);
plotfig(AREA,Col,Mark,nthr,nr,nn,R,N,'area',thr);

MASSMEAN=MASS./NUM;
plotfig(MASSMEAN,Col,Mark,nthr,nr,nn,R,N,'mean mass',thr);

CCNUM=mean(conc_number,1);
plotfig(CCNUM,Col,Mark,nthr,nr,nn,R,N,'concentration number',thr);

CCMASS=mean(conc_mass,1);
plotfig(CCMASS,Col,Mark,nthr,nr,nn,R,N,'concentration mass',thr);

CCAREA=mean(conc_area,1);
plotfig(CCAREA,Col,Mark,nthr,nr,nn,R,N,'concentration area',thr);

end

function plotfig(META,Col,Mark,nthr,nr,nn,R,N,strtitle,thr)

for k=2%:nthr
    figure;
    cc=0;
    hold on;
    for i=1:nr;
        for j=1:nn;
            cc=cc+1;
            plot(META(:,:,k,i,j),'b-');%strcat(Col{i},Mark{j}));
            hold on;
            plot(META(:,:,k+nthr,i,j),'r-');%strcat(Col{i},Mark{j}));
            hold off;
        end;
    end;
    legend('mother','bud');
    title([strtitle,' - threshold = ',num2str(thr(k))]);
    hold off;
end


end

function [data_out]=compute_concentration(data,nthr,radius)
radi=repmat(radius(:,:,1,:,:),[1 1 nthr]);
Rcontact=ones(size(radi,1),size(radi,2),size(radi,3),size(radi,4),size(radi,5))*650;
Vcell=computeVolumeCutBall(radi,Rcontact);
data_out(:,:,1:nthr,:,:)=data(:,:,1:nthr,:,:)./Vcell;
radi=repmat(radius(:,:,2,:,:),[1 1 nthr]);
Vcell=computeVolumeCutBall(radi,Rcontact);
data_out(:,:,nthr+1:2*end,:,:)=data(:,:,nthr+1:end,:,:)./Vcell;
end


% B=number(1,:,:,1,:);
% C=permute(B,[2,3,5,1,4]);
% 
% for i=1:4
% figure;
% plot(C(:,:,i));
% ylim([0 25]);
% end