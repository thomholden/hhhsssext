function [left top right bottom] = getnode(k,N)
%GETNODE   Select current boundary node on 2D spectral grid.
%   Inputs:  k - selected node
%            N - polynomial degree in x and y direction
%
%   Outputs: sides of the square
%
%   The sides are numbered clockwisely starting with the left side.
%
%   See also   PL_PROBLEM

%   Zoltán Csáti
%   2014/07/05

side = ceil(k/(N-1)); % side of the square
localNode = k-(side-1)*(N-1); % node on the current side

left = zeros(N-1,1);
bottom = left;
right = left;
top = left;
switch side % counterclockwise ordering starting with the left side
    case 1
        left(localNode) = 1;
    case 2
        top(localNode) = 1;
    case 3
        right(localNode) = 1;
        right = right(N-1:-1:1); % reverse ordering
    case 4
        bottom(localNode) = 1;
        bottom = bottom(N-1:-1:1); % reverse ordering
    otherwise
        error('MATLAB:getnode:largeInput', ...
              'Iteration number must be %d at most.',4*N-4);
end
% Bound the internal nodes with the corner nodes
left = [0; left; 0];
bottom = [0; bottom; 0];
right = [0; right; 0];
top = [0; top; 0];