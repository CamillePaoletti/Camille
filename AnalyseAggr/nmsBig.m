function pick = nmsBig(boxes, overlap)
% pick = nms(boxes, overlap)
% Non-maximum suppression.
% Greedily select high-scoring detections and skip detections
% that are significantly covered by a previously selected detection.

if isempty(boxes)
    pick = [];
else
    x1 = boxes(:,1);
    y1 = boxes(:,2);
    x2 = boxes(:,3);
    y2 = boxes(:,4);
    s = x2-x1;
    area = (x2-x1+1) .* (y2-y1+1);
    
    [vals, I] = sort(s);%vals=sorted radius values//I=index//vals=s(I)
    pick = [];
    k=0;
    last=length(I);
    while last>1;
        last = length(I)-k;
        k=k+1;
        I
        i = I(last)
        suppress = [];
        for pos = 1:length(I)
            j = I(pos);%index of pos-ième mean signal value
            xx1 = max(x1(i), x1(j));
            yy1 = max(y1(i), y1(j));
            xx2 = min(x2(i), x2(j));
            yy2 = min(y2(i), y2(j));
            w = xx2-xx1+1;
            h = yy2-yy1+1;
            if w > 0 && h > 0
                % compute overlap
                o = w * h / area(j);
                if o >= overlap
                    if area(j)<area(i)
                        suppress = [suppress; pos];
%                     else
%                         if area(j)>area(i)
%                         suppress = [suppress; i];
%                         fprinft('error');
%                         elseif area(j)==area(i)
%                             fprintf('same area');
%                         end
                    end
                end
            end
        end
        suppress
        I(suppress) = [];
    end
    pick=I;
    
end
end