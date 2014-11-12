function plotAggregateAccum(numel)
global segmentation
n=length(numel);

% figure;
% hold on;
% for i=1:n
%     tcell=segmentation.tcells1(1,numel(i));
%     temp=[tcell.Obj(1,:).fluoNuclVar];
%     plot(temp);
%     
% end
% hold off
% 
% 
    
for i=1:n

    tcell=segmentation.tcells1(1,numel(i));
    temp=[tcell.Obj(1,:).fluoNuclMax];
    temp2=[tcell.Obj(1,:).fluoNuclVar];
    temp3=[tcell.Obj(1,:).fluoCytoVar];
    figure; hold on;
    plot(temp,'r-');
    plot(temp2,'b-');
    plot(temp3,'g-');
    ylim([0 6e5]);
    xlim([0 300]);
end
hold off;

for i=1:n
    tcell=segmentation.tcells1(1,numel(i));
    %tf=[tcell.Obj.image];
    tf=length(tcell.Obj)
    temp=[tcell.Obj(1,tf-20:tf).fluoNuclVar];
    fluo(i)=mean(temp);
    gen(i)=length(tcell.budTimes)
    
end

figure;
plot(gen,fluo,'*');

end