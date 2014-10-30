function [] =plotGrowthRateDifferentTemp(option)

%Camille Paoletti - 03/2013
%plot growth rate for HS at different temp

if option==0
    global segmentation
    global timeLapse
elseif option==1
    filename=cell(2,1);
    filename{1,1}='/Users/camillepaoletti/Documents/Lab/Movies/120515_aggr_30-35_2-9h/120515_aggr_30-35';
    filename{2,1}='/Users/camillepaoletti/Documents/Lab/Movies/120606_aggr_30-38_10-16h/120606_aggr_30-38_10-16h';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLOT FOR ONE CURVE (CURRENT ONE IN PHYLOCELL)
if option==0
    
    n=timeLapse.numberOfFrames;
    m=length(segmentation.tcells1);
    area=cell(n,1);
    bud=cell(m,1);
    areaTot=zeros(1,n);
    
    for j=1:m
        if  segmentation.tcells1(1,j).N
            for i=1:length(segmentation.tcells1(1,j).Obj)
                area{i+segmentation.tcells1(1,j).detectionFrame-1,1}=horzcat(area{i+segmentation.tcells1(1,j).detectionFrame-1,1},segmentation.tcells1(1,j).Obj(1,i).area);
            end
            if segmentation.tcells1(1,j).budTimes
                bud{j,1}=segmentation.tcells1(1,j).budTimes(1,:);
            end
        end
    end
    
    for i=1:n
        areaTot(i)=sum(area{i,1});
    end
    
    
    t=[0:1:n-1].*timeLapse.interval/60;
    t=double(t);
    
    l=2;
    fHS=60;%323;%200;%323;%
    
    
    interval{1}=[20:1:63];%[70:1:320];%[20:1:160];
    interval{2}=[64:1:240];%[320:1:430];%%[180:1:400];
    
    
    
    
    Colors={'r-','g-','c-'};
    Int={-0.2;-0.6;-1};%Int={-0.05;-0.1;-0.15};
    p=cell(l,1);
    S=cell(l,1);
    f=cell(l,1);
    
    
    for k=1:l
        [p{k},S{k}] = polyfit(t(interval{k}),log(areaTot(interval{k})),1);
        f{k}=polyval(p{k},t(interval{k}));
    end
    
    figure;
    plot(t,log(areaTot),'b*');
    hold on;
    title('Growth rate')
    xlabel('time(min)');
    ylabel('log(area in pix)');
    
    a=get(gcf,'CurrentAxes');
    ax=floor(axis(a));
    b=2;e=500;
    %b=1;e=50;
    str='fit parametres:';
    text(ax(2)-e,ax(3)+b,str);
    
    for k=1:l
        plot(t(interval{k}),f{k},Colors{k});
        str1=['fit ',num2str(k),': a=',num2str(p{k}(1)),' b=',num2str(p{k}(2))];
        text(ax(2)-e+10,ax(3)+b+Int{k},str1);
        str2=['doubling time=', num2str(log(2)/p{k}(1))];
        text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
    end
    legend('exp data','fit1','fit2');
    hold off;
    
    volumeTot=areaTot.^(3/2);
    p3=cell(l,1);
    S3=cell(l,1);
    f3=cell(l,1);
    for k=1:l
        [p3{k},S3{k}] = polyfit(t(interval{k}),log(volumeTot(interval{k})),1);
        f3{k}=polyval(p3{k},t(interval{k}));
    end
    
    figure;
    plot(t,log(volumeTot),'b*');
    hold on;
    title('Growth rate')
    xlabel('time(min)');
    ylabel('log(volume in pix^(3/2))');
    
    a=get(gcf,'CurrentAxes');
    ax=floor(axis(a));
    b=2;e=500;
    %b=1;e=50;
    str='fit parametres:';
    text(ax(2)-e,ax(3)+b,str);
    
    for k=1:l
        plot(t(interval{k}),f3{k},Colors{k});
        str1=['fit ',num2str(k),': a=',num2str(p3{k}(1)),' b=',num2str(p3{k}(2))];
        text(ax(2)-e+10,ax(3)+b+Int{k},str1);
        str2=['doubling time=', num2str(log(2)/p3{k}(1))];
        text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
    end
    legend('exp data','fit1','fit2');
    hold off;
    
    
    
    
    
    %cell cycle timing
    ccTime=cell(m,1);
    for j=1:m
        if length(bud{j,1})>=2;
            ccTime{j,1}=bud{j,1}(1,2:end)-bud{j,1}(1,1:end-1);
        end
    end
    
    
    %number of cell and mean area
    nb=zeros(1,n);
    meanArea=zeros(1,n);
    for i=1:n
        cc=0;
        area=[];
        for j=1:length(segmentation.cells1(i,:))
            if segmentation.cells1(i,j).n
                cc=cc+1;
                area=[area,segmentation.cells1(i,j).area];
            end
        end
        nb(1,i)=cc;
        meanArea(1,i)=mean(area);
    end
    
    p2=cell(l,1);
    S2=cell(l,1);
    f2=cell(l,1);
    for k=1:l
        [p2{k},S2{k}] = polyfit(t(interval{k}),log(nb(interval{k})),1);
        f2{k}=polyval(p2{k},t(interval{k}));
    end
    
    %mean area
    figure;
    plot([1:1:n].*double(timeLapse.interval/60),log(nb),'b*');
    hold on;
    title('Growth rate')
    xlabel('time(min)');
    ylabel('log(nb of cells)');
    
    a=get(gcf,'CurrentAxes');
    ax=floor(axis(a));
    b=2;e=500;
    %b=1;e=50;
    str='fit parametres:';
    text(ax(2)-e,ax(3)+b,str);
    
    for k=1:l
        plot(t(interval{k}),f2{k},Colors{k});
        str1=['fit ',num2str(k),': a=',num2str(p2{k}(1)),' b=',num2str(p2{k}(2))];
        text(ax(2)-e+10,ax(3)+b+Int{k},str1);
        str2=['doubling time=', num2str(log(2)/p2{k}(1))];
        text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
    end
    legend('exp data','fit1','fit2');
    hold off;
    
    figure;
    plot([1:1:n].*double(timeLapse.interval/60),log(meanArea),'r-');
    hold on;
    title('mean Area versus time')
    xlabel('time(min)');
    ylabel('log(meanArea(pix))');
    hold off;
    
    
    % repet=8;
    % tpulses=[0:10:repet*130];
    % pulses=repmat([1,1,0,0,0,0,0,0,0,0,0,0,0],1,repet);
    % pulses=[pulses,1];
    figure;
    plot([1:1:n].*double(timeLapse.interval/60),log(nb),'r*');
    hold on;
    title('Growth rate')
    xlabel('time(min)');
    ylabel('log scale');
    plot(t,log(areaTot),'b*');
    %plot(tpulses,pulses,'g-');
    legend('log(nb of cells)','log(area)');%,'SCG-pulses');
    hold off;
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLOT FOR 2 DIFFERENT TEMPERATURES
elseif option==1
    
    
    interval{1,1}=[20:1:63];
    interval{2,1}=[64:1:240];
    interval{1,2}=[160:1:203];
    interval{2,2}=[204:1:380];
    interval{3,1}=[20:1:240];
    
    Colors={'g','r-','c-','m-','k*','b*'};
    Int={-0.2;-0.4;-0.6;-0.8;-1};%Int={-0.05;-0.1;-0.15};
    temp=[38,42];
    IntNum=[1,3;2,4;5,6];
    
    for w=1:2
        load(strcat(filename{w,1},'-project.mat'));
        load(strcat(filename{w,1},'-pos1/segmentation.mat'));
        
        n=timeLapse.numberOfFrames;%number of frames
        m=length(segmentation.tcells1);%number of cells
        area=cell(n,1);
        bud=cell(m,1);
        areaTot=zeros(1,n);
        
        
        t=[0:1:n-1].*timeLapse.interval/60;
        t=double(t);
        
        l=2;
        fHS=60;%323;%200;%323;%

        for j=1:m
            if  segmentation.tcells1(1,j).N
                for i=1:length(segmentation.tcells1(1,j).Obj)
                    area{i+segmentation.tcells1(1,j).detectionFrame-1,1}=horzcat(area{i+segmentation.tcells1(1,j).detectionFrame-1,1},segmentation.tcells1(1,j).Obj(1,i).area);
                end
                if segmentation.tcells1(1,j).budTimes
                    bud{j,1}=segmentation.tcells1(1,j).budTimes(1,:);
                end
            end
        end
        
        for i=1:n
            areaTot(i)=sum(area{i,1});
        end
        
        
        p=cell(l,1);
        S=cell(l,1);
        f=cell(l,1);
        
        
        for k=1:l
            [p{k},S{k}] = polyfit(t(interval{k,w}),log(areaTot(interval{k,w})),1);
            f{k}=polyval(p{k},t(interval{k,w}));
        end
        
%         figure(1);
%         hold on;
%         plot(t,log(areaTot),'b*');
%         title('Growth rate')
%         xlabel('time(min)');
%         ylabel('log(area in pix)');
%         
%         a=get(gcf,'CurrentAxes');
%         ax=floor(axis(a));
%         b=2;e=500;
%         %b=1;e=50;
%         str='fit parametres:';
%         text(ax(2)-e,ax(3)+b,str);
%         
%         for k=1:l
%             plot(t(interval{k}),f{k},Colors{k});
%             str1=['fit ',num2str(k),': a=',num2str(p{k}(1)),' b=',num2str(p{k}(2))];
%             text(ax(2)-e+10,ax(3)+b+Int{k},str1);
%             str2=['doubling time=', num2str(log(2)/p{k}(1))];
%             text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
%         end
%         legend('exp data','fit1','fit2');
%         hold off;

        volumeTot=areaTot.^(3/2);
        p3=cell(l,1);
        S3=cell(l,1);
        f3=cell(l,1);
        for k=1:l
            [p3{k},S3{k}] = polyfit(t(interval{k,w}),log(volumeTot(interval{k,w})),1);
            f3{k}=polyval(p3{k},t(interval{k,w}));
        end
        
        figure(1);
        hold on;
        plot(t(interval{3,1}),log(volumeTot(horzcat(interval{1,w},interval{2,w}))),Colors{IntNum(3,w)});
        title('Growth rate')
        xlabel('time(min)');
        ylabel('log(volume in pix^(3/2))');
        
        a=get(gcf,'CurrentAxes');
        ax=floor(axis(a));
        b=2;e=500;
        %b=1;e=50;
        str='doubling times:';
        text(ax(2)-e,ax(3)+b,str);
        
        for k=1:l
            plot(t(interval{k,1}),f3{k},Colors{IntNum(k,w)});
%             str1=['fit ',num2str(k),': a=',num2str(p3{k}(1)),' b=',num2str(p3{k}(2))];
%             text(ax(2)-e+10,ax(3)+b+Int{k},str1);
            str2=['shock 30-',num2str(temp(w)),'°C - fit =',num2str(k),' - doubling time:', num2str(log(2)/p3{k}(1)),' min'];
            text(ax(2)-e+10,ax(3)+b+Int{IntNum(k,w)},str2);
        end
        legend('30-38°C: exp data ','30-38°C: fit1','30-38°C: fit2','30-42°C: exp data ','30-42°C: fit1','30-42°C: fit2');
        hold off;
        
        
        
        
        
        %cell cycle timing
        ccTime=cell(m,1);
        for j=1:m
            if length(bud{j,1})>=2;
                ccTime{j,1}=bud{j,1}(1,2:end)-bud{j,1}(1,1:end-1);
            end
        end
        
        
        %number of cell and mean area
        nb=zeros(1,n);
        meanArea=zeros(1,n);
        for i=1:n
            cc=0;
            area=[];
            for j=1:length(segmentation.cells1(i,:))
                if segmentation.cells1(i,j).n
                    cc=cc+1;
                    area=[area,segmentation.cells1(i,j).area];
                end
            end
            nb(1,i)=cc;
            meanArea(1,i)=mean(area);
        end
        
        p2=cell(l,1);
        S2=cell(l,1);
        f2=cell(l,1);
        for k=1:l
            [p2{k},S2{k}] = polyfit(t(interval{k}),log(nb(interval{k,w})),1);
            f2{k}=polyval(p2{k},t(interval{k}));
        end
        
%         %mean area
%         figure(3);
%         plot([1:1:n].*double(timeLapse.interval/60),log(nb),'b*');
%         hold on;
%         title('Growth rate')
%         xlabel('time(min)');
%         ylabel('log(nb of cells)');
%         
%         a=get(gcf,'CurrentAxes');
%         ax=floor(axis(a));
%         b=2;e=500;
%         %b=1;e=50;
%         str='fit parametres:';
%         text(ax(2)-e,ax(3)+b,str);
%         
%         for k=1:l
%             plot(t(interval{k}),f2{k},Colors{k});
%             str1=['fit ',num2str(k),': a=',num2str(p2{k}(1)),' b=',num2str(p2{k}(2))];
%             text(ax(2)-e+10,ax(3)+b+Int{k},str1);
%             str2=['doubling time=', num2str(log(2)/p2{k}(1))];
%             text(ax(2)-e+10,ax(3)+b+Int{k}+Int{1},str2);
%         end
%         legend('exp data','fit1','fit2');
%         hold off;
%         
%         figure;
%         plot([1:1:n].*double(timeLapse.interval/60),log(meanArea),'r-');
%         hold on;
%         title('mean Area versus time')
%         xlabel('time(min)');
%         ylabel('log(meanArea(pix))');
%         hold off;
%         
%         
%         % repet=8;
%         % tpulses=[0:10:repet*130];
%         % pulses=repmat([1,1,0,0,0,0,0,0,0,0,0,0,0],1,repet);
%         % pulses=[pulses,1];
%         figure(4);
%         plot([1:1:n].*double(timeLapse.interval/60),log(nb),'r*');
%         hold on;
%         title('Growth rate')
%         xlabel('time(min)');
%         ylabel('log scale');
%         plot(t,log(areaTot),'b*');
%         %plot(tpulses,pulses,'g-');
%         legend('log(nb of cells)','log(area)');%,'SCG-pulses');
%         hold off;
        
    end
    
    
    
end


end

