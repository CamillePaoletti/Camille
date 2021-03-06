function []=simulationCountMotherUponTimeMonoSimulation(filepath,bud,agg)
%Camille Paoletti - 02/13
%
%count number of aggregate in mother and daughter among time for a folder "filepath" containing .txt file filename corresponding to different time points

%filepath='/Volumes/charvin/paoletti/Simulations/data/fixedConcWoAgg/Rbud_650/summary';

%volume=@(x) 4/3*pi*x^3;
%mass = @(x) (x/0.0515)^(1/0.392) ;
%radius = @(x) 0.0515*x^.392 ;
Rcell=2500;
Rcontact=650;
if bud
    Rbud=bud;
else
    Rbud=940;
end
R0=940;
Rm=Rcell;
T=5400;
t=[0:100:T];
n=length(t);

[Vi,RatioV,Vcelli,Vbudi]=computeCellTotvolume(Rcell,Rbud,Rcontact);

radius=@(x) ((3*x)/(4*pi))^(1/3);
volume=@(x) 4/3*pi*x^3;
%evolutionVolume=@(x) volume(R0)+volume(Rm)*(exp(log(2)*x/T)-1);
evolutionVolume=@(x) Vi*2^(x/T);

evV=zeros(length(t),1);
evR=zeros(length(t),1);

cc=0;
for i =t
    cc=cc+1;
    evV(cc,1)=evolutionVolume(i);
    evR(cc,1)=radius(evV(cc)-Vcelli);
end


massM=zeros(n-1,1);
massD=zeros(n-1,1);
ratioCC=zeros(n-1,1);


tim=0;
for i=t(2:end)
    tim=tim+1;
    filename=strcat(filepath,'/',num2str(i),'.txt')
    [aggM,aggD,nM,nD]=simulationCountMotherMonoSimulation(filename);
    if bud
        Rbud=bud;
        [V,RatioV,Vcell,Vbud]=computeCellTotvolume(Rcell,Rbud,Rcontact)
    else
        Rbud=evR(tim+1,1);
        [V,RatioV,Vcell,Vbud]=computeCellTotvolume(Rcell,Rbud,Rcontact)
    end
    massM(tim,1)=sum(aggM(:,5));
    massD(tim,1)=sum(aggD(:,5));
    ratioCC(tim,1)=massD(tim,1)/massM(tim,1)/RatioV;    
end

st=std(ratioCC(:,1))

tit = 'Evolution of ratio of concentration of fluorescence in bud versus mother';

if bud
    tit2=strcat('Rbud = ',num2str(bud),' nm');
else
    tit2='growing bud';
end

if agg
    tit2=strcat(tit2,' - with aggregation');
else
    tit2=strcat(tit2,' - without aggregation');
end

figure;
plot(t(2:end)./60,ratioCC,'LineWidth',2);
hold on;
title({tit,tit2},'Fontsize',12);
xlabel('time (min)','Fontsize',12);
ylabel('ratio of concentration','Fontsize',12);
xlim([0 5400/60]);
ylim([0 2]);
hold off;

end