function [ft]=theo_model(Data,display,D)
%http://www.arte.tv/guide/fr/048763-000/l-urgence-de-ralentir

rat=[];
area=[];

%% analytical expression of solutions
%a: alpha
%m1: mother growth rate muM
%m2: bud growth rate muB
%k: formation rate

%eigen values lambda1,2
lambda1=@(a,m1,m2) ( -(a+m1+m2) + sqrt( a^2 + (m1-m2)^2 ) ) / 2; %check with simple values
lambda2=@(a,m1,m2) ( -(a+m1+m2) - sqrt( a^2 + (m1-m2)^2 ) ) / 2;

%particular solution Up (Up1,Up2)
Up1=@(k,a,m1,m2) ( k*( m2+a ) ) / ( m1*m2 + ( a/2 )*( m1+m2 ) ); %check with simple values
Up2=@(k,a,m1,m2) ( k*( m1+a ) ) / ( m1*m2 + ( a/2 )*( m1+m2 ) );

%constantes C1,2
C1=@(a,m1,m2,lambda2,Up1,Up2) ( ( 2*Up1/a ) * ( lambda2 + a/2 + m1 ) - Up2 ) / sqrt( a^2 + (m1-m2)^2 ); % check by displaying expression
C2=@(a,Up1,C1) ( -2/a ) * ( Up1 + C1*a/2 ); % check by displaying expression

%general solutions AM & AB
AM=@(a,lambda1,lambda2,Up1,C1,C2,t,delta) C1*a/2*exp(lambda1*(t-delta)) + C2*a/2*exp(lambda2*(t-delta)) + Up1;
AB=@(a,m1,lambda1,lambda2,Up2,C1,C2,t,delta) C1*( lambda1 + a/2 + m1 )*exp(lambda1*(t-delta)) + C2*( lambda2 + a/2 + m1)*exp(lambda2*(t-delta)) + Up2;

%% 
%
for i=display%1:size(Data{2,1},2)
    fluoM=Data{1,1}(1,i,:);%concentration of fluo in mothers
    fluoM=fluoM(:);
    fluoD=Data{1,1}(2,i,:);%concentration of fluo in daughters
    fluoD=fluoD(:);
    
%         sm=10;
%         figure, plot(fluoM,'Color','r'); hold on; plot(fluoD,'Color','b'); xlabel('frame');ylabel('fluo');legend('mother','bud');
%         plot(smooth(fluoM,sm),'Color','k'); hold on; plot(smooth(fluoD,sm),'Color','b');
%         title(['Conc ' num2str(i)]);
%         set(gcf,'Position',[100 100 600 400]);
    
    areaM=Data{3,1}(1,i,:);
    areaM=areaM(:);
    
    areaD=Data{3,1}(2,i,:);
    areaD=areaD(:);
    
    ratio=Data{2,1}(:,i);%ratio of concentration
    
    div=Data{5,1}(i);
    
    if div==0
        continue
    end
    
    mine=max(div-42,5);
    xarr=1:1:mine;%frames to consider
    last=xarr(end);%last frame to consider
    
    areaD=areaD(xarr);
    areaM=areaM(xarr);
    
    ratio2=mean(ratio(last-3:last));
    %% Growth rates computation
    rmuD=(areaD(end)-areaD(1))/areaD(1);
    rmuD=rmuD/length(xarr);
    rmuM=(areaM(end)-areaM(1))/areaM(1);
    rmuM=rmuM/length(xarr);
    rmuM
    rmuD
    
    syms a k t%definition as symbolic variables
% a=0.011
% k=1
%D=5;% offset (unit: frame)
    
    %% Model constant computation
    L1=lambda1(a,rmuM,rmuD);
    L2=lambda2(a,rmuM,rmuD);
    U1=Up1(k,a,rmuM,rmuD);
    U2=Up2(k,a,rmuM,rmuD);
    c1=C1(a,rmuM,rmuD,L2,U1,U2);
    c2=C2(a,U1,c1);
    ccM=AM(a,L1,L2,U1,c1,c2,t,D);
    g = matlabFunction(ccM);% fonction correspondant à l'expression de la concentration dans les mères
    ccB=AB(a,rmuM,L1,L2,U2,c1,c2,t,D);   
    h = matlabFunction(ccB);% fonction correspondant à l'expression de la concentration dans les filles
    
    t=transpose(xarr(D:end));
    yM=fluoM(xarr(D:end));
    yB=fluoD(xarr(D:end));
    
    ftM = fittype( g, 'indep', {'t'}, 'depend', 'y'); %Mothers
    ftB = fittype( h, 'indep', {'t'}, 'depend', 'y'); % Daughters
    
    optsM = fitoptions( ftM );
    % opts.Display = 'Off';
    optsM.Lower = [0 0];
    optsM.StartPoint = [0.005 1];
    % opts.Upper = [1000 5000 2*wsize 2*siz 2*wsize 5000 2*wsize 2*wsize];
    optsM.Weights = zeros(1,0);
    
    optsB = fitoptions( ftB );
    % opts.Display = 'Off';
    optsB.Lower = [0 0];
    optsB.StartPoint = [0.005 1];
    % opts.Upper = [1000 5000 2*wsize 2*siz 2*wsize 5000 2*wsize 2*wsize];
    optsB.Weights = zeros(1,0);
    
    
    %[fitresult, gof] = fit( t, y, ft)
    [fitresultM, gofM] = fit( t, yM, ftM, optsM)
    [fitresultB, gofB] = fit( t, yB, ftB, optsB)
    
    figure;
    subplot(1,2,1);
    plot(t,yM,'r+');
    hold on;
    title(['Mother - couple n° ',num2str(display)]);
    af=fitresultM.a;
    kf=fitresultM.k;
    y2=g(af,kf,t);
    plot(t,y2,'b-');
    hold off;
    subplot(1,2,2);
    plot(t,yB,'r+');
    hold on;
    title(['Bud - couple n° ',num2str(display)]);
    af=fitresultB.a;
    kf=fitresultB.k;
    y2=g(af,kf,t);
    plot(t,y2,'b-');
    hold off;
    
    return

    %%
    if ~isnan(ratio2) & ~isinf(ratio2) & ~isnan(areaD(1))
        rat=[rat ratio2];
        area=[area (rmuM+alpha)/(rmuD+alpha)];
        alpha_exp=[alpha_exp (rmuM-ratio2*rmuD)/(ratio2-1)];
        muD=rmuD;
        muM=rmuM;
        
    end
end

%size(rat)
%median(rat)
%mean(rat)

pix=find(rat<10 & rat>0 & area>0);
rat=rat(pix);
area=area(pix);
% m=min(min(rat),min(area))
% M=max(max(rat),max(area))
if display
    figure, loglog(area,rat,'r*'); hold on; loglog(0.001:0.001:10, 0.001:0.001:10,'Color','k');xlim([1e-3 1e1]);ylim([1e-3 1e1]);hold off;
    %figure, plot(area,rat,'r*'); hold on; plot(0.001:0.001:10, 0.001:0.001:10,'Color','k');
end

h_fig(1)=gca;

[c,pval]=corrcoef(log(area),log(rat));
[~,S] = polyfit(log(area),log(rat),1);
c=c(1,2);
pval=pval(1,2);
s=sum((log(area)-log(rat)).^2);
%disp(['Corr Coef = ',num2str(c)]);

% if display
%     figure;
%     hist(alpha_exp,[-1:0.005:1]);
%     mean(alpha_exp)
%     median(alpha_exp)
% end