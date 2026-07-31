function y = cpeval(m,f,varargin)
%CPEVAL Evaluate multioutput function and return outputs in cell array.
%   Y = CPEVAL(M,F,X1,...Xn) returns Y = {Y1,...YM} s.t. [Y1,...YM] =
%   F(X1,...Xn).
%
%   Examples
%   --------
%
%   %Getting the second output of sort
%   feval(@(x) x{2},cpeval(2,@sort,rand(100,1)))
%
%   %Applying cell2mat to multiply outputs from cpmap
%   [x,y] = feval(...
%       @(x) deal(x{:}),...
%       cpmap(...
%           @cell2mat,...
%           cpeval(2,@cpmap,@size,{ones(1,2),ones(3,4)})...
%        )...
%   )

    [y{1:m}] = f(varargin{:});
end