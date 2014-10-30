function [timing,percent]=simulation_meanEscapeTime()
%Camille Paoletti - 02/2014
%extract mean escpae timing 

filepath='/Volumes/data7/paoletti/Simulations/data/probaExit/';

Ragg=[8 20 50 100 250];
Rcell=[940 1500 2000 2300 2500];
Rcont=[650 775 900];

nagg=length(Ragg);
ncell=length(Rcell);
ncont=length(Rcont);
timing=zeros(nagg,ncell,ncont,100);
percent=zeros(nagg,ncell,ncont);

for i=1:nagg
    for j=1:ncell
        for k=1:ncont
            file_temp=strcat(filepath,'Ragg_',num2str(Ragg(i)),'-Rcell_',num2str(Rcell(j)),'-Rcont_',num2str(Rcont(k)),'/timing.txt');
            disp(file_temp);
            A=importdata(file_temp);
            timing(i,j,k,:)=A;
            percent(i,j,k)=length(find(A<60*60));
        end
    end
end


end