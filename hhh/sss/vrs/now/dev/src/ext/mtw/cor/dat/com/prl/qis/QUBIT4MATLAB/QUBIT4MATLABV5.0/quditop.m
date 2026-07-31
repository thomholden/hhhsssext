% quditop   Operator acting on a qudit of a qudit register
%   quditop(op,k,n) defines an n-qudit quantum operator
%   which corresponds to operator op acting on the kth qudits.
%   Qudit position is interpreted as with reorder.
%   The dimension of the qudit is deduced from the size of op.
%   If n is omitted, then its value is taken to be the value of global
%   variable N. If op is sparse, quditop() will also
%   produce a sparse matrix.

function mop=quditop(op,k1,varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if

[sy,sx]=size(op);
d=sx;

% If op is sparse then the result will also be sparse
if issparse(op),
   mop=kron(speye(d^(N-k1)),op);
   mop=kron(mop,speye(d^(k1-1)));
else   
   mop=kron(eye(d^(N-k1)),op);
   mop=kron(mop,eye(d^(k1-1)));
end %if