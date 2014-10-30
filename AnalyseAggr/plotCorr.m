function h_fig=plotCorr(Data)

j=0;
x=[0:0.001:0.5];
for i=x;
    j=j+1;
    [cor(j),~,~,~,pval(j),s(j)]=alpha(Data,i,0);
end

figure;plot(x,cor);
figure;plot(x,pval);
figure;plot(x,s);
h_fig=gca;


end