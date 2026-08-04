function r = sinvchi2rand(nu, s2, M, N)
% SINVCHI2RAND  Random matrices from scaled inverse-chi distribution
%
%  R = SINVCHI2RAND(NU, S2)
%  R = SINVCHI2RAND(NU, S2, M, N)

%   Author: Aki Vehtari <Aki.Vehtari@hut.fi>
%   Last modified: 2004-12-10 10:16:09 EET

% Copyright (c) 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

if nargin < 2
  error('Too few arguments');
end
if nargin < 3
  M=1;
  return;
end
if nargin < 4
  N=1;
end
r=invgamrand(s2,nu,M,N);
