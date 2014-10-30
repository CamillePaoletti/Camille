function [BW,out,Raw,R,N]=fluoDiffusionAnalysis(filename,n)
%Camille Paoletti - 06/2011
%ex: [BW,out,Ra,R,N]=fluoDiffusionAnalysis('L:\common\movies\Camille\2011\110622\film',240);

%parameters
Colors={'k-','g-','r-'};

%Region Of Interest choice
I=imread([filename,'_fluo_060.jpg']);
%J = imadjust(I);
figure(1);
imshow(I,[350 1200]);

%ROI checking
N=size(I);
out=zeros(N(1),N(2),n,3);
R=zeros(n,3);
N=zeros(n,3);
Raw=zeros(n,3);
for j=1:3
    figure(1);
    [BW,xi,yi] = roipoly;
    BW=uint16(BW);
    %figure(1); imshow(I.*BW);
    for i=1:n
        %figure(2);
        if i<10
            a=strcat('00',num2str(i));
        elseif 10<=i && i<100;
            a=strcat('0',num2str(i));
        else
            a=num2str(i);
        end
        fprintf('processing: %s\n',['fluo_',a,'.jpg']);
        %imshow([filename,'_fluo_',a,'.jpg']);
        %patch(xi,yi,'r');
        A=imread([filename,'_fluo_',a,'.jpg']);
        out(:,:,i,j)=A.*BW;
        Raw(i,j)=mean(mean(out(:,:,i,j)));
        R(i,j)=mean(mean(out(:,:,i,j)))/mean(mean(out(:,:,1,j)));
        %out=A.*BW;
        %R(i,j)=sum(sum(out))/sum(sum(out));
    end
end

for j=1:3
    for i=1:n
        N(i,j)=(R(i,j)-min(R(:,j)))/(max(R(:,j))-min(R(:,j)));
    end
end
% figure;
% for i=1:12
%     subplot(3,4,i);
%     imshow(out(:,:,i,1),[1800 2200]);
% end

figure;
hold on;
for j=1:3
    plot([1:1:n],N(:,j),Colors{j});
end
legend('supply channel','pretrapping area','trapping area');
xlabel('time(s)');
ylabel('intensity (a.u.)');
hold off;

end

