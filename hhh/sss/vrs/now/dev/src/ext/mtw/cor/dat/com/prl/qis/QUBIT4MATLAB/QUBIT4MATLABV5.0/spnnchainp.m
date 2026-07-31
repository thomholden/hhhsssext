% spnnchainp   Defines a Hamiltonian with a(k)b(k+1) nearest-neighbor
%              and periodic boundary condition; sparse version.
%   spnnchainp (a,b,n) defines a a(k)b(k+1) type Hamiltonian
%   with a periodic boundary condition.
%   The Hamiltonian is given as a sparse matrix.
%   If argument n is omitted than the default is taking to be
%   the value of global variable N.

function h=spnnchainp(a,b,varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if
h=sparse(2^N,2^N);
op=kron(a,b);
for n=1:N-1
    h=h+kron(kron(speye(2^(n-1)),op),speye(2^(N-n-1)));
end %for
% Periodic boundary condition
if N>1,
   h=h+kron(kron(b,speye(2^(n-1))),kron(speye(2^(N-n-1)),a));
end %for
