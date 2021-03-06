function [aggM,aggD,nM,nD,ratioMass]=simulationCountMotherMonoSimulation(filename)
%Camille Paoletti - 02/13
%
%count number of aggregate in mother for a .txt file filename

Rcell=2500;
Rcontact=650;
Xcontact=sqrt(Rcell^2-Rcontact^2);

mass = @(x) (x/0.0515)^(1/0.392) ;
%radius = @(x) 0.0515*x^.392 ;


data=dlmread(filename);
ccM=0;
ccD=0;
aggM=zeros(1,5)
aggD=zeros(1,5)
for i=3:length(data)
    if data(i,1)<=Xcontact
        ccM=ccM+1;
        aggM(ccM,:)=[data(i,:),mass(data(i,4))];
        %aggM(ccM,6)=mass(data(i,4));
    else
        ccD=ccD+1;
        aggD(ccD,:)=[data(i,:),mass(data(i,4))];
        %aggD(ccD,6)=mass(data(i,4));
    end
end

n=1;
nM=zeros(n,1);
nD=zeros(n,1);

for j=1:n
    nM(j,1)=length(aggM(:,5));
    nD(j,1)=length(aggD(:,5));
end



%nMM=nM(find(nM~=0));
%nDD=nD(find(nD~=0));

length(data)
ccM
ccD
xM=mean(aggM(:,1))
xD=mean(aggD(:,1))
mM=mean(nM)
mD=mean(nD)
sM=std(nM)/sqrt(n)
sD=std(nD)/sqrt(n)
massM=sum(aggM(:,5))
massD=sum(aggD(:,5))
ratioMass=massD/massM
massM=mean(aggM(:,5))
massD=mean(aggD(:,5))

end