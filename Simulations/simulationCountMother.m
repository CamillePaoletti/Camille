function [aggM,aggD,nM,nD,ratioMass]=simulationCountMother(filename)
%Camille Paoletti - 12/12
%
%count number of aggregate in mother for a .txt file filename

threshold=0;
Rcell=2500;
Rcontact=650;
Xcontact=sqrt(Rcell^2-Rcontact^2);

mass = @(x) (x/0.0515)^(1/0.392) ;
%radius = @(x) 0.0515*x^.392 ;

aggM=zeros(1,6);
aggD=zeros(1,6);


data=dlmread(filename);
ccM=0;
ccD=0;
for i=1:length(data)
    if data(i,1)<=Xcontact
        if data(i,4)>=threshold
            ccM=ccM+1;
            aggM(ccM,:)=[data(i,:),mass(data(i,4))];
            %aggM(ccM,6)=mass(data(i,4));
        end
    else
        if data(i,4)>=threshold
            ccD=ccD+1;
            aggD(ccD,:)=[data(i,:),mass(data(i,4))];
            %aggD(ccD,6)=mass(data(i,4));
        end
    end
end

n=max(max(aggM(:,5)),max(aggD(:,5)))
nM=zeros(n,1);
nD=zeros(n,1);

for j=1:n
    temp=find(aggM(:,5)==j);
    nM(j,1)=length(temp);
    temp=find(aggD(:,5)==j);
    nD(j,1)=length(temp);
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
massM=sum(aggM(:,6))
massD=sum(aggD(:,6))
ratioMass=massD/massM
massM=mean(aggM(:,6))
massD=mean(aggD(:,6))

end