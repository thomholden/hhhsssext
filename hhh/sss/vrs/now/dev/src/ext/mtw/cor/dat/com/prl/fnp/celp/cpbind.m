function h = cpbind(f,n,g)
%CPBIND Substitution of argument.
%   FG = CPBIND(F,N,G) returns function FG s.t.
%       X                         = G(X1,...,XN-1,XN+1...XN)
%       FG(X1,...,XN-1,XN+1...Xn) = F(X1,...,X...XN)
%   FG = CPBIND(F,N,X) returns function FG s.t.
%       FG(X1,...,XN-1,XN+1...XN) = F(X1,...X,...XN)
%
%   Examples
%   --------
%
%   %Cut
%   cut = cpbind(@max,2,0);
%   plot(cut(sin(0:0.1:4*pi)))
%
%   %Section of sphere
%   ezplot(cpbind(@(x,y) sqrt(1-x.^2-y.^2),2,@(x) x))

if ~isa(g,'function_handle')
    g = @(varargin) g;
end

    function varargout = fg(varargin)
        x = g(varargin{:});
        varargin = [varargin(1:n-1) {x} varargin(n:end)];
        [varargout{1:nargout}] = f(varargin{:});
    end

    h = @fg;
end
