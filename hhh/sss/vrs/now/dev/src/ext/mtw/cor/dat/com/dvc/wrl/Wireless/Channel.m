% Channel Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <math.h>
#include "basetype.h"
#include "util.h"
class Channel {
Channel::Channel()
{
}
\\ No constructor required in MATLAB if does nothing
%}

% This class is not necessary, but included here to match C++ code
classdef Channel < handle
end