function [num,intensity]=plotSingleCellFociEvolution(cellNumber)
%Camille Paoletti - 04/2012 -review on 04/2014
%plot the evolution of the number of foci in every single cell of the movie
%or in the single cell n° "cellNumber"

global segmentation
global timeLapse

if nargin==1
    n=length(segmentation.tcells1(1,cellNumber).Obj);
    num=zeros(n,1);
    intensity=zeros(n,1);
    
    for i=1:n
        num(i,1)=segmentation.tcells1(1,cellNumber).Obj(1,i).Nrpoints;
        intensity(i,1)=segmentation.tcells1(1,cellNumber).Obj(1,i).Mean;
    end
    
    figure;
    hold on;
    plot([1:1:n],num,'b-');
    
    ax1 = gca;
    set(ax1,'YColor','b')
    %legend('number of foci');
    %legend1 = legend(ax1,'show');
    %set(legend1,'Location','North');
    
    xlabel('Time (min)');
    ylabel('Number of foci');
    
    %     ax2 = axes('Position',get(ax1,'Position'),...
    %         'YAxisLocation','right',...
    %         'Color','none',...
    %         'YColor','r');
    %     line([1:1:n],intensity,'Color','r','Parent',ax2);
    %     %legend('z');
    %     ylabel('FluoIntensity (a.u.)');
    %     % 'XAxisLocation','top',...
    
    title(['evolution of foci in response to HS (30 to 35 °C - t=15min )']);
    
    hold off;
    
    
else
    leng=timeLapse.numberOfFrames;
    tc=segmentation.tcells1;
    N=[tc.N];
    numel=find(N);
    len=length(numel);
    num=zeros(leng,len);
    cc=0;
    for j=1:length(segmentation.tcells1)
        if segmentation.tcells1(1,j).N==0
            
        else
            if cc<70
                cc=cc+1;
                cellNumber=j;
                n=length(segmentation.tcells1(1,cellNumber).Obj);
                start=segmentation.tcells1(1,cellNumber).detectionFrame;
                %last=segmentation.tcells1(1,cellNumber).lastFrame;
                for i=1:n
                    num(start+i-1,cc)=segmentation.tcells1(1,cellNumber).Obj(1,i).Nrpoints;
                end
               
                figure;
                plot([1:1:leng],num(:,cc));
                hold on;
                plot(start,num(start,cc),'ro');
                %plot([start:1:last],num(:,cc));
                axis([0 leng 0 4]);
                title(['cell n° ',num2str(segmentation.tcells1(1,j).N)]);
                hold off;
                
            end
            %             end
        end
        
    end
end

% if segmentation.tcells1(1,cellNumber).N==0
% else
% end