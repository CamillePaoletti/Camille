function hfig=figure4_H()
%Camille Paoletti - 11/2014 - paper figure 4
%mean (over 20 single traces) Hsp104 in foci 

%movie 140609-pos1
%position 1: n1=[10233,20138,60913,70256,90743,130543,140491,160867,179999,190060,200602,261168];
%position 2: n2=[11157,20149,51000,61730,70990,100356,110561,162225];

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


load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-4-tcell_tot.mat');

n=length(tcell_tot);

xmax=0;
ymax=0;
ymin=Inf;

for i=1:n
    tcell=tcell_tot(1,i);
    fluo=[tcell.Obj.fluoNuclVar];%total intensity of pix in foci (with substracted background)
    tim=length(fluo);
    
    if tim>xmax
         xmax=tim(end);
    end
    if max(fluo)>ymax
        ymax=max(fluo);
    end
    if min(fluo)<ymin
        ymin=min(fluo);
    end
end

fluo_tot=nan(n,xmax);

for i=1:n
    tcell=tcell_tot(1,i);
    first=tcell.detectionFrame;
    last=tcell.lastFrame;
    %duration=last-first+1;
%     budT=tcell.budTimes;
%     budT=[first budT last];
    %div=[budT(2:end)-budT(1:end-1)]*10;%div time in minutes
    duration=length([tcell.Obj.fluoNuclVar]);
    fluo_tot(i,1:duration)=[tcell.Obj.fluoNuclVar];%total intensity of pix in foci (with substracted background)

end


m=nan(1,xmax);
s=nan(1,xmax);
for i=1:xmax
    temp=fluo_tot(:,i);
    numel=find(~isnan(temp));
    temp=temp(numel);
    m(i)=mean(temp);
    s(i)=std(i)/sqrt(length(temp));
end

tim=[0:1:length(m)-1]*10/60;

figure;
plot(tim,m,'r-');
hold on;
errorbar(tim,m,s,'.r','MarkerSize',2,'Color','r');

xlabel('Time (hours)');
ylabel('Mean fluo intensity in foci (A.U.)');
xlim([0 45]);
ylim([0 2.5e5]);
hold off;
hfig=gca;

end