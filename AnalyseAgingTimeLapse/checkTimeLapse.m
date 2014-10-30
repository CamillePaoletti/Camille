function checkTimeLapse(segList)
%Camille Paoletti - 11/2011

%check if there is any problem in segList.s
%ex: checkTimeLapse(segList)

fprintf('checking timing... \n')
for i=1:numel(segList)
    if size(segList(i).s.tcells1(segList(i).line).divisionTimes,2)==size(segList(i).s.tcells1(segList(i).line).budTimes,2)
        delta=segList(i).s.tcells1(segList(i).line).budTimes-segList(i).s.tcells1(segList(i).line).divisionTimes;
        delta2=(segList(i).s.tcells1(segList(i).line).divisionTimes(2:end)-segList(i).s.tcells1(segList(i).line).divisionTimes(1:end-1))-delta(1:end-1);
    elseif size(segList(i).s.tcells1(segList(i).line).divisionTimes,2)==size(segList(i).s.tcells1(segList(i).line).budTimes,2)+1
        delta=segList(i).s.tcells1(segList(i).line).budTimes-segList(i).s.tcells1(segList(i).line).divisionTimes(1:end-1);
        delta2=(segList(i).s.tcells1(segList(i).line).divisionTimes(2:end)-segList(i).s.tcells1(segList(i).line).divisionTimes(1:end-1))-delta;
    else
        delta=0;
        delta2=0;
    end
    %fprintf('i=%d; exp: %s - pos=%d,cell=%d ',i,segList(i).filename,segList(i).position,segList(i).line);
    if delta>0
        if delta2>0
            %fprintf(':) dont worry, I m fine \n');
        else
            fprintf('i=%d; exp: %s - pos=%d,cell=%d ',i,segList(i).filename,segList(i).position,segList(i).line);
            fprintf(':( to check ! ((BUD)) \n');
        end
    else
        fprintf('i=%d; exp: %s - pos=%d,cell=%d ',i,segList(i).filename,segList(i).position,segList(i).line);
        fprintf(':( to check ! \n');
    end
end
    
fprintf('checking size... \n')
for i=1:numel(segList)
    Obj=segList(i).s.tcells1(segList(i).line).Obj(1,:);
    n=size(segList(i).s.tcells1(segList(i).line).Obj,2);
    Size=zeros(n,1);
    for k=1:n
        Size(k,1)=Obj(1,k).area;     
    end
    delta=(Size(2:end,1)-Size(1:end-1,1))./Size(1:end-1,1);
    for k=1:n-2
        if delta(k)<-20/100
            fprintf('i=%d; exp: %s - pos=%d,cell=%d :( segmentation worries at frame %d \n',i,segList(i).filename,segList(i).position,segList(i).line,k+segList(i).s.tcells1(segList(i).line).detectionFrame);
        end
    end
    
end

end