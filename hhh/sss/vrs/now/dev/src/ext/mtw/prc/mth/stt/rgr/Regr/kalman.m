
function [Xhat,Yhat] = kalman(U,Y,A,B,C,D,Rxx,Ryy,Rxy,x0)

%   [Xhat,Yhat] = kalman(U,Y,A,B,C,D,Rxx,Ryy,Rxy,x0)
%   [Xhat,Yhat] = kalman(U,Y,A,B,C,D,Rxx,Ryy,Rxy)
%
% Discrete time Kalman filter.
%
% Input parameters:
%  - U: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - A,B,C,D,Rxx,Ryy,Rxy: System matrices
%  - x0: Initial state (default x0=0)
% Return parameters:
%  - Xhat: State sequence estimate
%  - Yhat: Corresponding output estimate
%
% Heikki Hyotyniemi Sep.13, 2000


[ku,n] = size(U);
[ky,m] = size(Y);
[nA1,nA2] = size(A);
[nB1,nB2] = size(B);
[nC1,nC2] = size(C);
[nD1,nD2] = size(D);
[nRxx1,nRxx2] = size(Rxx);
[nRyy1,nRyy2] = size(Ryy);
[nRxy1,nRxy2] = size(Rxy);
if ky~=ku, disp('Input and output blocks incompatible!'); return; 
else k = ky; end
if nA1~=nA2, disp('System matrix A not square!'); return; 
else d = nA1; end
if nB1~=d | nB2~=n, disp('System matrix B incompatible!'); return; end
if nC2~=d | nC1~=m, disp('System matrix C incompatible!'); return; end
if nD1~=m | nD2~=n, disp('System matrix D incompatible!'); return; end
if nRxx2~=nRxx1 | nRxx1~=d, disp('Covariance matrix Rxx incompatible!'); return; end
if nRyy2~=nRyy1 | nRyy1~=m, disp('Covariance matrix Ryy incompatible!'); return; end
if nRxy1~=d | nRxy2~=m, disp('Covariance matrix Rxy incompatible!'); return; end

barP = zeros(size(A));
for i = 1:100
   barP = A*barP*A' + Rxx - (A*barP*C'+Rxy)*inv(C*barP*C'+Ryy)*(A*barP*C'+Rxy)';
end
K = (A*barP*C'+Rxy)*inv(C*barP*C'+Ryy);

Xhat = zeros(k,d);
Yhat = zeros(k,m);
if nargin==7
   Xhat(1,:) = x0';
end

for i = 1:k-1
   Yhat(i,:) = (C*Xhat(i,:)')' + (D*U(i,:)')';
   Xhat(i+1,:) = (A*Xhat(i,:)')' + (B*U(i,:)')' + (K*(Y(i,:)'-Yhat(i,:)'))';
end
Yhat(k,:) = (C*Xhat(k,:)')' + (D*U(k,:)')';
