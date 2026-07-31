% rvec   Random state vector for a given number of qudits.
%   rvec(n,d) gives an n-qudit random state vector,
%   the dimension of the qudit is given in d.
%   The distribution of a state vector obtained this way
%   is uniform over the sphere of unit vectors. If d is 
%   not given then it is assumed to be 2 (qubits).
%   If n is not given then it is taken to be equal to the
%   global variable N.

function s=rvec(varargin)

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

% Generate a random unit vector with complex elements.
% Before normalization, elements of the vector 
% have a normal distribution.
s=randn(d^N,1)+i*randn(d^N,1);
s=s/sqrt(s'*s);