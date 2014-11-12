function hfig=figure4_B()
%Camille Paoletti - 11/2014 - paper figure 4
%1) time series cell n° number
%2) division timings cell n° number
%3) Hsp104 cytoplasmic level trajectory cell n° number

global segmentation;
global timeLapse;
% fprintf('loading project \n');
% load(strcat(folder,'/',file,'-project.mat'));
% fprintf('project loaded \n');
% fprintf('loading segmentation \n');
% load(strcat(folder,'/',file,'-pos',num2str(pos),'/segmentation-autotrack.mat'));
% fprintf('segmentation loaded \n');
number=13XXXX;
N=find([segmentation.tcells1.N]==number);
tcell=segmentation.tcells1(1,N);
first=tcell.detectionFrame;
last=tcell.lastFrame;

% loading data (segmentation.position and tcell to plot)
%load(filename);

budT=tcell.budTimes;
budT=[first budT last];
div=[budT(2:end)-budT(1:end-1)]*10;%div time in minutes
fluo=[tcell.Obj.fluoCytoMean];%mean intensity in the cyto - change for "fluoCytoVar" for total intensity
tim=[0:1:length(fluo)-1]*10/60;


%1)
hf=phy_plotMontageFoci2([426:60:845,846],[1 1 [1 1 1] [2000 13000];3 2 [1 1 1] [425 800]],[44 973 110 110],1,10,N,1);
myExportFig('Figure4_A-1.pdf','-pdf','-transparent');

%2&3)
[hfig,hc]=figure4_plotSeries(div,tim,fluo,'Figure4_B')
%[hfig,hc]=figure4_plotSeries(div,tim,fluo);

%mounting and saving figure 2&3
%figure4_exportPlotSeries('Figure4_A.png',hfig,hc);

end