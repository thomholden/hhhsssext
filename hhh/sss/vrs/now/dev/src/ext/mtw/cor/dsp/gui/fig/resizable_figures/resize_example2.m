function f = resize_example2
% Example which uses resizable_figure
%
% Demonstrates use of "setcomponent" method.

% Copyright 2006-2010 The MathWorks, Inc.

% create figure
f = resizable_figure('Show Graph');

% create controls
btn = uicontrol('parent',f,'style','pushbutton','string','Add Axes');

% create element matrix and apply it.  Where a string is supplied in
% place of a handle, it can be replaced later using "setcomponent".
elements = {...
    'my_axes', [];...
    [],       btn;...
    };
f.UserData = setelements(f.UserData,elements);

% set sizes (rows first, then columns)
f.UserData = setsizes(f.UserData,[ -100, 25 ], [ -100, 100 ]);
% set spacing (X, Y)
f.UserData = setspacing(f.UserData,5, 5);
% set border (X, Y)
f.UserData = setpadding(f.UserData,45, 25);

% Position figure in middle of screen and set its size
centrefigure([],f,[500,250] );

set(btn,'callback',{@i_addaxes,f,btn});

% Show the figure
f.visible = 'on';

%%%%%%%%%%%%%%%%%%%%%
function i_addaxes(~,~,f,btn)

ax = axes('Parent',f,'Units','pixels','box','on'); % units must be pixels!
view(ax,3);
f.UserData = setcomponent(f.UserData,'my_axes',ax);
set(btn,'enable','off'); % can only set each named component once

