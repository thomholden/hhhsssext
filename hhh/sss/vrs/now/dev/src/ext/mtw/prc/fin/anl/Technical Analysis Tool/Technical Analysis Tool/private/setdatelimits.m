function setdatelimits(xdata,ydata,uxdmin,uxdmax)
% function setdatelimits(xdata,ydata,uxdmin,uxdmax)
% Function for setting the x and y limits of the current axes.
%
% xdata and ydata are typically the complete data sets for the axes.
% uxdmin and uxdmax are scalars representing the extent of the xdata
% (which in turn limits the ydata) that you wish plotted.
%
% If there is no xdata between uxdmin and uxdmax then no action is
% performed
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if nargin ~= 4
    str = [mfilename,' must be called with 4 inputs.'];
    error(str);
end
[mx,nx]=size(xdata);
[my,ny]=size(ydata);
if (mx~=my) || (nx~=ny)
    str = ['The first 2 inputs of ',mfilename,' must have the same dimensions.'];
    error(str);
elseif (mx~=1)&&(my~=1)
    str = ['The first 2 inputs to ',mfilename,' must be vectors'];
    error(str);
end

if ~isa(uxdmin,'double') || numel(uxdmin)~=1
    str = ['Third input to ',mfilename,' must be a scalar.'];
    error(str);
end
if ~isa(uxdmax,'double') || numel(uxdmax)~=1
    str = ['Fourth input to ',mfilename,' must be a scalar.'];
    error(str);
end
newdata = xdata(xdata>=uxdmin & xdata<=uxdmax);

if ~isempty(newdata) % There id data to plot
    % Create temporary axis and plot to it to get tick positions and labels
    % There may be a more efficient way to do this?
    ha_orig = gca;
    pos = get(ha_orig,'Position'); % Make axes same size so grid isn't squished
    ha_temp = axes('Units','pixels',...
        'Visible','off',...
        'Position',[pos(1:2) 1.5*pos(3:4)]);
    line(xdata(xdata>=uxdmin & xdata<=uxdmax),ydata(xdata>=uxdmin & xdata<=uxdmax),...
        'Visible','off');
    datetick('x');
    axis('tight');
    xl=get(ha_temp,'XLim');
    xt=get(ha_temp,'XTick');
    xtl=get(ha_temp,'XTickLabel');
    yl=get(ha_temp,'YLim');
    yt=get(ha_temp,'YTick');
    delete(ha_temp);

    % set axis limits
    axis(ha_orig);
    set(ha_orig,...
        'XLim',xl,...
        'YLim',yl,...
        'XTick',xt,...
        'XTickLabel',xtl,...
        'YTick',yt,...
        'YTickLabel',num2str(yt'));
    legend(ha_orig);
end