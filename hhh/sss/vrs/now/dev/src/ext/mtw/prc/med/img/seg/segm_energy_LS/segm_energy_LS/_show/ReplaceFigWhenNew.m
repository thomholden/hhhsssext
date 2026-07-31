function [tfh, isNew] = ReplaceFigWhenNew(figNo, Position)
% test existence of figure, only resize when new
% 
% 17.02.1011    - add existence bit, handy...

ReplaceFigure = false;
if nargin >1 && ~ishandle(figNo), ReplaceFigure = true; end

tfh = figure(figNo);
if ReplaceFigure
    set(tfh, 'position', Position)  
end
if nargout > 1, isNew = ReplaceFigure; end
