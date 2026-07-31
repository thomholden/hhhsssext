% runitary   Random unitary
%    runitary(n,d) creates an n qudit random unitary where d is the 
%    dimension of the qudits. If d is omitted then it is taken to be 2.
%    If argument n is omitted than the default is taken to be
%    the value of global variable N. The random unitaries are 
%    equally distributed over U(d) according to the Haar measure.

function U=runitary(varargin);

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

U=zeros(d^N,d^N);
% Create a random d^Nxd^N unitary
% from d^N orthogonal vectors
for k=1:d^N
    vv=randn(d^N,1)+i*randn(d^N,1); 
    for m=1:k-1
        vv=vv-U(:,m)*(U(:,m)'*vv);
    end %for
    U(:,k)=vv/sqrt(vv'*vv);
end %for 