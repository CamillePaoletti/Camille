function V=computeVolumeCutBall(r,a)
%Camille Paoletti - 02/13
%computethe volume of a cut ball of radius R and of opening radius a

h=sqrt(r.^2-a.^2);

%volume cut ball without cone
Vwo=2*pi*(r.^3+r.^2.*h)/3;

%volume cone
Vc=pi*a.^2.*h/3;

%volume cut ball
V=Vwo+Vc;


end