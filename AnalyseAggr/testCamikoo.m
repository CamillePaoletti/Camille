function detections = testCamikoo()    
    intensityThreshold = 0.25;    
    contrastThreshold = 1.14;
    laplacianThreshold = 0.001;
    contrastMult = 3;
    innerCellThreshold = 0.15;

    img = double(imread('/Users/camillepaoletti/Documents/Lab/segmentationFoci/RawData.png')) / 255;
    [h w d] = size(img);

    % Smooth image
    sigma = 2;%w / 300;
    filt_size  =  2*ceil(3*sigma)+1; % filter size
    intensity = imfilter(img, fspecial('gaussian', filt_size, sigma), 'same', 'replicate');

    % Keep green channel only
    R = intensity(:, :, 1);
    G = intensity(:, :, 2);
    B = intensity(:, :, 3);
    intensity = G .* ((1 - R) .* (1 - B)) .^ 1;
    mask = intensity > innerCellThreshold;    

     figure(1);
     imagesc(intensity .* mask);

    % Computes gradient
    gradX = intensity(:, [1 1:(w-1)]) - intensity(:, [2:w w]);
    gradY = intensity([1 1:(h-1)], :) - intensity([2:h h], :);
    grad = sqrt(gradX .^ 2 + gradY .^ 2);

    figure(2);
    imagesc(grad);

    sigma0 = 2;%w / 300;
    scales = 0 : 10;
    nscales = length(scales);
    detections = cell(1, nscales);
    for i = 1 : nscales
        sigma = sigma0 * (2 .^ (scales(i) / 5));
        
        % Blob detection
        filt_size  =  2*ceil(3*sigma)+1; % filter size
        LoG        =  sigma^2 * fspecial('log', filt_size, sigma);
        blobResponse = imfilter(grad, LoG, 'same', 'replicate');

        figure(3);
        imagesc(blobResponse);

        % Find local maxima
        maxima = (localMax(blobResponse) .* blobResponse .* mask) > laplacianThreshold;
        [cy cx] = find(maxima);               
        r = repmat(sigma * 2, length(cx), 1);     
        s = intensity((cx - 1) * h + cy);%vector of maxima intensity
        boxes = [cx - r, cy - r, cx + r, cy + r, s];        
        pick = nms(boxes, 0.1);        
        detections{i} = [cx(pick) cy(pick) r(pick) s(pick)];  
        
        figure(4);
        show_all_circles(intensity, detections{i}(:, 1), detections{i}(:, 2), detections{i}(:, 3));
        pause
    end
    detections = cat(1, detections{:});
    
    % Remove detection on the border and not confident enough
    cx = detections(:, 1);
    cy = detections(:, 2);
    r = detections(:, 3);    
    s = detections(:, 4); 
    boxes = [cx - r, cy - r, cx + r, cy + r];  
    detections = detections(sumIntensity(~mask, boxes) == 0 & s > intensityThreshold, :);
    
    figure(5);
    show_all_circles(img, detections(:, 1), detections(:, 2), detections(:, 3)); 
    
    % Remove overlapping boxes
    cx = detections(:, 1);
    cy = detections(:, 2);
    r = detections(:, 3);    
    s = detections(:, 4); 
    boxes = [cx - r, cy - r, cx + r, cy + r, s];    
    pick = nms(boxes, 0.00001);    
    detections = detections(pick, :);
    
%     figure(6);
%     show_all_circles(img, detections(:, 1), detections(:, 2), detections(:, 3)); 
    
    %detections = detections(1, :);

    % Computes contrast with 3 times bigger boxes (if contrastMult=3)   
    intensityMask = intensity;
    intensityMask(~mask) = mean(mean(intensity(mask)));
    cx = detections(:, 1);
    cy = detections(:, 2);
    r = detections(:, 3); 
    [s1 n1] = sumIntensity(intensityMask, [cx cy cx cy] + [-r -r r r]);
    [s2 n2] = sumIntensity(intensityMask, [cx cy cx cy] + [-r -r r r] * contrastMult);
    contrast = (s1 ./ n1) ./ ((s2 - s1) ./ (n2 - n1));%intensity in little box over intensity in surrounding area
    detections = [detections contrast];
    detections = detections(contrast > contrastThreshold, :);
    
%     figure(7);
%     show_all_circles(img, detections(:, 1), detections(:, 2), detections(:, 3)); 
        
%     figure(5)
%     contrast = sort(contrast, 'descend');        
%     plot(contrast)    
      
    figure(3);
    show_all_circles(img, detections(:, 1), detections(:, 2), detections(:, 3));        
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
    %bring back coordinates between (1,1) & (w,h)
    boxes = max(round(boxes), 1);
    boxes(:, 3) = min(boxes(:, 3), w);
    boxes(:, 4) = min(boxes(:, 4), h);
    %%%
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

      [vals, I] = sort(s);
      pick = [];
      while ~isempty(I)
        last = length(I);
        i = I(last);
        pick = [pick; i];
        suppress = [last];
        for pos = 1:last-1
          j = I(pos);
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

