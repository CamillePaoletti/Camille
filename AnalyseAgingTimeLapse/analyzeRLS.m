function analyzeRLS()

rlsdata=[20 36 12 10 18 39 11 24 30 19 18 21 25 14 11 17 40 29 17 24 15 4 21 18 29];
mean(rlsdata)

%
%[cdfe x]=ecdf(rlsdata,'frequency');
% cdfe=1-cdfe;

cdfe=[]

for i=1:max(rlsdata)
    pix=find(rlsdata>i);
    cdfe(i)=numel(pix)/length(rlsdata);
end
x=1:max(rlsdata);

 p1 = 1-cdf('Normal',0:40,19,9); % gaussian distribution
 
 p2= exp(-(0:60)/19);
 
 

 
 % cumulative plot
 figure, plot(x,cdfe,'Color','b'); hold on; plot(p1,'Color','r'); plot(p2,'Color','g');
 ylabel('survival');
 xlabel('generation');
 

 %failure rate
 %cdfe=cdfe(find(cdfe~=0));
 r=-diff(log(cdfe));
 
 dp1=-diff(log(p1));
 dp2=-diff(log(p2));
 
 figure, plot(x(1:end-1),r,'Color','b'); hold on; plot(dp1,'Color','r'); plot(dp2,'Color','g'); 
 ylabel('failure rate');
 xlabel('generation');




