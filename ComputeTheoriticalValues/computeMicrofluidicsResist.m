l=143;
w=10;
h=15;

L=1;
W=75;
H=75;


n=[1:2:1001];
n5=n.*n.*n.*n.*n.*n;
sum1=1./n5.*tanh(n*(pi*w/(2*h)));
sum1tot=sum(sum1);
r=l/(w*h^3)/(1-(h/w*(192/pi^5)*sum1tot));