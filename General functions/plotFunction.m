function []=plotFunction
%Camille Paoletti - 10/2012
%plot a function given in funct


X=[0:0.1:5*1e0];

%funct1=@(x) exp(1/x)*(1/x)^2/(1+exp(1/x))^2;
funct1=@(x) (1/x)^2/(sinh(1/x))^2;
%funct1=@(x) exp(-1/x)/(2*sinh(1/x));

n=length(X);
h1=zeros(1,n);
h2=zeros(1,n);


for i=1:n
    h1(1,i)=funct1(X(1,i));
    %h2(1,i)=funct2(X(1,i));
end

figure;
plot(X,h1);
hold on;
%plot(X,h2,'r');
%legend('h1','h2');
hold off;

end
