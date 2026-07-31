function scrollcb(obj, eventdata) %#ok
% tatool helper function to handle the callback for the vertical and
% horizontal scroll bars.
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);
% get figure position
fpos = get(ad.handles.tatoolfig,'Position');
% get the position of the top and bottom most axes
apost = get(ad.handles.(ad.axestags{1}),'Position');
aposb = get(ad.handles.(ad.axestags{end}),'Position');
na = length(ad.axestags); % number of axes
val = get(obj,'Value');

switch get(obj,'Tag')
    case 'vscroll'
        % callback for vertical slider
        % top most point to be able to scroll to
        tpos = apost(2)+apost(4)+ad.defaulttitlespacing+ad.defaultaxesspacing/2;
        % bottom most point to be able to scroll to
        bpos = aposb(2)-ad.defaultxlabelspacing-ad.defaultaxesspacing/2;
        offset = ((tpos-bpos)-(fpos(4)-ad.sliderwidth))*val;
        for idx = na:-1:1 % loop through the axes and position them
            apos = get(ad.handles.(ad.axestags{idx}),'Position');
            apos(2) = ...
                ad.sliderwidth + ...
                ad.defaultaxesspacing/2 +...
                ad.defaultxlabelspacing +...
                (na-idx)*(apost(4)*ad.defaultrelativeheight + ad.defaulttitlespacing +...
                ad.defaultxlabelspacing + ad.defaultaxesspacing) -...
                offset;
            set(ad.handles.(ad.axestags{idx}),'Position',apos);        
        end
    case 'hscroll'
        % callback for horizontal slider
        % Only need to do anything if the figure is smaller than the
        % original width
        fposo = ad.defaultfigureposition;
        if fpos(3) < fposo(3)  % width is smaller than original
            % get percentage shown and current slider value
            hpshown = fpos(3)/fposo(3); % which should also be = sliderstep(2)/(1+sliderstep(2))
            offset = fposo(3)*(1-hpshown)*val;
            for idx = 1:na % loop through axes and position them
                apos = get(ad.handles.(ad.axestags{idx}),'Position');
                apos(1) = ad.defaultleftmargin-offset;
                set(ad.handles.(ad.axestags{idx}),'Position',apos);        
            end        
        end
    otherwise
        str = 'scrollcb can only deal with objects with Tag ''vscroll'' or ''hscroll''.';
        error(str);
end

% in both cases update the legend
legend('ResizeLegend');
drawnow