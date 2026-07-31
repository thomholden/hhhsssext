%wstate   Defines a W-state.
%   wstate(n) gives the state vector for an n-qubit wstate.
%   If argument n is omitted than the default is taking
%   the value of global variable N as default.

function w=wstate(varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if
w=zeros(2^N,1);
for n=0:N-1
    w(1+2^n)=1/sqrt(N);
end %for
