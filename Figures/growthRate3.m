

%DATA
n1=4;
n2=2;
n=n1+n2;
Colors={'Blue','Cyan','Green','Lime','OrangeRed','Red','Blue'};
Temp=[25,30,35,37,40,42];

t1=[9.5	10.5	11.25	12	13	14.7	15.33	16	17.16 18];
t1=t1-t1(1);
t1=t1*60;

t2=[8 9 10 11 12 13 14 15 16 17];
t2=t2-t2(1);
t2=t2*60;

clear A
clear E
A(1,:)=[-1.698970004	-1.522878745	-1.522878745	-2	-1.698970004	-1.522878745	-1.22184875	-1.134698574	-0.93305321	-0.786925175];
A(2,:)=[-1.698970004	-1.522878745	-1.43572857	-1.522878745	-1.301029996	-1.029963223	-0.795880017	-0.651046452	-0.443697499	-0.301029996];
A(3,:)=[-1.698970004	-1.522878745	-1.632023215	-1.698970004	-1.363177902	-1.096910013	-0.814363423	-0.651046452	-0.427903232	-0.26493365];
A(4,:)=[-1.698970004	-1.522878745	-1.477121255	-1.875061263	-1.477121255	-1.246672333	-1.014723257	-0.875061263	-0.632023215	-0.49034952];


A(1,:)=[0.02	0.03	0.03	0.01	0.02	0.03	0.06	0.073333333	0.116666667	0.163333333];
A(2,:)=[0.02	0.03	0.036666667	0.03	0.05	0.093333333	0.16	0.223333333	0.36	0.5];
A(3,:)=[0.02	0.03	0.023333333	0.02	0.043333333	0.08	0.153333333	0.223333333	0.373333333	0.543333333];
A(4,:)=[0.02	0.03	0.033333333	0.013333333	0.033333333	0.056666667	0.096666667	0.133333333	0.233333333	0.323333333];
A(5,:)=[0.03	0.04	0.05	0.083333333	0.11	0.14	0.186666667	0.26	0.353333333	0.486666667];
A(6,:)=[0.03	0.043333333	0.05	0.086666667	0.103333333	0.116666667	0.12	0.133333333	0.146666667	0.156666667];
A(7,:)=[0.03	0.036666667	0.05	0.073333333	0.106666667	0.143333333	0.213333333	0.313333333	0.45	0.653333333];

A=A./repmat(A(:,1),1,size(A,2));
A=log(A);

E(1,:)=[0 0 0 0	0 0	0 0.077094385 0.050236042 0.092447475];
E(2,:)=[0 0 0.166093322 0 0 0.060829922 0	0.025664237	0.027785819	0.020003001];
E(3,:)=[0 0 0.348237453	0 0.128831989 0	0.037261333	0.067781173	0.060829922	0.058330294];
E(4,:)=[0 0 0.166093322 0.400188711	0.166093322	0.194262336	0.280308068	0.166093322	0.173424688	0.203447081];
E(5,:)=[0 0	0 0.068002067 0	0 0.031215725 0.038482893 0.042969442 0.042406547];
E(6,:)=[0 0.128831989 0 0.068002067 0.055027358 0.050236042	0 0.042786258 0.039833053 0.037261333];
E(7,:)=[0 0.166093322 0	0.077094385	0.055027358	0.039833053	0.026858344	0.01833012 0.022226339 0.008814679];


numel=find(E==0);
E(numel)=0.005;


P=zeros(n,2);
crop=[5:10];
clear t_crop Incert;
t_crop=t1(crop);
Y=zeros(n,length(t_crop));
figure;
for i=1:n1
    p = polyfit(t_crop,A(i,crop),1);
    y = polyval(p,t_crop);
    P(i,:)=p;
    Y(i,:)=y;
    log(2)/p(1)
    [a,b,c,d]=linearRegression(t_crop,A(i,crop),E(i,crop),'r+','r-',0);
    incert=sqrt((c/a)^2)*log(2)/a;
    Incert(i)=incert;
end
num=find(Incert(:)<1);
Incert(num)=ones(1,length(num));

t_crop=t2(crop);
for i=n1+1:n
    p = polyfit(t_crop,A(i,crop),1);
    y = polyval(p,t_crop);
    P(i,:)=p;
    Y(i,:)=y;
    log(2)/p(1);
    [a,b,c,d]=linearRegression(t_crop,A(i,crop),E(i,crop),'r+','r-',0);
    incert=sqrt((c/a)^2)*log(2)/a;
    Incert(i)=incert;
end

for i=1:n
    DT(i)=log(2)/P(i,1);
end

%FIGURE 1: RAW DATA
figure;%plot(t,A,'+');
hold on;
for i=1:n1
    errorbar(t1,A(i,:),E(i,:)*2,'.r','MarkerSize',7,'Color',rgb(Colors{i}));
end
for i=n1+1:n
    errorbar(t2,A(i,:),E(i,:)*2,'.r','MarkerSize',7,'Color',rgb(Colors{i}));
end
%text(0,2,'temps de doublement :');
%plot(t_crop,Y,'LineWidth',1);
%title('Croissance à différentes températures - souche CP03-1');
xlabel('Temps (min)');
ylabel('Densité optique : log(DO/DO_0)');
for i=1:n1
    plot(t1(crop),Y(i,:),'LineWidth',1,'Color',rgb(Colors{i}));
end
for i=n1+1:n
    plot(t2(crop),Y(i,:),'LineWidth',1,'Color',rgb(Colors{i}));
end

% for i=1:n
%     %text(0,2-i*0.2,[num2str(Temp(i)), '°C : ',num2str(((log(2)/P(i,1))/(log(2)/P(2,1))))]);
%     text(0,2-i*0.2,[num2str(Temp(i)), '°C : ',num2str(round(DT(i))), ' min']);
% end
xlim([-10 t2(end)+10]);
hold off;
fig=gca;
set(findall(fig,'-property','FontSize'),'FontSize',12);

%FIGURE 2: SUMMARY DOUBLING TIME
figure;
x=[1:1:length(Temp)];
str=[];
for i=1:n
    str{1,i}=[num2str(Temp(i)),'°C'];
end
bar(x,DT, 'facecolor',rgb('Grey'));
hold on;
errorbar(x,DT,2*Incert,'.r','MarkerSize',1,'Color','k');
%xlabel('Température (°C)');
ylabel('Temps de doublement (min)');
set(gca,'XTickLabel',str);
hold off;
xlim([0.5 length(Temp)+0.5]);
fig2=gca;
set(findall(fig2,'-property','FontSize'),'FontSize',12);

%FIGURE FINALE
hFig = figure;
pos=get(hFig,'Position');
set(hFig, 'Position', [pos(1) pos(2) pos(3) pos(4)]);
use_panel = 1;
clf

% PREPARE
if use_panel
	p = panel();
    p.pack(100);
end

fsize=12;
p.fontsize = fsize ;
p.margin = [20 15 7 10];%marginleft, marginbottom, marginright, margintop

% pack two absolute-packed panels into one of them
p(1).pack({[0 0 1 1]}); % main plot (fills parent)
p(1).pack({[0.1 0.45 0.5 0.5]}); % inset plot (overlaid)

% p.select('all');
% p.identify();

%return

% NB: margins etc. should be applied to p(2), which is the
% parent panel of p(2, 1) (the main plot) and p(2, 2) (the
% inset).

%% (b)

% select sample data into all
p(1,1).select(fig2);
set(gca,'YTick',[0:100:600]);
set(gca,'YTickLabel',{'0','100','200','300','400','500','600'});
p(1,2).select(fig);
legend('25°C','30°C','35°C','37°C','40°C','42°C','Location','SouthEast');






