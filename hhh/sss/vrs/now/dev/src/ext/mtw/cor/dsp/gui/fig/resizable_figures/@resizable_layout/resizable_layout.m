function obj = resizable_layout(parent)
%RESIZABLE_LAYOUT - Positions uicontrols in a grid-structure in a resizable_figure.
%
% Do not hold instances of this class directly.  This is handled by
% resizable_figure.
% 
% obj = resizable_layout(fig);
% obj = resizable_layout(parentlayout);
%
% Call setelements before either setsizes or setmergeblocks.
% setpadding can be called at any time.
%

% Copyright 2006-2010 The MathWorks, Inc.

if isa(parent,'resizable_layout')
    fig = parent.parent;
    while isa(fig,'resizable_layout')
        fig = fig.parent;
    end
else
    fig = parent;
    parent = [];
end

s = struct('fig',fig,...
           'parent',parent,...
           'elements',[],...
           'rowsizes',[],...
           'colsizes',[],...
           'xpad',5,...
           'ypad',5,...
           'xspace',10,...
           'yspace',10,...
           'mergeblocks',[],...
           'position',[]);

obj = class(s,'resizable_layout');


