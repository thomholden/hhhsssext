% spquditop   Operator acting on a given qudit; sparse version
%   spquditop(op,k,n) defines an n-qudit quantum operator
%   which corresponds to operator op acting on the k1th and k2th qudits.
%   Qudit position is interpreted as with reorder.
%   The dimension of the qudit is deduced from the size of op.
%   If n is omitted, then its value is taken to be the value of global
%   variable N.

function mop=sptwoquditop(op,k1,k2,varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if

kk1=min(k1,k2);
kk2=max(k1,k2);

[sy,sx]=size(op);
d=sx;

mop=kron(speye(d^(N-kk1-1)),op);
mop=kron(mop,speye(d^(kk1-1)));
mop=swapqudits(mop,kk2,kk1+1);