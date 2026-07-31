function obj = setspacing(obj,xspace,yspace)
%RESIZABLE_LAYOUT/SETSPACING Sets the spacing between elements
%
% setspacing(obj,xspace,yspace);
%
% xspace is the horizontal spacing between cells
% When there is insufficient space, this will be reduced.
%
% yspace is the vertical spacing between cells
% When there is insufficient space, this will be reduced.
%
% The default padding is 10 pixels in both directions.
%
% The controls are positioned automatically when this function is called.
%

% Copyright 2006-2010 The MathWorks, Inc.

ASSERT(nargout==1,'Output argument required');

obj.xspace = xspace;
obj.yspace = yspace;

if ~isempty(obj.position)
    obj = resize(obj,obj.position);
end
