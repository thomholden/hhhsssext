function FRAC=frinv(FRAC)
% fr/frinv - determines element-wise inverse of a fraction
% usage: FRAC = frinv(FRAC);
% 
% arguments:
%  FRAC - fraction object (scalar or array)
%
% See also: rdivide, mrdivide, times

% Author: Ben Petschel 25/7/09
%
% Version history:
%   25/7/09 - first release
%   15/12/09 - bug fix (handles non-doubles correctly)
%   6/10/2012 - bug fix (handles arrays correctly)

if nargin~=1,
  error('fr:frinv:nargin','must have at least one input argument');
end;

for i=1:numel(FRAC)
  K=FRAC(i).whole;
  N=FRAC(i).numer;
  D=FRAC(i).denom;

  % 1/(k+n/d)=d/(kd+n)
  
  if isa(N,'double'),
    FRAC(i).whole=0;
  else
    FRAC(i).whole=N-N; % creates a zero of same type as K,N,D
  end;
  FRAC(i).numer=D;
  FRAC(i).denom=K.*D+N; % not vectorized (this feature broken in 2010a or earlier)

end % for i=1:numel(FRAC)

FRAC=freduce(FRAC); % reduce to lowest common terms
