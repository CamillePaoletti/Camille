function [S,lengt,SB,lengtB,mass,massB]=aggregat1D(ntraj,space,nsteps,C)

% ntraj : number of independent trajectories
% space : size of compartment
% nsteps : number of time steps

d=1; %diffusion coef; we assume d=1 for particle of size 1 et 1/N for particles of size N (einstein's law); since the displacement step is 1
% we assume that the probability to move by a step of size 1 for a particle
% of size N goes as 1/N;

%C=0.02; %particle density

limit=500

M=zeros(ntraj,space,nsteps);

temp=rand([ntraj,space]); % random initial state
temp=temp<C;
M(:,:,1)=temp;


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

%n=1;
S=zeros(ntraj,nsteps);
SB=zeros(ntraj,nsteps);
mass=zeros(ntraj,nsteps);
massB=zeros(ntraj,nsteps);
for n=1:ntraj
    A=permute(M(n,:,:),[2 3 1]);
    d=diff([zeros(space,1), A, zeros(space,1)],1,2);
    down=find(d==-1); % find beginning of aggregates
    d(down)=0;
    if limit<size(d,2)
        S(n,:)=sum(d(1:limit,1:end-1,1),1);
        SB(n,:)=sum(d(limit+1:end,1:end-1,1),1);
    else
        S(n,:)=sum(d(:,1:end-1,1),1);
        SB(n,:)=0;
    end
    
    curM=M(n,:,end);
    d=diff([0 curM 0],1,2);
    up=find(d==1); % find beginning of aggregates
    down=find(d==-1)-1; % find end of aggregates
    if limit<size(M,2)
        num=[];
        num=find(up<limit+1);
        len=(down(num)-up(num)+1);
        if isempty(len);
            lengt{n}=[];
        else
            lengt{n}=len;
        end
        num=[];
        num=find(up>limit);
        len=(down(num)-up(num)+1);
        if isempty(len);
            lengtB{n}=[];
        else
            lengtB{n}=len;
        end
    else
        len=(down-up+1);
        if isempty(len);
            lengt{n}=[];
        else
            lengt{n}=len;
        end
    end
    
    for i=1:nsteps
        curM=M(n,:,i);
        d=diff([0 curM 0],1,2);
        up=find(d==1); % find beginning of aggregates
        down=find(d==-1)-1; % find end of aggregates
        if limit<size(M,2)
            num=find(up<limit+1);
            len=(down(num)-up(num)+1);
            mass(n,i)=sum(len);
            num=find(up>limit);
            len=(down(num)-up(num)+1);
            massB(n,i)=sum(len);
        else
            len=(down-up+1);
            mass(n,i)=sum(len);
        end
    end
    
    
end

S=sum(S,1);
SB=sum(SB,1);
lengt=cat(2,lengt{:});
lengtB=cat(2,lengtB{:});
mass=sum(mass,1);
massB=sum(massB,1);


%plot kymograph for traj n
n=1;
kymo=permute(M(n,:,:),[2 3 1]);
figure, imshow(kymo,[]);
xlabel('Time');
ylabel('Aggregates position');

% %plot aggregates position at the end of simulation for all traj
% figure, imshow(M(:,:,end),[]);
% xlabel('Aggregates position');
% ylabel('Trajectory number');

end
