function simulation_initialDensityEffect(ntraj,space,nsteps)

%Camille Paoletti - 02/2014
%plot evoltuion of aggregate number in function of time for different
%initial density

density=[0.01 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5];
Colors={'m-','y-','c-','r-','g-','b-','k-','m-','y-','c-','r-','g-','b-','k-'};
n=length(density);

S=zeros(n,nsteps);

for i=1:n
    
    [S(i,:),lengt{i}]=aggregat1D(ntraj,space,nsteps,density(i));

end

figure;
leg={};
hold on;
for i=1:n
    plot(S(i,:),Colors{i});
    leg{i}=num2str(density(i));
end
xlabel('Time');
ylabel('Number of aggregates');
legend(leg);
title('Evolution of number of aggreagtes in function of initial density');
hold off;

figure
x=[0.5:1:20.5];
for i=1:n
    subplot(3,4,i);
    [n] = hist(lengt{i},x);
    bar(x,n./length(lengt{i}));
    title(['density=',num2str(density(i))]);
    xlim([0 20]);
    ylim([0 1]);
    MEAN(i)=mean(lengt{i});
    STD(i)=std(lengt{i});
    MEDIAN(i)=median(lengt{i});
    ERR(i)=STD(i)/sqrt(length(STD(i)));
    disp(['init=',num2str(density(i)),' - mean=', num2str(MEAN(i)),' - std=',num2str(STD(i)),' - median=',num2str(MEDIAN(i))]);
end

figure;
subplot(1,3,1); fit(density,MEAN,'mean');
subplot(1,3,2); fit(density,STD,'std');
subplot(1,3,3); fit(density,MEDIAN,'median');
hold off;

end

function [p,yout]=fit(x,y,ylab)
p=polyfit(x,y,1);
yout=polyval(p,x);
hold on;
plot(x,y,'b+');
plot(x,yout,'r-');
text(0.1,4,['y=ax+b',' - a=',num2str(p(1)),' - b=',num2str(p(2))]);
xlabel('initial density');
ylabel(ylab);
hold off;
end