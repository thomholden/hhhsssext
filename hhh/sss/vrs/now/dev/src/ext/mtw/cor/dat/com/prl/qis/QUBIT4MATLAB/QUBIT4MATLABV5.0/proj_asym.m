% proj_asym  Gives the projector to the antisymmetric subspace
%    proj_asym(n)  Gives the projector to the antisymmetric subspace
%    of n qubits. proj_asym(n,d) does the same for qudits with dimension d.
%    Only the n=2 and the d=2 cases are implemented.

function P=proj_asym(N,varargin)

if isempty(varargin),
   d=2;
elseif length(varargin)==1,
   d=varargin{1};
else    
   error('Wrong number of input arguments.');
end %if

if N~=2,
   error('Only the two-qudit case is implemented.');
end %if

if N==2,
    P=zeros(d^2,d^2);
    for n=1:d
        for m=1:n-1
            v=zeros(d^2,1);
            v(n+(m-1)*d)=1;
            v(m+(n-1)*d)=-1;
            P=P+v*v'/2;   
        end %for
    end %for
elseif d==2,
    P=zeros(d^N,d^N);
    for n=0:N
        P=P+ketbra(dstate(n,N));
    end %for
    P=eye(d^2,d^2)-P;
else
    error('Only the two-qudit and the many-qubit cases are implemented.');
end %if

