function [correlX correlY pos1 pos2] = correl2D(p1, p2, windowSize, maxOffset)
    pos1max = length(p1) - windowSize + 1;
    pos2max = length(p2) - windowSize + 1;
    noffsets =  2 * maxOffset + 1;
    
    correlX = cell(noffsets, 1);
    correlY = cell(noffsets, 1);
                        
    [pos2 pos1] = meshgrid(1 : pos2max, 1 : pos1max);
    pos1 = repmat(pos1, [1 1 noffsets]);        
    pos2 = repmat(pos2, [1 1 noffsets]);
    for t = 1 : noffsets
        offset = t - maxOffset - 1;%time
        if offset >= 0
            pos2(:, :, t) = pos2(:, :, t) + offset;
        else
            pos1(:, :, t) = pos1(:, :, t) - offset;
        end
        correlX{t} = correl1D(p1(1, :), p2(1, :), windowSize, offset);%matrix with "cross-corr" coeff for each sliding window at time t
        correlY{t} = correl1D(p1(2, :), p2(2, :), windowSize, offset);
    end
    correlX = cat(3, correlX{:});
    correlY = cat(3, correlY{:});    
end

function correl = correl1D(s1, s2, ws, t)
    correl = -Inf * ones(length(s1), length(s2));
    for i = max(1, 1 - t) : (length(s1) - ws + 1)
        w1 = normalize(s1(i : (i + ws - 1)));%normalized vector of lenght ws starting at i
        for j = max(1, 1 + t) : (length(s2) - ws + 1)
            w2 = normalize(s2(j : (j + ws - 1)));
            correl(i, j) = mean(w1 .* w2);%mean of scalar product of center and normalized position
        end
    end
end

function s = normalize(s)
    s = (s - mean(s));
    s = s / sqrt(mean(s .^ 2));
end