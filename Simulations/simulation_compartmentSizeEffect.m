function [S,lengt]=simulation_compartmentSizeEffect(ntraj,nsteps,density)

%Camille Paoletti - 02/2014
%plot evoltuion of aggregate number in function of time for different
%initial density

space=[10 20 30 50 100 250 500 600 700 800 1000 10000];
Colors={'m-','y-','c-','r-','g-','b-','k-','m*-','y*-','c*-','r*-','g*-','b*-','k*-'};
n=length(space);

S=zeros(n,nsteps);

for i=1:n
    
    [S(i,:),lengt{i}]=aggregat1D(ntraj,space(i),nsteps,density);

end

figure;
leg={};
hold on;
for i=1:n
    plot(S(i,:),Colors{i});
    leg{i}=num2str(space(i));
end
xlabel('Time');
ylabel('Number of aggregates');
legend(leg);
title('Evolution of number of aggreagtes in function of compartment size');
hold off;

figure;
leg={};
hold on;
for i=1:n
    plot(S(i,:)./space(i),Colors{i});
    leg{i}=num2str(space(i));
end
xlabel('Time');
ylabel('Number of aggregates');
legend(leg);
title('Evolution of concentration of aggreagtes in function of compartment size');
hold off;

figure
x=[0.5:1:20.5];
for i=1:n
    subplot(3,4,i);
    [n] = hist(lengt{i},x);
    bar(x,n./length(lengt{i}));
    title(['space=',num2str(space(i))]);
    xlim([0 20]);
    ylim([0 1]);
    MEAN(i)=mean(lengt{i});
    STD(i)=std(lengt{i});
    MEDIAN(i)=median(lengt{i});
    ERR(i)=STD(i)/sqrt(length(STD(i)));
    disp(['init=',num2str(space(i)),' - mean=', num2str(MEAN(i)),' - std=',num2str(STD(i)),' - median=',num2str(MEDIAN(i))]);
end
% 
% figure;
% subplot(1,3,1); fit(density,MEAN,'mean');
% subplot(1,3,2); fit(density,STD,'std');
% subplot(1,3,3); fit(density,MEDIAN,'median');
% hold off;
% 
% end
% 
% function [p,yout]=fit(x,y,ylab)
% p=polyfit(x,y,1);
% yout=polyval(p,x);
% hold on;
% plot(x,y,'b+');
% plot(x,yout,'r-');
% text(0.1,4,['y=ax+b',' - a=',num2str(p(1)),' - b=',num2str(p(2))]);
% xlabel('initial density');
% ylabel(ylab);
% hold off;
% end