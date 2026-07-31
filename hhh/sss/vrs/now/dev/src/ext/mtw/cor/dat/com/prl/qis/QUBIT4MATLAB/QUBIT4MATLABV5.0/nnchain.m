%nnchain   Defines a Hamiltonian with a(k)b(k+1) nearest-neighbor
%          interaction
%   nnchain (a,b,n) defines a a(k)b(k+1) type Hamiltonian
%   with non-periodic boundary condition.
%   If argument n is omitted than the default is taking to be
%   the value of global variable N.

function h=nnchain(a,b,varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if
h=zeros(2^N);
op=kron(a,b);
for n=1:N-1
    h=h+kron(kron(eye(2^(n-1)),op),eye(2^(N-n-1)));
end %for
