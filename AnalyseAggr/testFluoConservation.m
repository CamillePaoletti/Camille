function [B]=testFluoConservation()

%Camille Paoletti - 10/2013


global timeLapse;

B=zeros(1,timeLapse.currentFrame);

fprintf('computing total fluo... \n');

for j=2%1:numel(timeLapse.position.list)
    for i=1:timeLapse.currentFrame
        for k=3%1:numel(timeLapse.list)
            if timeLapse.list(1,k).enableZStacks
                A=zeros(1000/timeLapse.list(1,k).binning,1000/timeLapse.list(1,k).binning,timeLapse.list(1,k).ZStackNumber);
                for l=1:timeLapse.list(1,k).ZStackNumber
                    [image,fullpath]=loadTimeLapseStackImage(j,i,k,l);
                    A(:,:,l)=image;
                end
                B(j,i)=sum(sum(sum(A)));
            else
                %fprintf('no z-stacks \n');
            end
        end
    end
end

fprintf('\n done! \n');

end