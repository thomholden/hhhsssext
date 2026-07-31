%rcstate    Defines a ring cluster state.
%   rstate(n) gives the state vector for an n-qubit ring cluster state.
%   If argument n is omitted than the default is taken to be
%   the value of global variable N.

function c=rstate(varargin)
if isempty(varargin),
    global N;
else
    if length(varargin)~=1,
        error('Wrong number of input arguments.')
    end %if
    N=varargin{1};
end %if

x=[0 1;1 0];
z=[1 0;0 -1];
y=i*x*z;

W=0;
for n=1:N-2;
  zxz=kron(kron(z,x),z);
  W=W-kron(kron(eye(2^(n-1)),zxz),eye(2^(N-n-2)));
end %for
W=W-kron(kron(kron(x,z),eye(2^(N-3))),z);
W=W-kron(z,kron(eye(2^(N-3)),kron(z,x)));
[v,d]=eig(W);
[junk,index]=min(diag(d));
c=v(:,index(1));
c=c/sqrt(c'*c);

