%spcoll  Defines a collective operator which is the sum of single-qudit
%        operators; sparse version.
%   spcoll (op,n) defines an operator of the type sum_k op(k) where
%   op(k) denotes the operator op acting on qubit k.
%   The operator is given as a sparse matrix.
%   If argument n is omitted than the default is taking to be
%   the value of global variable N. The size of op determines
%   whether we talk about qubits, qudits, etc.

function c=spcoll(op,varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if

% Dimension (d=2 for qubits, d=3 for qutrits, etc.)
d=max(size(op));

c=sparse(d^N,d^N);
for n=1:N
    c=c+kron(kron(speye(d^(n-1)),op),speye(d^(N-n)));
end %for
