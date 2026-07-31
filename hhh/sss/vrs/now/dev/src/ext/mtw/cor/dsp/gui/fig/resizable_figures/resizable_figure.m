function fig = resizable_figure(name,varargin)
%RESIZABLE_FIGURE Figure wrapper which uses resizable_layout
%
% fig = resizable_figure(name,varargin)
%
% name is a string.
% varargin can include any property_name-property_value pairs, which
% are passed to the figure's set function.
%
% The returned figure has no numbertitle or menubar, and is invisible.
% Its "UserData" property is an instance of resizable_layout.
%
% To set properties of the layout, call e.g.
%   fig.UserData = setelements(fig.UserData, elements);
%   fig.UserData setsizes(fig.UserData, rowsizes, columnsizes);
%

% Copyright 2006-2010 The MathWorks, Inc.

if nargin<1
    name = 'Untitled Figure';
end

fig = handle(figure('numbertitle','off',...
                    'name',name,...
                    'visible','off',...
                    'menubar','none',...
                    varargin{:}));

set(fig,'color',get(double(fig),'defaultuicontrolbackgroundcolor'))

fig.UserData = resizable_layout(fig);
set(fig,'ResizeFcn',{@i_resize,fig});
i_resize([],[],fig);

%%%%%%%%%%%%%
function i_resize(src,evt,fig)

p = get(fig,'Position');
p(1) = 0;
p(2) = 0;
fig.UserData = resize(fig.UserData, p);

