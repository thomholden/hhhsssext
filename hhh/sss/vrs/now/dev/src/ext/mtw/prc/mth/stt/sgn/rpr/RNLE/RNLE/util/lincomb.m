%LINCOMB   Linear combination of array slices
%   
%   Y=LINCOMB(X,W,DIM) returns the linear combination formed by the slices
%   of array X along dimension D with coefficients W.
%   
%   Input X must be a numeric array with real elements. Input W must be a
%   vector of length SIZE(X,DIM) with real elements. Input DIM must be a
%   positive integer.
%   
%   This low-level function is considerably more efficient -both in terms
%   of execution time and memory-than calling PERMUTE, TIMES and SUM to
%   perform the same operation.
%   
%   See also PERMUTE, TIMES and SUM.
%   
%   Copyright (c) 2012 Gabriel Agamennoni.