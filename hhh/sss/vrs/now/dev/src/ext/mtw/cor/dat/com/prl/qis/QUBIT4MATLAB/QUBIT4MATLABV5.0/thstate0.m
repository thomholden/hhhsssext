% thstate0   T=0 thermal state of a system with a given Hamiltonian
%    thstate(H) is the T=0 thermal state of a system described by a
%    Hamiltonian H. The form thstate(H, threshold) makes it possible 
%    to define a treshold. All energy levels above the minimal energy
%    + treshold are unpolpulated. All levels below are equally
%    populated. If the treshold is not given, it is assuemd to be
%    1e-4.

function rho=thstate0(H,varargin);

if nargin==1
    threshold=1e-4;
else
    threshold=varargin{1};
end %if

[v,d]=eig(H);

minE=min(real(diag(d)));

index=find(minE+threshold>=diag(d));

[sy,sx]=size(H);
rho=zeros(sy,sx);
for n=index
    rho=rho+v(:,n)*v(:,n)';
end %for
rho=rho/trace(rho);