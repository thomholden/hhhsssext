function positionverticalscrollbar(ad)
% tatool helper function to 
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% Firstly get the extent of the displayable axes, this means
% getting the position of the top and bottom axes
apost = get(ad.handles.(ad.axestags{1}),'Position');
aposb = get(ad.handles.(ad.axestags{end}),'Position');
% top most point to be able to scroll to
tpos = apost(2)+apost(4)+ad.defaulttitlespacing+ad.defaultaxesspacing/2;
% bottom most point to be able to scroll to
bpos = aposb(2)-ad.defaultxlabelspacing-ad.defaultaxesspacing/2;
% current figure position
fpos = get(ad.handles.tatoolfig,'Position');
% convert the above numbers into the percentage of the window to
% show with the slider
vpshown = (fpos(4)-ad.sliderwidth)/(tpos-bpos);
sliderstep = get(ad.handles.vscroll,'SliderStep');

if (vpshown == 1)
    set(ad.handles.vscroll,...
        'Value',1,...
        'SliderStep',[sliderstep(1) 10000]);
elseif (vpshown >= 0) && (vpshown < 1)
    val = (ad.sliderwidth-bpos)/((tpos-bpos)-(fpos(4)-ad.sliderwidth));
    val = max(0,min(1,val));
    % need the above line due to numerical problems of val sometime being 1+eps or 0-eps
    % and the scroller not rendering properly
    set(ad.handles.vscroll,...
        'Value',val,...
        'SliderStep',[sliderstep(1) vpshown/(1-vpshown)]);
else
    str ={'A problem has occured in positioning the vertical scroll bar.',...
            'No action has been performed.'};
    warndlg(str,'TATOOL','modal');
end
    