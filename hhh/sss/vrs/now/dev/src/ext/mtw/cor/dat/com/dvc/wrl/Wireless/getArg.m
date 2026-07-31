function arg=getArg(argPosition,vararg_in,default)
% Sets a default parameter if not found in varargin list
%
% Copyright 2008-2009 The MathWorks, Inc

if length(vararg_in)>=argPosition
    arg=vararg_in{argPosition};
else
    arg=default; % Default parameters
end