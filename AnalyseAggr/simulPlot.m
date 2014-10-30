

n=75;%100;
Ab=zeros(n+1,1);

for i=0:n
k=500+i*100;
S=load(strcat('/Users/camillepaoletti/Documents/Lab/Simulations/simulationAggrDiffusion2D/simulationAggrDiffusion2D/timing/CI_10_',num2str(k),'.txt'));
B(i+1,:)=S(:,2);
Ab(i+1,1)=k;
end

m=mean(B,2);
s=std(B,0,2);
sError=std(B,0,2)./size(B,2);

figure;
errorbar(Ab,m,sError);


rp=zeros(n,1);
rh=zeros(n,1);
for i=1:n
   [p,h] = ranksum(B(10,:),B(i+1,:));
   rp(i)=p;
   rh(i)=h;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=4;
B=zeros(4,100);
Ab=zeros(4,1);
for i=0:n
k=10^i;
S=load(strcat('/Users/camillepaoletti/Documents/Lab/Simulations/simulationAggrDiffusion2D/simulationAggrDiffusion2D/timing/RCI_',num2str(k),'_2500_3000.txt'));
B(i+1,:)=S(:,2);
Ab(i+1,1)=k;
end

m=mean(B,2);
s=std(B,0,2);
sError=std(B,0,2)./size(B,2);

figure;
errorbar(Ab,m,sError);

rp=zeros(n,n);
rh=zeros(n,n);
for i=1:n+1
    for j=1:n+1
   [p,h] = ranksum(B(i,:),B(j,:));
   rp(i,j)=p;
   rh(i,j)=h;
    end
end