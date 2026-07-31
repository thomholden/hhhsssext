function obj = setelements(obj,elements)
%RESIZABLE_LAYOUT/SETELEMENTS  Sets the controls which will be positioned.
%
% setelements(obj,elements);
%
% elements is a cell-matrix of uicontrol handles.
% elements{1,1} will be positioned at the top-left of the figure.
% elements{i,j} will be positioned in row i & column j of the grid.
%
% By default, all rows and columns are the same size and resize with
% the figure.  If row and column sizes have already been set, the
% number of elements must be correct or they will be discarded.
%
% Elements can be left empty.  Controls can be made to span more than
% one row and/or column.  See the setmergeblocks method.  If this case,
% the entry for that control in the elements matrix must be at the top-left
% corner of its region, i.e. the position with the lowest row and column
% index.
%
% The controls are positioned automatically when this function is called.
%

% Copyright 2006-2010 The MathWorks, Inc.

ASSERT(nargout==1,'Output argument required');

obj.elements = elements;

s = size(elements);

if length(obj.rowsizes)~=s(1)
    obj.rowsizes = repmat(-1,s(1),1);
end

if length(obj.colsizes)~=s(2)
    obj.colsizes = repmat(-1,s(2),1);
end

if ~isempty(obj.position)
    obj = resize(obj,obj.position);
end


