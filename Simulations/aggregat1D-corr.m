function aggregat1D-corr(ntraj,space,nsteps)

% ntraj : number of independent trajectories
% space : size of compartment
% nsteps : number of time steps

d=1; %diffusion coef; we assume d=1 for particle of size 1 et 1/N for particles of size N (einstein's law); since the displacement step is 1
% we assume that the probability to move by a step of size 1 for a particle
% of size N goes as 1/N;

C=0.2; %particle density

M=zeros(ntraj,space,nsteps);

temp=rand([ntraj,space]); % random initial state
temp=temp<C;
M(:,:,1)=temp;
thr=5; %detection threshold

ntot=C*space;


for i=2:nsteps % loop on time steps
    for j=1:ntraj % loop on independent trajectories
        M(j,:,i)=M(j,:,i-1);
        
        cursor=1;
        
        while cursor
            d=diff([0 M(j,:,i) 0],1,2);
            
            up=find(d==1); % find beginning of aggregates
            down=find(d==-1)-1; % find end of aggregates
            
            k=find(up>=cursor,1,'first');
            
            if numel(k)==0
                break
            end
            
            dir=rand; % get direction of move
            proba=rand; % proba to move  (put proba=0 if you don't want to have diffusion coef= f(particle size)
            %proba=0;
            
            cursor=down(k)+2;
            if dir>0.5
                if down(k)<space && proba <= 1/(-up(k)+down(k)+1) % move +
                    M(j,up(k)+1:down(k)+1,i)=M(j,up(k):down(k),i);
                    M(j,up(k),i)=0;
                end
            else
                if up(k)>1 && proba <= 1/(-up(k)+down(k)+1) % move -
                    M(j,up(k)-1:down(k)-1,i)=M(j,up(k):down(k),i);
                    M(j,down(k),i)=0;
                end
            end
            
            
           % pause
            if cursor>=space
               cursor=0; 
            end
        end
    end
   % pause
end

% plot kymograph for traj n
n=1;
kymo=permute(M(n,:,:),[2 3 1]);
figure, imshow(kymo,[]);
xlabel('Time');
ylabel('Aggregates position');

% plot aggregates position at the end of simulation for all traj

%figure, imshow(M(:,:,end),[]);
%xlabel('Aggregates position');
%ylabel('Trajectory number');


meanAgg=zeros(1,nsteps);
agg=zeros(1,nsteps); % aggregated particles
agg2=zeros(1,nsteps);% total particles
cc=0;

for i=1:ntraj
    for j=1:nsteps
        curM=M(i,:,j);
        d=diff([0 curM 0],1,2);
        up=find(d==1);
        down=find(d==-1);
        
        siz=down-up;
        agg2(j)=agg2(j)+sum(siz);
        siz=siz(siz>=thr);
        agg(j)=agg(j)+sum(siz);
        meanAgg(j)=meanAgg(j)+length(up);
    end
end

meanAgg=meanAgg/ntraj;
agg=agg/ntraj;
agg2=agg2/ntraj;
figure, plot(agg2);
xlabel('Time');
ylabel('Total particles');
% plot aggregates number

meanAgg=meanAgg/ntot;

figure, loglog(meanAgg); hold on;
xlabel('Time');
ylabel('Mean Number of aggregates');
% 
% s = fitoptions('Method','NonlinearLeastSquares',...
%     'Lower',[0.1,0.001],...
%     'Upper',[1,0.1],...
%     'Startpoint',[0.5 0.01]);
% f = fittype('a*exp(-b*x)','options',s);
% 
% x=1:1:length(meanAgg); x=x';
% meanAgg=meanAgg';
% 
% [c,gof] = fit(x,meanAgg,f)
% %ci = confint(c,0.95)
% y=c.a*exp(-c.b*x);
% plot(x,y,'Color','r','lineStyle','--');


% plot aggregate size
agg=agg/ntot;
figure, plot(agg); hold on;
%plot(agg2/ntot,'Color','r'); hold on;
xlabel('Time');
ylabel('Total mass of aggregates');


s = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[0.1,0.001],...
    'Upper',[1,0.1],...
    'Startpoint',[0.2 0.01]);
f = fittype('a*(1-exp(-b*x))','options',s);

x=1:1:length(agg); x=x';
agg=agg';

[c,gof] = fit(x,agg,f)
%ci = confint(c,0.95)
y=c.a*(1-exp(-c.b*x));
%y=0.6*(1-exp(-0.001*x));
plot(x,y,'Color','r','lineStyle','--');
