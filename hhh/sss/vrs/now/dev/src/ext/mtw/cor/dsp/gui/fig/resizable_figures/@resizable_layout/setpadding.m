function obj = setpadding(obj,xpad,ypad)
%RESIZABLE_LAYOUT/SETPADDING  Sets the padding around the layout.
%
% setpadding(obj,xpad,ypad);
%
% xpad is the gap at each size of the layout.
% When there is insufficient space, this will be reduced.
%
% ypad is the gap at each side of the layout.
% When there is insufficient space, this will be reduced.
%
% The default padding is 5 pixels on all sides.
%
% The controls are positioned automatically when this function is called.
%

% Copyright 2006-2010 The MathWorks, Inc.

ASSERT(nargout==1,'Output argument required');

obj.xpad = xpad;
obj.ypad = ypad;

if ~isempty(obj.position)
    obj = resize(obj,obj.position);
end

