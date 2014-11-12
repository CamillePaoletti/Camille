function [n,xmax,ymin,ymax,filename,hfig,strleg]=figure4_D(display)
%Camille Paoletti - 11/2014 - paper figure 4
%5 single trace - mean cyto level

%movie 140715-pos1
%n1=[30048,52073, 60086,80001,160607]
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

load('/Users/camillepaoletti/Documents/MATLAB/manuscript/fig-4-tcell_tot_30.mat');


number=[30048,52073,60086,80001,160607];
n=length(number);

xmax=0;
ymax=0;
ymin=Inf;

for i=1:n

    N=find([tcell_tot.N]==number(i));
    tcell=tcell_tot(1,N);
    first=tcell.detectionFrame;
    last=tcell.lastFrame;
    budT=tcell.budTimes;
    budInd=budT-first;
    budT=[first budT last];
    div=[budT(2:end)-budT(1:end-1)]*10;%div time in minutes
    fluo=[tcell.Obj.fluoCytoMean];%mean intensity in the cyto - change for "fluoCytoVar" for total intensity
    tim=[0:1:length(fluo)-1]*10/60;
    
    if tim(end)>xmax
         xmax=tim(end);
    end
    if max(fluo)>ymax
        ymax=max(fluo);
    end
    if min(fluo)<ymin
        ymin=min(fluo);
    end
    
    figure;
    
    plot(tim,fluo,'b-','LineWidth',2);
    xlabel('Time (hours)');
    hold on;
    plot(tim(budInd),fluo(budInd),'bo','LineWidth',1);
    %ylabel('Mean fluo intensity \nin cytoplasm');
    
    hfig(i)=gca;
    xlim([0 xmax+10]);
    ylim([0 ymax+10]);
    hold off;

end


strleg='Mean fluo intensity in cytoplasm (A.U.)';
filename='Figure4_D.pdf';
%figure4_DG(n,xmax,ymin,ymax,filename,hfig,strleg)

end