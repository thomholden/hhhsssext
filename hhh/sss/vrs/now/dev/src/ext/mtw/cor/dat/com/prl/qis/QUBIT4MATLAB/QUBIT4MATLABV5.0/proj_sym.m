% proj_sym  Gives the projector to the symmetric subspace
%    proj_sym(n)  Gives the projector to the symmetric subspace
%    of n qubits. proj_sym(n,d) does the same for qudits with dimension d.
%    Only the n=2 and the d=2, d=3 cases are implemented.

function P=proj_sym(N,varargin)

if isempty(varargin),
    d=2;
elseif length(varargin)==1,
    d=varargin{1};
else    
    error('Wrong number of input arguments.');
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
    P=eye(d^2,d^2)-P;
elseif d==2,
    P=zeros(d^N,d^N);
    for n=0:N
        P=P+ketbra(dstate(n,N));
    end %for
elseif d==3
    su3;
    M1=coll(m1,N);
    M2=coll(m2,N);
    M3=coll(m3,N);
    M4=coll(m4,N);
    M5=coll(m5,N);
    M6=coll(m6,N);
    M7=coll(m7,N);
    M8=coll(m8,N);
    H=M1^2+M2^2+M3^2+M4^2+...
      M5^2+M6^2+M7^2+M8^2;
    me=max(real(eig(H)));
    [v,d]=eig(H);
    P=v*(me-0.05<d)*v';
elseif d==4
    paulixyz
    M1=coll(kron(x,e),N);
    M2=coll(kron(y,e),N);
    M3=coll(kron(z,e),N);
    M4=coll(kron(e,x),N);
    M5=coll(kron(e,y),N);
    M6=coll(kron(e,z),N);
    M7=coll(kron(x,x),N);
    M8=coll(kron(x,y),N);
    M9=coll(kron(x,z),N);
   M10=coll(kron(y,x),N);
   M11=coll(kron(y,y),N);
   M12=coll(kron(y,z),N);
   M13=coll(kron(z,x),N);
   M14=coll(kron(z,y),N);
   M15=coll(kron(z,z),N);
    H=M1^2+M2^2+M3^2+M4^2+...
      M5^2+M6^2+M7^2+M8^2+...
      M9^2+M10^2+M11^2+M12^2+...
      M13^2+M14^2+M15^2;
    me=max(real(eig(H)));
    [v,d]=eig(H);
    P=v*(me-0.05<d)*v';
elseif d==9
    su3;
    ma={eye(3),m1,m2,m3,m4,m5,m6,m7,m8};
    H=zeros(d^N,d^N);
    for n=1:9
        for m=1:9
            H=H+coll(kron(ma{n},ma{m}),N)^2;
        end %for
    end %for
    me=max(real(eig(H)))
    [v,d]=eig(H);
    P=v*(me-0.05<d)*v';
else 
    disp('Only d=2, d=3, d=4, d=9 or N=2 is realized.')
end %if

