function [varargout] = cpreduce(varargin)
%CPREDUCE Analogue of Lisp's REDUCE.
%   Y = CPREDUCE(F,X,X0) returns F(F(...F(F(X0,X{1}),X{2}),...),X{N}). X
%   must be 1-dimensional cell array otherwise it is converted using
%   NUM2CELL.
%   Y = CPREDUCE(F,X) is equivalent to Y = CPREDUCE(F,X(2:end),X{1}).
%
%   Examples
%   --------
%
%   %Convert to vector
%   v = cpreduce(@(x,y) [x;y],[1 2;3 4])
%
%   %Sum
%   s = cpreduce(@(x,y) x+y,1:10)
%
%   %Cumulative function
%   cumf = @(f) @(varargin) cpreduce(@(x,y) [x;f(x(end),y)],varargin{:});
%   cumsum2 = cumf(@(x,y) x+y);
%   cumsum2(1:10)==cumsum(1:10)'