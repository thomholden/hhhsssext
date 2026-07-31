function resizecb(obj,eventdata) %#ok
% tatool helper function for resizing the figure (tatool) window.
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% Workaround for bug in usage of LEGEND in R14SP1
axislocations_set(obj);

% Now do tatool specific resizing
ad = guidata(obj);
fpos = get(ad.handles.tatoolfig,'Position');
if fpos(4) < 40  % enforce a minimum height
    fpos(4) = 40;
end
% need maximum extent of plots on figure
apost = get(ad.handles.(ad.axestags{1}),'Position');
aposb = get(ad.handles.(ad.axestags{end}),'Position');
% top most point to be able to scroll to
tpos = apost(2)+apost(4)+ad.defaulttitlespacing+ad.defaultaxesspacing/2;
% bottom most point to be able to scroll to
bpos = aposb(2)-ad.defaultxlabelspacing-ad.defaultaxesspacing/2;
extent = tpos-bpos;
if extent < fpos(4)-ad.sliderwidth
    % enforce a maximum height, keeping the top-left stationary
    offset = (fpos(4)-ad.sliderwidth)-extent;
    fpos = fpos+[0 offset 0 -offset];
end
set(ad.handles.tatoolfig,'Position',fpos);
fposo = ad.defaultfigureposition;

% reposition horizontal scroll bar
set(ad.handles.hscroll,'Position',[0 0 fpos(3)-ad.sliderwidth+1 ad.sliderwidth]);
% reposition vertical scroll bar
set(ad.handles.vscroll,'Position',...
    [fpos(3)-ad.sliderwidth+1 ad.sliderwidth ad.sliderwidth fpos(4)-ad.sliderwidth]);
% reposition corner text box
set(ad.handles.cornerscrollmask,...
    'Position',[fpos(3)-ad.sliderwidth+1 1 ad.sliderwidth ad.sliderwidth-1]);

% need number of axes
na = length(ad.axestags);

% process width
if fpos(3) < fposo(3)  % width is smaller than original
    % set scroll position
    val = get(ad.handles.hscroll,'Value');
    hpshown = fpos(3)/fposo(3);
    set(ad.handles.hscroll,'SliderStep',[0.1 hpshown/(1-hpshown)]);
    % loop through axes and ensure they are set to the original width
    for idx = 1:na
        ah = ad.handles.(ad.axestags{idx});
        apos = get(ah,'Position');
        apos(1) = ad.defaultleftmargin-val*(1-hpshown)*fposo(3);
        apos(3) = fposo(3)-ad.sliderwidth-ad.defaultleftmargin-ad.defaultrightmargin;
        set(ah,'Position',apos);
    end
else % width is larger than original
    set(ad.handles.hscroll,'Value',0,'SliderStep',[0.1 10000]);
    % loop through axes and set their width to fullest extent
    for idx = 1:na
        ah = ad.handles.(ad.axestags{idx});
        apos = get(ah,'Position');
        apos(1) = ad.defaultleftmargin;
        apos(3) = fpos(3)-ad.sliderwidth-ad.defaultleftmargin-ad.defaultrightmargin;
        set(ah,'Position',apos);
    end
end

% process height
if tpos < fpos(4)
    % We're showing the top of price plot so don't scroll it down any
    % further.  i.e. loop through axes and position them accordingly
    ad.handles.(ad.axestags{1}); %#ok will alsways be prices plot
    offset = fpos(4)-tpos;
    for idx = 1:na
        ah = ad.handles.(ad.axestags{idx});
        apos = get(ah,'Position');
        set(ah,'Position',apos+[0 offset 0 0]);
    end
end
% ensure sliders are positioned correctly
positionverticalscrollbar(ad);

% ensure the legends are redrawn
legend('ResizeLegend');

% force a redraw
drawnow

% Workaround for bug in usage of LEGEND in R14SP1
axislocations_store(ad.handles.tatoolfig);

