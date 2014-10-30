function [ ] = computeCrossCorrelation(cellule,nucleus,focus, initFrame, lastFrame)
%Camille Paoletti - 10/2013

%extract coordinates
init=initFrame-cellule.detectionFrame+1;
last=lastFrame-cellule.detectionFrame+1;
cellCenter(1,:)=[cellule.Obj(1,init:last).ox];
cellCenter(2,:)=[cellule.Obj(1,init:last).oy];
initCellCenter=repmat(cellCenter(:,1),1,length(cellCenter));

init=initFrame-nucleus.detectionFrame+1;
last=lastFrame-nucleus.detectionFrame+1;
nucleusCenter(1,:)=[nucleus.Obj(1,init:last).ox];
nucleusCenter(2,:)=[nucleus.Obj(1,init:last).oy];

init=initFrame-focus.detectionFrame+1;
last=lastFrame-focus.detectionFrame+1;
focusCenter(1,:)=[focus.Obj(1,init:last).ox];
focusCenter(2,:)=[focus.Obj(1,init:last).oy];

%correct for cell movement
focusCenter=focusCenter+(cellCenter-initCellCenter);
nucleusCenter=nucleusCenter+(cellCenter-initCellCenter);

%compute cross corr
d=1;
c=xcorr(focusCenter(d,:),nucleusCenter(d,:),'biased');
figure;plot(c,'r');
c=xcorr(nucleusCenter(d,:),focusCenter(d,:),'biased');
hold on;
plot(c,'b');
hold off;


% c=xcorr2(focusCenter(:,:),nucleusCenter(:,:));
% figure;plot(c(1,:),'r');
% c=xcorr(nucleusCenter(:,:),focusCenter(:,:));
% hold on;
% plot(c(1,:),'b');
% hold off;

end

