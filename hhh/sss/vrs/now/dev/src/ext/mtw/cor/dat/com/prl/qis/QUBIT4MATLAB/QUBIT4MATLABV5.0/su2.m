% su2   SU(2) generators for dxd matrices
%   [Jx,Jy,Jz]=su2(d) gives three generators of the SU(2)
%   group for dxd matrices.

function [Jx,Jy,Jz]=su2(d);

N=d-1;
a1da1=diag([0:N]);
a2da2=diag([N-(0:N)]);
a1da2=zeros(N+1,N+1);
for k=0:N-1
    a1da2(k+1+1,k+1)=sqrt((k+1)*(N-k));   
end %for
a2da1=a1da2';

% Schwinger's construction
Jz=(a1da1-a2da2)/2;
Jx=(a1da2+a2da1)/2;
Jy=-i*(a1da2-a2da1)/2;
