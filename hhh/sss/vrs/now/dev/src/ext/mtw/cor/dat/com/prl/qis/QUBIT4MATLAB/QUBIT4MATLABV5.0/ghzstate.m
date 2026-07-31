%ghzstate Defines a GHZ state.
%   ghzstate(n) gives the state vector for an n-qubit GHZ state.
%   If argument n is omitted than the default is taken to be
%   the value of global variable N.

function g=ghzstate(varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if
g=zeros(2^N,1);
g(1)=1/sqrt(2);
g(end)=1/sqrt(2);
