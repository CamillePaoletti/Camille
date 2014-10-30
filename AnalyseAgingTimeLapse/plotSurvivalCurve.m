function plotSurvivalCurve(A,B)
%Camille Paoletti - 10/2014
%plot survival curve for data in A and B

[f1,x1] = ecdf(B,'function','survivor');
[f2,x2] = ecdf(A,'function','survivor');
figure; 
stairs(x1,f1,'b-');
hold on;
stairs(x2,f2,'r-');
legend('30°C','37°C');
hold off;



end