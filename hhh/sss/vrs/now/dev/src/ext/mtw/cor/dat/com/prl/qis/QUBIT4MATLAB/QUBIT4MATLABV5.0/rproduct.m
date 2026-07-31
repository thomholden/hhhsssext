% rproduct   Random product state vector for a given number of qubits.
%   rproduct(n,d) gives an n-qudit product of random single-qudit state vectors.
%   The dimension of the qudit is 2 (qubits). The distribution of single-qudit 
%   state vectors obtained this way is uniform over the sphere of unit vectors. 
%   If d is not given then it is assumed to be 2 (qubits).
%   If N is not given then it is taken to be equal to the global
%   variable N.

function p=rproduct(varargin)

if isempty(varargin)
    global N;
    d=2;
elseif length(varargin)==1
    N=varargin{1};
    d=2;
elseif length(varargin)==2
    N=varargin{1};
    d=varargin{2};
else
    error('Wrong number of input arguments.')
end %if

% Before normalization, elements of the vector 
% have a normal distribution.
p=randn(d,1)+i*randn(d,1);
p=p/sqrt(p'*p);

for n=1:N-1
   s=randn(d,1)+i*randn(d,1);
   s=s/sqrt(s'*s);
   p=kron(p,s);
end %for
