function varargout = cpfilter(p,varargin)
%CPFILTER Analogue of Lisp's FILTER.
%   [Y1,...Yn] = CPFILTER(P,X1,...Xn) returns al such X1,...Xn that
%   LOGICAL(P(X1,...Xn)) is not false.
%
%   All Xi must be cell arrays otherwise they are converted using
%   NUM2CELL. CLASS(Yi) == CLASS(Xi).
%
%   Examples
%   --------
%
%   [x,y,z] = cpfilter(@(x,y,z) x>y&y>z,1:4,[1 1 1 5],[1 1 0 1])
%
%   %Get vectors
%   vectors = cpfilter(@isvector,{1:4,[1;2],[],[1 2;3 4]})

trues = logical(cell2mat(cpmap(p,varargin{:})));

varargout = cell(1,nargin);
for k = 1:length(varargin)
    varargout{k} = varargin{k}(trues);
end