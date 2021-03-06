function [BWs,Raw,R,N,M]=fluoDiffusionAnalysis2(filename)
%Camille Paoletti - 06/2011
%ex: [BW,Raw,R,N,M]=fluoDiffusionAnalysis2('L:\common\movies\Camille\2011\110622\film.mat');

%parameters
Colors={'k-','b','g-','r-'};
%Choices={'supply channel','pre-trapping area','trapping area'};
Choices={'supply channel','trapping area','PDMS','cavity'};

np=length(Choices);

%Region Of Interest choice
fprintf('loading data\n');
data=load(filename);
I=permute(data.I,[2 3 1]);
n=size(I,3);

figure(1);
J=imadjust(I(:,:,n));
imshow(J);

%ROI checking
R=zeros(n,np);
N=zeros(n,np);
Raw=zeros(n,np);
M=zeros(1,np);
BW=zeros(500,500,np);
for j=1:np
    fprintf('choosing %s region\n', Choices{j});
    figure(1);
    [BW,xi,yi] = roipoly;
    BWs(:,:,j)=uint16(BW);
    BW=uint16(BW);
    A1=I(:,:,1).*BW;
    pix=find(A1~=0);
    M(1,j)=mean(mean(A1(pix)));
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


for j=1:np
    for i=1:n
        N(i,j)=(R(i,j)-min(R(:,j)))/(max(R(:,j))-min(R(:,j)));
    end
end

figure;
hold on;
subplot(1,3,1)
hold on;
for j=1:np
    plot(data.realTime(2:n+1,1)-data.realTime(1,1)*ones(n,1),N(:,j),Colors{j});
end
legend(Choices{1},Choices{2},Choices{3},Choices{4});
xlabel('time(s)');
ylabel('rescaled intensity (a.u.)');
hold off

subplot(1,3,2)
hold on;
for j=1:np
    plot(data.realTime(2:n+1,1)-data.realTime(1,1)*ones(n,1),Raw(:,j),Colors{j});
end
legend(Choices{1},Choices{2},Choices{3},Choices{4});
xlabel('time(s)');
ylabel('intensity (a.u.)');
hold off;

subplot(1,3,3)
hold on;
for j=1:np
    plot(data.realTime(2:n+1,1)-data.realTime(1,1)*ones(n,1),R(:,j)./M(1,j),Colors{j});
end
legend(Choices{1},Choices{2},Choices{3},Choices{4});
xlabel('time(s)');
ylabel('deviation to initial value (%)');
hold off;

hold off;

end