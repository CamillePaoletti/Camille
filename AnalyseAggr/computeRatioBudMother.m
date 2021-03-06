function [n listBud ratio volumeMother]=computeRatioBudMother(l)
%[ratio, motherCc, budCc]=computeRatioBudMother(l)
%Camille Paoletti - 04/2013

%compute concentration of foci in bud and mother and ratio of concentration
%in frame l

global segmentation

cell=segmentation.cells1(l,:);

n=[cell.n];
area=[cell.area];
fluo=[cell.fluoNuclMean];
listBud=[cell.mother]%list of the number of all mothers


for i=1:2
    if i==1
        cell=segmentation.cells1(l,:);
    elseif i==2
        cell=segmentation.cells1(l+20,:);
    end
    
    n=[cell.n];
    area=[cell.area];
    fluo=[cell.fluoNuclMean];
    Nr=[cell.Nrpoints];
    %listBud=[cell.mother];
    
    pix=find(listBud);%pixel corresponding to daughters
    listBud=listBud(pix)%list of the number of mother of buds
    
    motherPix=[];
    for k=1:length(listBud)
        motherPix=[motherPix find(n==listBud(k))];
    end
    
    size(motherPix)
    
    areaBud=area(pix);
    a=mean(areaBud)
    fluoBud(i,:)=fluo(pix);
    NrBud=Nr(pix);
    volumeBud(i,:)=areaBud.^(3/2);
    
    areaMother=area(motherPix);
    fluoMother(i,:)=fluo(motherPix);
    NrMother=Nr(motherPix);
    volumeMother(i,:)=areaMother.^(3/2);
    
    budCc(i,:)=fluoBud(i,:)./volumeBud(i,:);
    budCcArea(i,:)=fluoBud(i,:)./areaBud;
    budNcc(i,:)=NrBud./volumeBud(i,:);
    motherCc(i,:)=fluoMother(i,:)./volumeMother(i,:);
    motherCcArea(i,:)=fluoMother(i,:)./areaMother;
    motherNcc(i,:)=NrMother./volumeMother(i,:);
   
    ratio(i,:)=budCc(i,:)./motherCc(i,:);
    ratioA(i,:)=budCcArea(i,:)./motherCcArea(i,:);
    
    mean(budCc(i,:))
    mean(motherCc(i,:))
    mean(ratio(i,:))
    %mean(ratioA)
    
    figure;
    boxplot([transpose(budCc(i,:)),transpose(motherCc(i,:)),transpose(ratio(i,:))],'notch','on');
    
    
%     figure;
%     plot(budCc(i,:),motherCc(i,:),'b*');
    
    [R,P]=corrcoef(budCc(i,:),motherCc(i,:))
    [p,h] = ranksum(budCc(i,:),motherCc(i,:))
    
    [R,P]=corrcoef(budCcArea(i,:),motherCcArea(i,:))
    [p,h] = ranksum(budCcArea(i,:),motherCcArea(i,:))
    
    %[R,P]=corrcoef(ratio,ratioA)
    %[p,h] = ranksum(ratio,ratioA)
    
   
    
    
end

figure;

numel=find(ratio(1,:));

[R,P]=corrcoef(ratio(1,:),ratio(2,:))
[p,h] = ranksum(ratio(1,:),ratio(2,:))

[R,P]=corrcoef(ratio(1,numel),ratio(2,numel))
[p,h] = ranksum(ratio(1,numel),ratio(2,numel))

%figure;
hold on;
plot(ratio(1,numel)-ratio(2,numel),'b+');
line([0 130],[0 0]);
plot(ratio(1,numel),'r*');
hold off;


%figure;
boxplot([transpose(budNcc(1,:)),transpose(motherNcc(1,:)),transpose(budNcc(2,:)),transpose(motherNcc(2,:))],'notch','on');

[R,P]=corrcoef(budNcc(1,:),motherNcc(1,:))
[p,h] = ranksum(budNcc(1,:),motherNcc(1,:))

[R,P]=corrcoef(budNcc(2,:),motherNcc(2,:))
[p,h] = ranksum(budNcc(2,:),motherNcc(2,:))

%figure;
plot(volumeBud(2,numel)/volumeBud(1,numel),budCc(2,numel)./budCc(1,numel));


plot(fluoBud(2,numel)./fluoBud(1,numel),'r+');
hold on;
plot(fluoMother(2,numel)./fluoMother(1,numel),'b+');

hold off;

%figure;
boxplot([transpose(fluoBud(2,numel)./fluoBud(1,numel)),transpose(fluoMother(2,numel)./fluoMother(1,numel))],'notch','on');
mean(transpose(fluoBud(2,numel)./fluoBud(1,numel)))
mean(transpose(fluoMother(2,numel)./fluoMother(1,numel)))

boxplot([transpose(volumeBud(2,numel)./volumeBud(1,numel)),transpose(volumeMother(2,numel)./volumeMother(1,numel))],'notch','on');
mean(transpose(volumeBud(2,numel)./volumeBud(1,numel)))
mean(transpose(volumeMother(2,numel)./volumeMother(1,numel)))

size(numel)


figure;
boxplot([transpose(motherCc(1,:)),transpose(budCc(1,:)),transpose(ratio(1,:)),transpose(motherCc(2,:)),transpose(budCc(2,:)),transpose(ratio(2,:))],'notch','on');
figure;
boxplot([transpose(ratio(1,:)),transpose(ratio(2,:)),transpose(zeros(1,30))],'notch','on');


end