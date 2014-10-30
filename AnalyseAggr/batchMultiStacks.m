function []=batchMultiStacks()
%batch analysis for multiStacks experiement

load('L:\common\movies\Camille\2012\201204\120420_multiStacks_list.mat');
a=length(List);
for b=2:a
    filename=List{b,1};
    computeFociMultiBatch(filename);
    analyzeFociBatch(filename);
end


t=5;
pos=6;
for b=2:a
    filename=List{b,1};
    filenameTemp=strcat(filename,'-fociAnalysis.mat');
    load(filenameTemp);
    
    for i=1:t;nb{i,1}=horzcat(nbVal{i,1},nbVal{i,2},nbVal{i,3});end
    for i=1:t;nbTot(i,1)=sum(nb{i,1});end
    
%     figure;
%     plot([1:1:t],nbTot);
%     title('Total number of foci');
%     xlabel('Time (min)');
%     ylabel('Number of foci');
    
    for j=1:pos
        for i=1:t;nb1(i,j)=sum(nbVal{i,j});end
    end
    figure;
    colors={'r-','b-','g-','-c','-k','-m'};
    hold on;
    for j=1:pos
        plot([1:1:t],nb1(:,j),colors{j});
    end
    legend('21 stacks 0.25µm','9 stacks 0.5µm','7 stacks 0.75µm','5 stacks 1µm','focal plane','3 stacks 1µm');
    title('Total number of foci');
    xlabel('Time (min)');
    ylabel('Number of foci');
    
    hold off;
    
end