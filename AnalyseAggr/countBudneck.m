function [numb]=countBudneck(segmentation)
%Camille Paoletti - 04/2012
%count number of foci by frame


n=size(segmentation.budnecks,1);
p=size(segmentation.budnecks,2);
numb=zeros(n,1);

for i=1:n
    count=0;
    for j=1:p
        if segmentation.budnecks(i,j).n~=0
        count=count+1;
        end
    end
    numb(i,1)=count;
end

figure;plot([1:1:n],numb);
title('Evolution of the number of foci');
xlabel('time (min)');
ylabel('number of foci');

end