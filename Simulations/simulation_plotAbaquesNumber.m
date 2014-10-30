function []=simulation_plotAbaquesNumber()
%Camille Paoletti - 01/2014
%import

filepath='/Volumes/data7/paoletti/Simulations/data/abaques_noGrowth/';
filename={'number','mass','area'};

nthr=5;
nr=3;
nn=4;

R=[8,20,100];
N=[1000,3800,10000,23000];
Col={'r','g','b'};
Mark={'-','*','-*','--'};

number=ones(100,201,nthr,nr,nn);
area=zeros(100,201,nthr,nr,nn);
mass=zeros(100,201,nthr,nr,nn);


for r=1:nr% R=8-20-100
    for n=1:nn% N=1000-3800-10000-23000
        filepath_temp=strcat(filepath,'R_',num2str(R(r)),'-N_',num2str(N(n)),'/compute/');
        for h=1:3
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
                end
            end
        end
    end
end

NUM=mean(number,1);
plotfig(NUM,Col,Mark,nthr,nr,nn,R,N);
MASS=mean(mass,1);
plotfig(MASS,Col,Mark,nthr,nr,nn,R,N);
AREA=mean(area,1);
plotfig(AREA,Col,Mark,nthr,nr,nn,R,N);
MASSMEAN=MASS./NUM;
plotfig(MASSMEAN,Col,Mark,nthr,nr,nn,R,N);

end

function plotfig(META,Col,Mark,nthr,nr,nn,R,N)

for k=1:nthr
    figure;
    str=cell(1,nr*nn);
    cc=0;
    hold on;
    for i=1:nr;
        for j=1:nn;
            cc=cc+1;
            plot(META(:,:,k,i,j),strcat(Col{i},Mark{j}));
            str{1,cc}=strcat('R=',num2str(R(i)),' - N=',num2str(N(j)));
        end;
    end;
    legend(str);
    hold off;
end


end

% B=number(1,:,:,1,:);
% C=permute(B,[2,3,5,1,4]);
% 
% for i=1:4
% figure;
% plot(C(:,:,i));
% ylim([0 25]);
% end