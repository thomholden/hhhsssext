function [derx dery Xmesh Ymesh] = partialder(fcn,grid,D)
%PARTIALDER   First order partial derivatives of a two-variable function.
%   [DERX DERY XMESH YMESH] = PARTIALDER(FCN,GRID,D) approximates the first
%   order partial derivatives of the function FCN at the Chebyshev tensor 
%   product GRID using the differentiation matrix D.
%
%   This file is intended to serve in a time-dependent solver. For the
%   standalone creation of partial derivatives, see the standalone version.
%
%   See also   DERMATRIX, PARTIALDER_STANDALONE

%   Zoltán Csáti
%   2014/09/20


Xmesh = grid{1};
Ymesh = grid{2};
% Put the function to be differentiated into correct form
if isa(fcn,'function_handle')
    f = fcn(Xmesh,Ymesh);
elseif isa(fcn,'numeric')
    f = fcn;
else
    error('MATLAB:partialder:wrongClass', ...
          'Input must be either a function handle or a numeric matrix.');
end
derx = f*D.';
dery = D*f;