function plotSurvivalCurve(A,B)
%Camille Paoletti - 10/2014
%plot survival curve for data in A and B

[f1,x1] = ecdf(A,'function','survivor');
[f2,x2] = ecdf(B,'function','survivor');
figure; 
stairs(x1,f1,'b-','LineWidth',2);
hold on;
stairs(x2,f2,'r-','LineWidth',2);
legend('30°C','37°C');
xlabel('Generations');
ylabel('Survival');
text(30,0.8,strcat('30°C: median=',num2str(median(A)),' (n=',num2str(length(A)),'cells)'), 'Color', 'b');
text(30,0.7,strcat('37°C: median=',num2str(median(B)),' (n=',num2str(length(B)),'cells)'), 'Color', 'r');
hold off;



end