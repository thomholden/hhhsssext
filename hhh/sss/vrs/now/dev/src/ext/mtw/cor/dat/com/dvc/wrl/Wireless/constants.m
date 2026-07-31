% constants Class
%
% Copyright 2008-2009 The MathWorks, Inc

% C++ Code
%{
enum { Ns=44, BPLENGTH=3*Ns-1, DIFFLENGTH=6, DLYBT=2*Ns, BITDELAYBT=2 };
enum { RSLENGTH=33, RBUF=2*Ns, DLY802=30, BITDELAY802=1};
No enumareted types in MATLAB as of R2008a
%}

classdef constants
    properties (Constant)
        Ns=localGetNs;
        BPLENGTH =3*localGetNs-1;
        DIFFLENGTH=6;
        DLYBT =2*localGetNs;  % Not used
        BITDELAYBT=2 ;
        RSLENGTH=33;
        RBUF =2*localGetNs;   % Not used
        DLY802=30;            % Not used
        BITDELAY802=1;
        PI=3.141592654;       % Pi used in C application (less accurate than M)
        twopi = 6.2831853071; % twopi used in C application
        Br = 1.1;             % Bandwidth of Bandpass receiver in MHz

        % C++ Code
        %{
        enum { NsCCK=4, codeLength=8 };
        %}
        % No enumerated types currently in MATLAB. Implemented as constant
        NsCCK=4;       % Number of samples per CCK bit (NsCCK)
        codeLength=8;  % Number of bits per CCK code (codeLength)
    end
end
function y=localGetNs
y=44;
end