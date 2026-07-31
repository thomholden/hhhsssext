function varargout = cpmap(varargin)
%CPMAP Analogue of Lisp's MAPCAR.
%   [Y1,...Ym] = CPMAP(F,X1,..Xn) returns cell arrays Y1,...Ym s.t.
%   [Y1{i},...Ym{i}] = F(X1{i},...Xn{i}).
%
%   All Xi must be cell arrays otherwise they are converted using
%   NUM2CELL. CLASS(Yi) == 'cell'.
%
%   Examples
%   --------
%
%   %Nothing because nargout==0
%   cpmap(@(x) x,1)
%
%   %Cdr
%   tails = cpmap(@(x) x(2:end),{1:2,1:10})
%
%   %Apply
%   y = cpmap(@(f,x) f(x),{@(x) x,@(x) x.^2},{1:5,1:5})
%
%   %Replace non-vectors with []
%   vv = cpmap(cpif(@isvector,@(x) x,@(x) []),{1:4,[1;2],[],[1 2;3 4]})
%
%   %Apply function to a specified array dimension
%   applydim = @(f,dim) @(A) squeeze(cell2mat(cpmap(f,num2cell(A,dim))));
%   A = rand(5)
%   feval(applydim(@(x) [min(x) max(x)],2),A) %min-max
%
%   %Create several axes
%   axx = cell2mat(cpmap(...
%       @(dummy) axes('Units','pixels','Position',[1 1 1 1]),...
%       zeros([1 5])))
%
%   %"Vectorize"
%   V = @(f) @(x) cell2mat(cpmap(f,x));
%   mpower2 = V(cpbind(@mpower,2,2));
%   mpower2([1 2 3;4 5 6])