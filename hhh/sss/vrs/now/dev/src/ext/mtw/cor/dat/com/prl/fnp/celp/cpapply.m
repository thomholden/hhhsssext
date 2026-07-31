function varargout = cpapply(f,x)
%CPAPPLY Analogue of Lisp's APPLY.
%   [Y1,...Ym] = CPAPPLY(F,X) is equivalent to [Y1,...Ym] = F(X{:}).
%
%   Examples
%   --------
%
%   x = cpapply(@min,{rand(10,1),rand(10,1)})

[varargout{1:nargout}] = feval(f,x{:});