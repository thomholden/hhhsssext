function obj = setmergeblocks(obj,blocks)
%RESIZABLE_LAYOUT/SETMERGEBLOCKS Sets "mergeblocks" so that a control can occupy multiple cells.
%
% setmergeblocks(obj,blocks)
%
% blocks is an n*4 matrix, in which each row specified a merged block, i.e.
% a region of cells occupied by a single control.
% For that merged block, the four elements in the matrix specify:
%   it's top-most row in the grid
%   it's bottom-most row in the grid
%   it's left-most column in the grid
%   it's right-most column in the grid
% In the "elements" matrix, the control must appear in the top-left corner of
% the merged block, and all other cells must be empty.
%
% The controls are re-positioned automatically by this function.
%

% Copyright 2006-2010 The MathWorks, Inc.

ASSERT(nargout==1,'Output argument required');

if ~isempty(blocks) && size(blocks,2)~=4
    error('Wrong number of elements');
end

s = size(obj.elements);
rows = s(1);
cols = s(2);

rowmins = blocks(:,1);
rowmaxs = blocks(:,2);
colmins = blocks(:,3);
colmaxs = blocks(:,4);

if any(rowmins>rows) || any(rowmaxs>rows)
    error('Merge row indices out of range');
elseif any(colmins>cols) || any(colmaxs>cols)
    error('Merge column indices out of range');
end

obj.mergeblocks = blocks;

if ~isempty(obj.position)
    obj = resize(obj,obj.position);
end



