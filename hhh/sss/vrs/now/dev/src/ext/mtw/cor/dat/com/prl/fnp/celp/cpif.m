function h = cpif(p,f,g)
%CPIF Conditional composition of functions.
%   PFG = CPIF(P,F,G) returns function PFG s.t.
%   PFG(X) = F(X) if P(X),
%            G(X) otherwise.
%
%   P, F, G should be funhandles otherwise they will wrapped in a function.
%
%   Examples
%   --------
%
%   %Output inputs in ascending order
%   ascend = cpif(@(x,y) x<=y,@deal,@(x,y) deal(y,x));
%   [x,y] = ascend(2,1)
%
%   %Very slow and complicated factorial
%   fact = cpif(@(f,n) n==1,1,@(f,n) f(f,n-1)*n);
%   fact(fact,10)
%
%   %Signum
%   signum = cpif(@(x) x>0,1,cpif(@(x) x<0,-1,0));
%   signum(-10)

    if ~isa(p,'function_handle')
        p = @(varargin) p;
    end
    
    if ~isa(f,'function_handle')
        f = @(varargin) f;
    end
        
    if ~isa(g,'function_handle')
        g = @(varargin) g;
    end
    
    function varargout = pfg(varargin)
        if p(varargin{:})
            [varargout{1:nargout}] = f(varargin{:});
        else
            [varargout{1:nargout}] = g(varargin{:});
        end
    end

    h = @pfg;
end