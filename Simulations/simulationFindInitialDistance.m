function []=simulationFindInitialDistance()

b=1300;
R1=2500;
R2=940;

delta=(2*(R1^2+R2^2)-b^2)^2-4*(R2^2-R1^2)^2;
a1=(2*(R1^2+R2^2)-b^2+sqrt(delta))/2;
a2=(2*(R1^2+R2^2)-b^2-sqrt(delta))/2;

x1=sqrt(a1)
x2=sqrt(a2)

%x=3250;
%b_exp=sqrt(2*(R1^2+R2^2)-(x^2+((R2^2-R1^2)/x)^2))


X=[0.001:1:R1+R2];
%X=[1718:0.001:1719];
%X=[3122:0.001:3123];


n=length(X);
A=zeros(n,1);

h=@(x) -x^4+(2*(R1^2+R2^2)-b^2)*x^2-(R2^2-R1^2)^2;


for i=1:n
    A(i)=h(X(i));
end


figure;
plot(X,A);


end