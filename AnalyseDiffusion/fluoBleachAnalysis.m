function [BW,out,R,M]=fluoBleachAnalysis(filename,n)
%Camille Paoletti - 05/2011
%ex: fluoBleachAnalysis('',240);

%Region Of Interest choice
figure;
I=imread([filename,'_fluo_001_1.jpg']);
[BW,xi,yi] = roipoly(I);
BW=uint16(BW);
figure(1); imshow(I.*BW);


%ROI checking
N=size(I);
out=zeros(N(1),N(2),2*n);
R=zeros(60,1);
M=zeros(60,1);
for i=1:n
    %figure(2);
    if i<10
        a=strcat('00',num2str(i));
    elseif 10<=i && i<100;
        a=strcat('0',num2str(i));
    else
        a=num2str(i);
    end
    %imshow([filename,'_fluo_',a,'_1.jpg']);
    %patch(xi,yi,'r');
    A=imread([filename,'_fluo_',a,'_1.jpg']);
    out(:,:,2*(i-1)+1)=A.*BW;
    %pause;
    %imshow([filename,'_fluo_',a,'_2.jpg']);
    %patch(xi,yi,'r');
    A=imread([filename,'_fluo_',a,'_2.jpg']);
    out(:,:,2*i)=A.*BW;
    %pause;
    R(i)=sum(sum(out(:,:,2*i)))/sum(sum(out(:,:,2*(i-1)+1)));
    M(i)=mean(mean(out(:,:,2*i)))/mean(mean(out(:,:,2*(i-1)+1)));
end
% figure;
% for i=1:12
%     subplot(3,4,i);
%     imshow(out(:,:,i),[1800 2200]);
% end

end