n=3;
Colors={'Blue','Green','Purple'};
Temp=[30,40,42];

t=[8 9 10 11 12 13 14 15 16 17 18];
t=t-t(1);
t=t*60;

clear A
clear E
A(2,:)=[0.03	0.04	0.05	0.083333333	0.11	0.14	0.186666667	0.26	0.353333333	0.486666667 0.673333333];
A(3,:)=[0.03	0.043333333	0.05	0.086666667	0.103333333	0.116666667	0.12	0.133333333	0.146666667	0.156666667 0.176666667];
A(1,:)=[0.03	0.036666667	0.05	0.073333333	0.106666667	0.143333333	0.213333333	0.313333333	0.45	0.653333333 0.88];

A=A./repmat(A(:,1),1,size(A,2));
A=log(A);

E(2,:)=[0 0	0 0.068002067 0	0 0.031215725 0.038482893 0.042969442 0.042406547 0.045727382];
E(3,:)=[0 0.128831989 0 0.068002067 0.055027358 0.050236042	0 0.042786258 0.039833053 0.037261333 0.033000426];
E(1,:)=[0 0.166093322 0	0.077094385	0.055027358	0.039833053	0.026858344	0.01833012 0.022226339 0.008814679 0.01957307];

numel=find(E==0);
E(numel)=0.005;


P=zeros(n,2);
crop=[5:10];
t_crop=t(crop);
Y=zeros(n,length(t_crop));
figure;
for i=1:n
    p = polyfit(t_crop,A(i,crop),1);
    y = polyval(p,t_crop);
    P(i,:)=p;
    Y(i,:)=y;
    log(2)/p(1)
    [a,b,c,d]=linearRegression(t_crop,A(i,crop),E(i,crop),'r+','r-',0);
    incert=sqrt((c/a)^2)*log(2)/a;
    Incert(i)=incert;
end



figure;%plot(t,A,'+');
hold on;
for i=1:n
    errorbar(t,A(i,:),E(i,:),'xr','Color',rgb(Colors{i}));
end
text(0,2,'temps de doublement normalisé:');
%plot(t_crop,Y,'LineWidth',1);
title('Croissance à différentes températures - souche CP03-1');
xlabel('Temps (min)');
ylabel('Densité optique : log(DO/DO_0)');
legend('30°C','40°C','42°C','Location','NorthWest');
for i=1:n
    plot(t_crop,Y(i,:),'LineWidth',1,'Color',rgb(Colors{i}));
    text(0,2-i*0.2,[num2str(Temp(i)), '°C : ',num2str(((log(2)/P(i,1))/(log(2)/P(1,1))))]);
    %text(0,2-i*0.2,[num2str(Temp(i)), '°C : ',num2str(round(log(2)/P(i,1))), ' min']);
end
xlim([-10 t(end)+10]);
hold off;
fig=gcf;
set(findall(fig,'-property','FontSize'),'FontSize',12);