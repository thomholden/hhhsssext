function obj = setsizes(obj,rowsizes,colsizes)
%RESIZABLE_LAYOUT/SETSIZES Sets the sizes of the rows and columns in the grid
%
% setsizes(obj,rowsizes,colsizes);
%
% A position size is treated as a number of pixels.  Rows and columns
% with positive sizes remain at a fixed size while there is enough space.
%
% A negative size is treated as a ratio.  Rows and columns with negative
% sizes grow to occupy the available space, keeping a fixed ratio between
% their sizes.
%
% At least one row and one column must have a negative size.
%
% rowsizes is a numeric array where the number of elements is the number of
% rows in the grid, i.e. size(obj.elements,1)
% colsizes is a numeric array where the number of elements is the number of
% columns in the grid, i.e. size(obj.elements,2)
%
% The controls are re-positioned automatically by this function.
%

% Copyright 2006-2010 The MathWorks, Inc.

ASSERT(nargout==1,'Output argument required');

if ~isempty(obj.elements)
    s = size(obj.elements);
    if length(rowsizes)~=s(1)
        error('Wrong number of rows');
    end
    if length(colsizes)~=s(2)
        error('Wrong number of columns');
    end
end

if all(rowsizes>0)
    error('No resizable rows');
elseif all(colsizes>0)
    error('No resizable columns');
end

obj.rowsizes = rowsizes;
obj.colsizes = colsizes;

if ~isempty(obj.position)
    obj = resize(obj,obj.position);
end

