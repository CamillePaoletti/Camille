function [A,B,a,b]=linearRegression(X,Y,y,point,fit,newFigure)
%Camille Paoletti - 04/2013


if size(X,1)==1
    X=transpose(X);
end

if size(Y,1)==1
    Y=transpose(Y);
end

if size(y,1)==1
    y=transpose(y);
end


%prod=sum(X.*Y);
%Xprod=mean(X)*sum(X);
%Xsq=sum(X.*X);
%A=(prod-mean(X)*sum(Y))/(Xsq-mean(X)*sum(X));
%B=(mean(y)*Xsq-mean(X)*prod)/(Xsq-mean(X)*sum(X));

N=length(X);


if newFigure
    figure;
end
hold on;
errorbar(X,Y,y,point);

yy=y.*y;
XX=X.*X;

S=sum(1./yy);
Sx=sum(X./yy);
Sy=sum(Y./yy);
Sxx=sum(XX./yy);
Sxy=sum(X.*Y./yy);
delta=S*Sxx-(Sx)^2;

disp('Fit A*X+B');
A=(S*Sxy-Sx*Sy)/delta
B=(Sxx*Sy-Sx*Sxy)/delta


Yfit=A.*X+B;
plot(X,Yfit,fit);

disp('error a on slope and b on intercept');
a=sqrt(S/delta)
b=sqrt(Sxx/delta)

covarianceAB=-Sx/delta;

rAB=-Sx/sqrt(S*Sxx)


Bvect=ones(N,1);

CHI2=sum(((Y-Bvect-A*X)./y).*((Y-Bvect-A*X)./y))

disp('If Q is larger than 0.1, then the goodness-of-fit is believable');
Q =gammainc((N-2)/2,CHI2/2,'upper')

hold off;

end