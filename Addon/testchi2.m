function [ pval ] = testchi2( a , b , c , d )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


t1=a+b;
t2=c+d;
t3=a+c;
t4=b+d;
t5=t1+t2;

expa=(t1*t3)/t5;
expb=(t1*t4)/t5;
expc=(t2*t3)/t5;
expd=(t2*t4)/t5;


obs=[a b c d];
expect=[expa expb expc expd];

for i=1:length(expect)
   if expect(i)<5
      expect(i)
      fprintf('valeur théorique inferieure à 5 !');
   end
end
delta=obs-expect;
chi2stat=sum(delta.^2 ./ expect);

pval=1 - chi2cdf(chi2stat,1); 
end

