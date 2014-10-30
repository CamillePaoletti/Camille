function tiff2video(file, out_dir, fps, text_color, text_pos)
    info = imfinfo(file);
    w = info(1).Width;
    h = info(1).Height;
    
    if nargin < 4
        text_color = [0.9 0.9 1];
    end
    if nargin < 5
        text_pos = [w h] - [3 1];
        h_align = 'right';
        v_align = 'bottom';
    end
    
    n_img = length(info);
    img = zeros(info(1).Height, info(1).Width, n_img);
    
    hfig = figure('Resize', 'off', 'PaperPosition', [1 1 w h], 'Position', [100 100 w h], 'PaperPositionMode', 'auto', 'InvertHardcopy','off', 'Color', 'w');
    
    % The window may have a minimum size, if so, we resize it so that the
    % image takes full window
    pos = get(hfig, 'Position');
    scale = max(pos(3:4) ./ [w h]);
    wsize = ceil([w h] * scale); 
    set(hfig, 'Position', [100 100 wsize]);
    
    haxis = axes('Position', [0 0 1 1], 'XLim', [1 w], 'YLim', [1 h]);
    
    dt = 1 / fps;
    for i = 1 : n_img
        I = imread(file, i);
        I = repmat(I, [1 1 3]);
        imagesc(I);
        hold on;
        text(text_pos(1), text_pos(2), sprintf('%0.2fs', (i-1)*dt), 'Color', text_color, 'HorizontalAlignment', h_align, 'VerticalAlignment', v_align);
        hold off;
        set(haxis, 'Visible', 'off');
        set(haxis, 'DataAspectRatio', [1 1 1]);
        print(fullfile(out_dir, sprintf('img%04d.png', i)), '-dpng', '-r0');
    end
    
    close(hfig);
end