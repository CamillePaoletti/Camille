function [n,m,s,pval]=figure4_I()
%Camille Paoletti - 11/2014 - paper figure 4
%mean (over 20 single traces) Hsp104 in foci

%movie 140609-pos1
%position 1: n1=[10233,20138,60913,70256,90743,130543,140491,160867,179999,190060,200602,261168];
%position 2: n2=[11157,20149,51000,61730,70990,100356,110561,162225];

%movie 140715-pos1
%position 1: n1=[];

%to build tcell_tot
%%%%%%LOADING FIRST SEG VARIABLE (pos1)
% n=length(n1);
% cc=1;
% tcell_tot=phy_Tobject;
% for i=1:n
%     N=find([segmentation.tcells1.N]==n1(i));
%     tcell=segmentation.tcells1(1,N);
%     tcell_tot(1,cc)=tcell;
%     cc=cc+1;
% end
%
% %%%%%BE CAREFUL, LOADING SECOND SEG VARIABLE (pos2) !!!!!
% n=length(n2);
% for i=1:n
%     N=find([segmentation.tcells1.N]==n2(i));
%     tcell=segmentation.tcells1(1,N);
%     tcell_tot(1,cc)=tcell;
%     cc=cc+1;
% end


tcell_tot{1}=load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-4-tcell_tot.mat');%load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-4-tcell_tot_30.mat');
tcell_tot{2}=load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-4-tcell_tot.mat');

for j=1:2
    
    div_tot=[];
    
    tcell_temp=tcell_tot{j}.tcell_tot;
    n=length(tcell_temp);
    
    xmax=0;
    ymax=0;
    ymin=Inf;
    
    for i=1:n
        tcell=tcell_temp(1,i);
        %first=tcell.detectionFrame;
        %last=tcell.lastFrame;
        %duration=last-first+1;
        budT=tcell.budTimes;
        %budT=[first budT last];
        div=[budT(2:end)-budT(1:end-1)]*10;%div time in minutes
        [t1 t2 mid x y tdiv fdiv]=findSEP(div,1);
        if j==2
            if i==3||5||9||15
                div_tot=[div_tot div(1:mid)];
            else
                div_tot=[div_tot div];
            end
        else
            div_tot=[div_tot div(1:mid)];
        end
    end
    
    d{j}=div_tot;
    n(j)=length(div_tot);
    m(j)=mean(div_tot);
    s(j)=std(div_tot)/sqrt(n(j));
    
   
end

pval = ranksum(d{1},d{2});

end