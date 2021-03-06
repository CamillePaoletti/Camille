function [outData,timing]=fluoDiffusionAnalysis2(filename,nbCav)
%Camille Paoletti - 06/2011
%ex: [BW,Raw,R,N,M]=fluoDiffusionAnalysis2('L:\common\movies\Camille\2011\110622\film.mat');

%parameters
Colors={'k-','b','g-','r-','-c'};

%Choices={'sup1','sup2','sup3','sup4','sup5'};
%Choices={'cav1','cav2','cav3','cav4'};
%Choices={'supply channel','trapping area','PDMS','cavity'};
Choices={'supply channel l', 'supply channel r', 'trapping area', 'cavity'};


np=length(Choices);


%Region Of Interest choice
fprintf('loading data\n');
data=load(filename);
%I=permute(data.I,[2 3 1]);
I=data.M;
n=size(I,3);
timing=vertcat(0, data.diffTime(3:n+1,1)-data.diffTime(2)*ones(n-1,1));


figure(1);
J=imadjust(I(:,:,n));
imshow(J);

for z=1:nbCav
    fprintf('cavity number %d',double(z))
    %ROI checking
    R=zeros(n,np);
    N=zeros(n,np);
    Raw=zeros(n,np);
    m=zeros(1,np);
    BWs=zeros(500,500,np);
    for j=1:np
        fprintf('choosing %s region\n', Choices{j});
        figure(1);
        [BW,xi,yi] = roipoly;
        BWs(:,:,j)=uint16(BW);
        BW=uint16(BW);
        A1=I(:,:,2).*BW;
        pix=find(A1~=0);
        m(1,j)=mean(mean(A1(pix)));
        for i=1:n
            fprintf('.',num2str(i));
            %patch(xi,yi,'r');
            A=I(:,:,i).*BW;
            pix=find(A~=0);
            Raw(i,j)=mean(mean(A(pix)));
            R(i,j)=Raw(i,j)/mean(mean(A1));
        end
        fprintf('\n');
    end
    
    Mini=zeros(np,1);
    Maxi=zeros(np,1);
    for j=1:np
        Mini(j,1)=mean(Raw(2:21,j));
        Maxi(j,1)=mean(Raw(140:200,j));
    end
    
    for j=1:np
        N(:,j)=(Raw(:,j)-Mini(j,1)*ones(n,1))./(Maxi(j,1)-Mini(j,1));
    end
    
    outData(z).BWs=BWs;
    outData(z).Raw=Raw;
    outData(z).R=R;
    outData(z).N=N;
    outData(z).m=m;
    outData(z).Mini=Mini;
    outData(z).Maxi=Maxi;
    
end


for z=1:nbCav

figure;
hold on;
subplot(1,3,1)
hold on;
for j=1:np
    plot(timing,outData(z).N(:,j),Colors{j});
end
legend(Choices);
xlabel('time(s)');
ylabel('rescaled intensity (a.u.)');
hold off

subplot(1,3,2)
hold on;
for j=1:np
    plot(timing,outData(z).Raw(:,j),Colors{j});
end
legend(Choices);
xlabel('time(s)');
ylabel('intensity (a.u.)');
hold off;

subplot(1,3,3)
hold on;
for j=1:np
    plot(timing,outData(z).Raw(:,j)./((outData(z).Raw(:,1)+outData(z).Raw(:,2))/2),Colors{j});
end
legend(Choices);
xlabel('time(s)');
ylabel('renormalization supply channels');
hold off;

hold off;

figure;
hold on;
for j=1:np
    plot(timing,outData(z).Raw(j),Colors{j});
end
legend(Choices);
xlabel('time(s)');
ylabel('intensity (a.u.)');
hold off;

end


%%%%bilan
%parameters
% Colors={'k-','b','g-','r-','-c'};
% Choices={'supply channel l', 'supply channel r', 'trapping area', 'cavity'};
% np=length(Choices);
% nbCav=2;
% n=489;
for z=1:nbCav
    Mini2=zeros(np,1);
    Maxi2=zeros(np,1);
    for j=1:np
        Mini2(j,1)=min(outData(1).Raw(2:21,j));
        Maxi2(j,1)=max(outData(1).Raw(end-60:end,j));
        outData(z).Mini2=Mini2;
        outData(z).Maxi2=Maxi2;
        outData(z).N2(:,j)=(outData(z).Raw(:,j)-Mini2(j,1)*ones(n,1))./(Maxi2(j,1)-Mini2(j,1));
    end
end

figure;
hold on;
for z=1:2
for j=1:np
    plot(timing,outData(z).N2(:,j),Colors{j});
end
legend(Choices);
xlabel('time(s)');
ylabel('rescaled intensity (a.u.)');
end
hold off

end