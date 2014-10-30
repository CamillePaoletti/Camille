%segment budneck function [budneck]=phy_segmentFociNew(img,parametres)
function [detections]=phy_segmentFociGradient(img,parametres)

%parametres
intensityThreshold = 0.048;%0.25;%
contrastThreshold =1.07;
laplacianThreshold = 0.001;
contrastMult = 3;
innerCellThreshold = 0.04;

budneck=phy_Object;%initialize
%==========================================================================

%==========================================================================
%find mask of budnecks by tresh hold and watershed

%%%%%%%%
im=double(img);
im=im/2^14;%max(max(img));
im=imresize(im,2);%4);
[h w d] = size(im);

%Smooth image
sigma = 1;%2;%w / 300;
filt_size  =  2*ceil(3*sigma)+1; % filter size
intensity = imfilter(im, fspecial('gaussian', filt_size, sigma), 'same', 'replicate');

% intensity=imresize(intensity,0.25);
% [h w d] = size(intensity);

mask = intensity > innerCellThreshold;
%%%%%%%%%%%


% imgMed = medfilt2(img,[4 4]);% filtre median
% %substract background
% warning off all
% background = imopen(img,strel('disk',parametres{4,2}));
% warning on all
% I2 = imsubtract(imgMed,background);
%
% cells_mean=mean2(I2);
% cells_stdv=std2(I2);
% cells_max=max(max(I2));
%
% if cells_max==0
%     errordlg('Image to be segmented is not displayed !');
%     return;
% end
%
% I2=phy_scale(I2);% scale image (0 1)
% intensity=double(I2);
% intensity=imresize(intensity,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure(2);
% imagesc(intensity.*mask);
% colorbar;

% Computes gradient
gradX = intensity(:, [1 1:(w-1)]) - intensity(:, [2:w w]);
gradY = intensity([1 1:(h-1)], :) - intensity([2:h h], :);
grad = sqrt(gradX .^ 2 + gradY .^ 2);


sigma0 = 1;%2;%w / 300;
scales = 0 : 10;
nscales = length(scales);


detections = cell(1, nscales);



for i = 1 : nscales
    sigma = sigma0 * (2 .^ (scales(i) / 5));
    
    % Blob detection
    filt_size  =  2*ceil(3*sigma)+1; % filter size
    LoG        =  sigma^2 * fspecial('log', filt_size, sigma);
    blobResponse = imfilter(grad, LoG, 'same', 'replicate');
    
    %                 figure(3);
    %                 imagesc(blobResponse);
    %                 colorbar;
    
    % Find local maxima
    maxima = (localMax(blobResponse) .* blobResponse .* mask) > laplacianThreshold;
    [cy cx] = find(maxima);
    r = repmat(sigma * 2, length(cx), 1);
    s = intensity((cx - 1) * h + cy);
    boxes = [cx - r, cy - r, cx + r, cy + r, s];
    pick = nms(boxes, 0.1);
    detections{i} = [cx(pick) cy(pick) r(pick) s(pick)];
    
    %                 figure(4);
    %                 show_all_circles(intensity, detections{i}(:, 1), detections{i}(:, 2), detections{i}(:, 3));
    %                 pause
end
detections = cat(1, detections{:});
% figure(4);
% show_all_circles(img, round(detections(:, 1)/2), round(detections(:, 2)/2), detections(:, 3)/2);

% Remove detection on the border and not confident enough
cx = detections(:, 1);
cy = detections(:, 2);
r = detections(:, 3);
s = detections(:, 4);
boxes = [cx - r, cy - r, cx + r, cy + r];
detections = detections(sumIntensity(~mask, boxes) == 0 & s > intensityThreshold, :);
% figure(5);
% show_all_circles(img, round(detections(:, 1)/2), round(detections(:, 2)/2), detections(:, 3)/2);

% Remove overlapping boxes
cx = detections(:, 1);
cy = detections(:, 2);
r = detections(:, 3);
s = detections(:, 4);
boxes = [cx - r, cy - r, cx + r, cy + r, s];
pick = nms(boxes, 0.00001);%nmsBig(boxes, 1);%
detections = detections(pick, :);
% figure(6);
% show_all_circles(img, round(detections(:, 1)/2), round(detections(:, 2)/2), detections(:, 3)/2);

%detections = detections(1, :);

% Computes contrast with 3 times bigger boxes
intensityMask = intensity;
intensityMask(~mask) = mean(mean(intensity(mask)));
cx = detections(:, 1);
cy = detections(:, 2);
r = detections(:, 3);
[s1 n1] = sumIntensity(intensityMask, [cx cy cx cy] + [-r -r r r]);
[s2 n2] = sumIntensity(intensityMask, [cx cy cx cy] + [-r -r r r] * contrastMult);
contrast = (s1 ./ n1) ./ ((s2 - s1) ./ (n2 - n1));
detections = [detections contrast];
detections = detections(contrast > contrastThreshold, :);

% figure(9)
% contrast = sort(contrast, 'descend');
% plot(contrast)


detections(:,1:3)=detections(:,1:3)/2;

%remove foci <1pix
%test=detections(:,3);
%a= test>1.5 ;
%detections=detections(a,:);

%figure(7);
%show_all_circles(img, detections(:, 1), detections(:, 2), detections(:, 3));
%colormap(gray);



end

function mask = localMax(intensity)
[h w] = size(intensity);
mask = intensity >= max(cat(3, intensity(:, [1 1:(w-1)]), ...
    intensity(:, [2:w w]), ...
    intensity([1 1:(h-1)], :), ...
    intensity([2:h h], :)), [], 3);
end

function [s n] = sumIntensity(intensity, boxes)
[h w] = size(intensity);
boxes = max(round(boxes), 1);
boxes(:, 3) = min(boxes(:, 3), w);
boxes(:, 4) = min(boxes(:, 4), h);

s = zeros(size(boxes, 1), 1);
n = zeros(size(boxes, 1), 1);
for i = 1 : size(boxes, 1)
    I = intensity(boxes(i, 2) : boxes(i, 4), boxes(i, 1) : boxes(i, 3));
    s(i) = sum(sum(I));
    n(i) = numel(I);
end
end

function pick = nms(boxes, overlap)
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
    s = boxes(:,end);
    area = (x2-x1+1) .* (y2-y1+1);
    
    [vals, I] = sort(s);%vals=sorted maximum signal values//I=index//vals=s(I)
    pick = [];
    while ~isempty(I)
        last = length(I);
        i = I(last);
        pick = [pick; i];
        suppress = [last];
        for pos = 1:last-1
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
                if o > overlap
                    suppress = [suppress; pos];
                end
            end
        end
        I(suppress) = [];
    end
end
end

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
        i = I(last);
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
        I(suppress) = [];
    end
    pick=I;
    
end
end

function show_all_circles(I, cx, cy, rad, color, ln_wid)
if nargin < 5
    color = 'r';
end

if nargin < 6
    ln_wid = 1.5;
end

imagesc(I); hold on;

theta = 0:0.1:(2*pi+0.1);
cx1 = cx(:,ones(size(theta)));
cy1 = cy(:,ones(size(theta)));
rad1 = rad(:,ones(size(theta)));
theta = theta(ones(size(cx1,1),1),:);
X = cx1+cos(theta).*rad1;
Y = cy1+sin(theta).*rad1;
line(X', Y', 'Color', color, 'LineWidth', ln_wid);
end