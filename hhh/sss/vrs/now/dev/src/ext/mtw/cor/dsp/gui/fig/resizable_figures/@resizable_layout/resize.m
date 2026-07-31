function obj = resize(obj,p)
%RESIZABLE_LAYOUT/RESIZE Private method

% Copyright 2006-2010 The MathWorks, Inc.

ASSERT(nargout==1,'Output argument required');

el = obj.elements;
s = size(el);

obj.position = p;

if any(s==0)
    return;
end

% Bring boundaries in to allow for outer padding
p(1) = p(1) + obj.xpad;
p(3) = p(3) - 2*obj.xpad;
p(2) = p(2) + obj.ypad;
p(4) = p(4) - 2*obj.ypad;

p(p<0) = 0;

%[cs,rs,xspace,yspace] = i_calcsizes(obj.colsizes,obj.rowsizes,p(3),p(4),obj.xspace,obj.yspace);
[cs,xspace] = i_calc_sizes(obj.colsizes,obj.xspace,p(3));
[rs,yspace] = i_calc_sizes(obj.rowsizes,obj.yspace,p(4));

yrunning = p(2) + p(4);
for i = 1:s(1)
    xrunning = p(1);
    for j = 1:s(2)
        x = xrunning;%i_col_position(xspace,cs,j) + p(1);
        if ~isempty(el{i,j})
            [merge,rows,cols] = i_checkmergeblock(obj.mergeblocks,i,j);
            if ~merge
                height = rs(i);
                width = cs(j);
            else
                height = sum(rs(i:i+rows-1)) + (rows-1)*yspace;
                width = sum(cs(j:j+cols-1)) + (cols-1)*xspace;
            end
            y = yrunning - height;
            e = el{i,j};
            pos = [x y width height];
            %disp(sprintf('i %d, j %d, %d %d %d %d',i,j,pos(1),pos(2),pos(3),pos(4)));
            if ischar(e)
                % "External" control, not yet supplied.  Don't do
                % anything here.
            elseif i_isactivex(e)
                move(e,pos);
            elseif isa(e,'resizable_layout')
                obj.elements{i,j} = resize(e,pos);
            elseif width>0 && height>0
                set(e,'position',pos);
            end
        end
        xrunning = xrunning + cs(j) + xspace;
    end
    yrunning = yrunning - rs(i) - yspace;
end


%%%%%%%%%%%%%%%%%%%%
function [sizes,spacing] = i_calc_sizes(sizes,spacing,available)

num = length(sizes);
variable = sizes<0;
fixed = sizes>0;

numvariable = sum(variable);
sumfixed = sum(sizes(fixed));
sumspaces = spacing*(num-1);

% Space required for fixed-width rows and spaces plus one pixel per variable-width row
required = sumfixed + sumspaces + numvariable;

if required>available
    % Not enough width.  Reduce spacing and fixed-width columns to fit
    if required==numvariable
        spacing = 0;
        sizes = ones(size(sizes));
        return;
    else
        ratio = (available - numvariable) / (required - numvariable );
    end
    spacing = floor(spacing * ratio); % round down
    % Recalculate the ratio, since we just rounded down the spacings
    ratio = (available - numvariable - spacing*(num-1)) / sumfixed;    
    sizes(fixed) = floor( sizes(fixed) * ratio ); % round down again
    sizes(variable) = 1;
else
    % Enough width.  Share remaining width among variable-width columns, according
    % to the specified ratios.
    space = available - sumfixed - sumspaces;
    ratios = sizes(variable);
    multiplier = space / sum(ratios);
    sizes(variable) = floor( ratios * multiplier);
end
sizes(sizes<=0) = 1; % no zero-width columns


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% blocks is the mergeblocks matrix.
% i & j are the row and column index of the current cell.
% merge is non-zero if this is the first cell in a mergeblock.
% When merge is non-zero:
%  rows is the number of cells which this block spans vertically.
%  cols is the number of cells which this block spans horizontally.
function [merge,rows,cols] = i_checkmergeblock(blocks,i,j)

merge = 0;
rows = 1;
cols = 1;

if isempty(blocks)
    return;
end

candidates = blocks(blocks(:,1)==i,:); % rows which match i
if ~isempty(candidates)
    candidates = candidates(candidates(:,3)==j,:); % columns which match j
end

if ~isempty(candidates)
    merge = 1;
    rows = candidates(1,2) - candidates(1,1) + 1;
    cols = candidates(1,4) - candidates(1,3) + 1;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function b = i_ismatlab7
%I_ISMATLAB7 Returns true if the current MATLAB version is 7 or later
%
% b = i_ismatlab7

persistent p;

if isempty(p)
    s = ver('matlab');
    v = s.Version;
    % Numeric equivalent
    n = sscanf(v, '%f');
    if length(n)>1
        % This may happen if version has more than one point, eg 2.1.1
        n = sum(n.*logspace(0, 1-length(n), length(n))');
    end
    p = (n>=7);
end
    
b = p;

%%%%%%%%%%%%%%%%%%%%%
function b = i_isactivex(h)
%I_ISACTIVEX Returns true for handles to ActiveX controls
if i_ismatlab7
    b = iscom(h);
else
    b = isa(h,'activex');
end
