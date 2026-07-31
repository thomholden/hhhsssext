% Receiver Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
#include <math.h>
#include "basetype.h"
#include "util.h"

class Receiver {
    Receiver::Receiver()
    {
    protected:
    int m_bitrate;  // Bitrate in Mb/s
    }

    int
    Receiver::bitrate() const {     // Bitrate in Mb/s
        return m_bitrate;
    }
    Access method not required, using protected property
%}

classdef Receiver < handle
    properties (GetAccess='protected', SetAccess='protected')
        m_bitrate; % Bitrate in Mb/s
    end
end